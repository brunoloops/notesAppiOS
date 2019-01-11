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
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *categoryTitle;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *createdDate;
@property (readonly) NSString *readableCreatedDate;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content categoryTitle:(NSString *)categoryTitle andCategoryId:(NSString *)categoryId;
- (instancetype)initWithId:(NSString *)noteId createdDate:(NSDate *)createdDate title:(NSString *)title content:(NSString *)content categoryTitle:(NSString *)categoryTitle andCategoryId:(NSString *)categoryId;

@end

NS_ASSUME_NONNULL_END
