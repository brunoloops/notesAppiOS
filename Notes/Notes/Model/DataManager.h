//
//  DataManager.h
//  Notes
//
//  Created by admin on 1/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+ (NSString *)updateNotesNotificationName;
+ (NSString *)updateCategoriesNotificationName;
+ (NSString *)updateCategoryNotificationNameForCategory:(Category *)category;
+ (NSString *)updateNoteNotificationNameForNote:(Note *)note;

+ (instancetype) sharedManager;

- (void)refreshNotesWithCompletionBlock:(void (^)(NSArray * _Nullable notes, NSError * _Nullable error))completionBlock;
- (NSArray <Category *> *)getCategories;
- (NSArray <Note *> *)getNotes;
- (Category *)getCategoryByTitle:(NSString *)title;
- (Category *)categoryById:(NSString *)categoryId;
- (Note *)noteById:(NSString *)noteId;

- (void)addNote:(Note *)note;
- (void)editNote:(Note *)note withError:(NSError **)error;
- (void)deleteNote:(Note *)note;

- (void)addCategory:(Category *)category;
- (void)editCategory:(Category *)category withError:(NSError **)error;
- (void)deleteCategory:(Category *)category;

@end

NS_ASSUME_NONNULL_END
