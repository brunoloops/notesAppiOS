//
//  Category.h
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Category : NSObject

@property NSString *categoryId;
@property NSString *categoryTitle;
@property NSDate *categoryCreatedDate;

- (instancetype)initWithId:(NSString *)categoryId title:(NSString *)title andCreatedDate:(NSDate *)createdDate;
- (instancetype)initWithId:(NSString *)categoryId andTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
