//
//  Note.h
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Note : NSObject
@property NSString *noteId;
@property NSString *noteTitle;
@property NSString *noteCategoryId;
@property NSString *noteContent;
@property NSDate *noteCreatedDate;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content andCategoryId:(NSString *)categoryId;
- (instancetype)initWithId:(NSString *)noteId createdDate:(NSDate *)createdDate title:(NSString *)title content:(NSString *)content andCategoryId:(NSString *)categoryId;

@end

NS_ASSUME_NONNULL_END
