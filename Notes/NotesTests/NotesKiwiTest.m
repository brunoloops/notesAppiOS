//
//  NotesKiwiTest.m
//  NotesTests
//
//  Created by admin on 1/14/19.
//  Copyright © 2019 admin. All rights reserved.
//
#import "Kiwi.h"
#import "Note.h"

SPEC_BEGIN(NoteCreation)

describe(@"Note", ^{
    it(@"add simple note", ^{
        
        NSString *title = @"Note Title";
        NSString *categoryTitle = @"Category Title";
        NSString *categoryId = @"categoryId";
        NSString *content = @"Content of the note";
        
        Note *note = [[Note alloc] initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
        
        [[theValue(note.title) should] equal:theValue(title)];
        [[theValue(note.categoryId) should] equal:theValue(categoryId)];
        [[theValue(note.categoryTitle) should] equal:theValue(categoryTitle)];
        [[theValue(note.content) should] equal:theValue(content)];
        [[theValue(note.createdDate) shouldNot] beNil];
    });
    it(@"add two notes with different id", ^{
        NSString *title = @"Note Title";
        NSString *categoryTitle = @"Category Title";
        NSString *categoryId = @"categoryId";
        NSString *content = @"Content of the note";
        
        Note *note = [[Note alloc] initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
        Note *note2 = [[Note alloc] initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
        
        [[theValue(note.identifier) shouldNot] equal:theValue(note2.identifier)];
    });
});

SPEC_END
