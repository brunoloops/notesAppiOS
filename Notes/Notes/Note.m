//
//  Note.m
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "Note.h"

@implementation Note
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content categoryTitle:(NSString *)categoryTitle andCategoryId:(NSString *)categoryId {
    self = [super init];
    if (self) {
        self.title = title;
        self.content = content;
        self.categoryId = categoryId;
        self.categoryTitle = categoryTitle;
        self.identifier = [[NSUUID UUID] UUIDString];
        self.createdDate = [NSDate date];
    }
    return self;
}

- (instancetype)initWithId:(NSString *)noteId createdDate:(NSDate *)createdDate title:(NSString *)title content:(NSString *)content categoryTitle:(NSString *)categoryTitle andCategoryId:(NSString *)categoryId {
    self = [self initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
    if (self) {
        self.identifier = noteId;
        self.createdDate = createdDate;
    }
    return self;
}
@end
