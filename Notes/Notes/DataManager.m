//
//  DataManager.m
//  Notes
//
//  Created by admin on 1/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property (nonatomic, strong) NSArray *notes;
@property (nonatomic, strong) NSArray *categories;

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
    }
    return self;
}
- (void)getNotesWithCompletionBlock:(void (^)(NSArray * _Nonnull, NSError *error))completionBlock {
    NSString *urlAsString = [NSString stringWithFormat:@"https://s3.amazonaws.com/kezmo.assets/sandbox/notes.json"];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlAsString stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    // Success
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        completionBlock([self parseJsonData:data], nil);
                        
                    }  else {
                        completionBlock([NSArray new], [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:NULL]);
                    }
                } else {
                    // Fail
                    completionBlock([NSArray new], error);
                }
            }] resume];
}
- (NSArray *)parseJsonData:(NSData *)jsonData{
    //convert JSON NSData to a usable NSDictionary
    NSError *error;
    NSDictionary *notesDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:0
                                                                      error:&error];
    
    if (error) {
        NSLog(@"Something went wrong! %@", error.localizedDescription);
    }
    else {
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
        self.categories = [NSArray arrayWithArray:categoryArray];
        
        NSMutableArray <Note *> *noteArray = [NSMutableArray new];
        for (NSDictionary *element in parseNotes){
            NSString *noteId = [element objectForKey:@"id"];
            NSString *noteTitle = [element objectForKey:@"title"];
            NSString *noteContent = [element objectForKey:@"content"];
            NSString *noteCategoryId = [element objectForKey:@"categoryId"];
            NSDate *noteCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[element objectForKey:@"createdDate"] integerValue]];
            __block Category *categoryNote;
            [categoryArray enumerateObjectsUsingBlock:^(Category * _Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([category.identifier isEqualToString:noteCategoryId]){
                    categoryNote = category;
                }
            }];
            Note *note = [[Note alloc] initWithId: noteId createdDate:noteCreatedDate  title:noteTitle content:noteContent categoryTitle:categoryNote.title andCategoryId:noteCategoryId];
            [noteArray addObject:note];
        }
        self.notes = [NSArray arrayWithArray:noteArray];
    }
    return self.notes;
}

 - (Category *)categoryById:(NSString *)categoryId{
     __block Category *categoryNote;
     [self.categories enumerateObjectsUsingBlock:^(Category * _Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
         if ([category.identifier isEqualToString:categoryId]){
             categoryNote = category;
         }
     }];
     return categoryNote;
 }


@end
