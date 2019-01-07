//
//  Note.m
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "Note.h"

@implementation Note
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content andCategoryId:(NSString *)categoryId {
    self = [super init];
    if (self) {
        self.noteTitle = title;
        self.noteContent = content;
        self.noteCategoryId = categoryId;
        self.noteId = [[NSUUID UUID] UUIDString];
        self.noteCreatedDate = [NSDate date];
    }
    return self;
}

- (instancetype)initWithId:(NSString *)noteId createdDate:(NSDate *)createdDate title:(NSString *)title content:(NSString *)content andCategoryId:(NSString *)categoryId{
    self = [self initWithTitle:title content:content andCategoryId:categoryId];
    if (self) {
        self.noteId = noteId;
        self.noteCreatedDate = createdDate;
    }
    return self;
}
@end
