//
//  Category.h
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
NS_ASSUME_NONNULL_BEGIN

@interface Category : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *createdDate;

- (instancetype)initWithId:(NSString *)categoryId title:(NSString *)title andCreatedDate:(NSDate *)createdDate;
- (instancetype)initWithId:(NSString *)categoryId andTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
