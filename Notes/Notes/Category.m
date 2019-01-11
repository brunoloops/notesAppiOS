//
//  Category.m
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "Category.h"

@implementation Category

- (instancetype)initWithId:(NSString *)categoryId andTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.identifier = categoryId;
        self.title = title;
        self.createdDate = [NSDate date];
    }
    return self;
}
- (instancetype)initWithId:(NSString *)categoryId title:(NSString *)title andCreatedDate:(NSDate *)createdDate{
    self = [self initWithId:categoryId andTitle:title];
    if (self) {
        self.createdDate = createdDate;
    }
    return self;
}
@end
