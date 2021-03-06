//
//  DataManager.m
//  Notes
//
//  Created by admin on 1/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property (atomic, strong) NSMutableArray *notes;
@property (atomic, strong) NSMutableArray *categories;

@end

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DataManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.notes = [NSMutableArray array];
        self.categories = [NSMutableArray array];
    }
    return self;
}

- (void)refreshNotesWithCompletionBlock:(void (^)(NSArray * _Nullable notes, NSError * _Nullable error))completionBlock {
    NSString *urlAsString = [NSString stringWithFormat:@"https://s3.amazonaws.com/kezmo.assets/sandbox/notes.json"];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlAsString stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    // Success
                    NSDictionary *notesDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:0
                                                                                      error:&error];
                    if (!error) {
                        NSArray *notes = [self parseJsonData:notesDictionary];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateNotesNotificationName] object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateCategoriesNotificationName] object:nil];
                            completionBlock(notes, nil);
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(nil, error);
                        });
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(nil, error);
                    });
                }
            }] resume];
}

- (NSArray *)parseJsonData:(NSDictionary *)notesDictionary{
    NSMutableArray <Category *> *categoryArray = [NSMutableArray new];
    NSArray *parseNotes = [notesDictionary objectForKey:@"notes"];
    NSArray *parseCategories = [notesDictionary objectForKey:@"categories"];
    for (NSDictionary *element in parseCategories){
        NSString *categoryId = [element objectForKey:@"id"];
        NSString *categoryTitle = [element objectForKey:@"title"];
        NSDate *categoryCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[element objectForKey:@"createdDate"] integerValue]];
        Category *category = [[Category alloc] initWithId:categoryId title:categoryTitle andCreatedDate:categoryCreatedDate];
        [categoryArray addObject:category];
    }
    self.categories = categoryArray;
    
    NSMutableArray <Note *> *noteArray = [NSMutableArray new];
    for (NSDictionary *element in parseNotes){
        NSString *noteId = [element objectForKey:@"id"];
        NSString *noteTitle = [element objectForKey:@"title"];
        NSString *noteContent = [element objectForKey:@"content"];
        NSString *noteCategoryId = [element objectForKey:@"categoryId"];
        NSDate *noteCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[element objectForKey:@"createdDate"] integerValue]];
        Category *categoryNote = [self categoryById:noteCategoryId];
        Note *note = [[Note alloc] initWithId: noteId createdDate:noteCreatedDate  title:noteTitle content:noteContent categoryTitle:categoryNote.title andCategoryId:noteCategoryId];
        [noteArray addObject:note];
    }
    self.notes = noteArray;
    
    return [NSArray arrayWithArray:noteArray];
}

- (NSArray <Category *> *)getCategories {
    return [NSArray arrayWithArray:self.categories];
}

- (NSArray <Note *> *)getNotes {
    return [NSArray arrayWithArray:self.notes];
}

- (Category *)getCategoryByTitle:(NSString *)title {
    __block Category *categoryNote;
    [self.categories enumerateObjectsUsingBlock:^(Category * _Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([category.title isEqualToString:title]){
            categoryNote = category;
        }
    }];
    return categoryNote;}

- (Category *)categoryById:(NSString *)categoryId {
    __block Category *categoryFound;
    [self.categories enumerateObjectsUsingBlock:^(Category * _Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([category.identifier isEqualToString:categoryId]){
            categoryFound = category;
        }
    }];
    return categoryFound;
}

- (Note *)noteById:(NSString *)noteId {
    __block Note *noteFound;
    [self.notes enumerateObjectsUsingBlock:^(Note * _Nonnull note, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([note.identifier isEqualToString:noteId]){
            noteFound = note;
        }
    }];
    return noteFound;
}

- (void)addNote:(Note *)note {
    [self.notes addObject:note];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateNotesNotificationName] object:note];
}

- (void)editNote:(Note *)note withError:(NSError * _Nonnull *)error {
    Note *tmpNote = [self noteById:note.identifier];
    if (!tmpNote) {
        *error = [NSError errorWithDomain:@"com.OrangeLoops.Notes.ErrorDomain" code:NSNotFound userInfo:nil];
        return;
    }
    NSInteger index = [self.notes indexOfObject:tmpNote];
    [self.notes replaceObjectAtIndex:index withObject:note];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateNoteNotificationNameForNote:note] object:note];
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateNotesNotificationName] object:note];
}

- (void)deleteNote:(Note *)note {
    Note *tmpNote = [self noteById:note.identifier];
    [self.notes removeObject:tmpNote];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateNotesNotificationName] object:note];
}

- (void)addCategory:(Category *)category {
    [self.categories addObject:category];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateCategoriesNotificationName] object:category];
}

- (void)editCategory:(Category *)category withError:(NSError * _Nonnull *)error {
    Category *tmpCategory = [self categoryById:category.identifier];
    if (!tmpCategory) {
        *error = [NSError errorWithDomain:@"com.OrangeLoops.Notes.ErrorDomain" code:NSNotFound userInfo:nil];
        return;
    }
    NSInteger index = [self.categories indexOfObject:tmpCategory];
    [self.categories replaceObjectAtIndex:index withObject:category];
    [self updateNotesWithCategory:category];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateCategoriesNotificationName] object:category];
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateCategoryNotificationNameForCategory:category] object:category];
}

- (void)deleteCategory:(Category *)category {
    Category *tmpCategory = [self categoryById:category.identifier];
    [self.categories removeObject:tmpCategory];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateCategoriesNotificationName] object:category];
}

- (void)updateNotesWithCategory:(Category *)category {
    [self.notes enumerateObjectsUsingBlock:^(Note *_Nonnull note, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([note.categoryId isEqualToString:category.identifier]) {
            note.categoryTitle = category.title;
            [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateNoteNotificationNameForNote:note] object:note];
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:[DataManager updateNotesNotificationName] object:nil];
}

+ (NSString *)updateNoteNotificationNameForNote:(Note *)note {
    return [@"UpdateNote_" stringByAppendingString:note.identifier];
}

+ (NSString *)updateNotesNotificationName {
    return @"UpdateAllNotes";
}

+ (NSString *)updateCategoriesNotificationName {
    return @"UpdateAllCategories";
}

+ (NSString *)updateCategoryNotificationNameForCategory:(Category *)category {
    return [@"UpdateCategory_" stringByAppendingString:category.identifier];
}


@end
