//
//  NotesTests.m
//  NotesTests
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Note.h"
#import "Category.h"
#import "DataManager.h"

@interface NotesModelTest : XCTestCase

@end

@implementation NotesModelTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCreateNoteSimple {
    NSString *title = @"Note Title";
    NSString *categoryTitle = @"Category Title";
    NSString *categoryId = @"categoryId";
    NSString *content = @"Content of the note";
    
    Note *note = [[Note alloc] initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
    
    NSAssert([note.title isEqualToString:title], @"Note title not match");
    NSAssert([note.categoryId isEqualToString:categoryId], @"Note category id not match");
    NSAssert([note.categoryTitle isEqualToString:categoryTitle], @"Note category title not match");
    NSAssert([note.content isEqualToString:content], @"Note content not match");
    NSAssert(note.createdDate, @"Note without date");
}

- (void)testCreateTwoNotesDiffID {
    NSString *title = @"Note Title";
    NSString *categoryTitle = @"Category Title";
    NSString *categoryId = @"categoryId";
    NSString *content = @"Content of the note";
    
    Note *note = [[Note alloc] initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
    Note *note2 = [[Note alloc] initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
    
    NSAssert(![note.identifier isEqualToString:note2.identifier], @"Two notes wit same id");
}

- (void)testCreateNoteComplete {
    NSString *identifier = @"noteID";
    NSString *title = @"Note Title";
    NSString *categoryTitle = @"Category Title";
    NSString *categoryId = @"categoryId";
    NSString *content = @"Content of the note";
    NSDate *createdDate = [NSDate date];
    
    Note *note = [[Note alloc] initWithId:identifier createdDate:createdDate title:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
    
    NSAssert([note.identifier isEqualToString:identifier], @"Note identifier not match");
    NSAssert([note.title isEqualToString:title], @"Note title not match");
    NSAssert([note.categoryId isEqualToString:categoryId], @"Note category id not match");
    NSAssert([note.categoryTitle isEqualToString:categoryTitle], @"Note category title not match");
    NSAssert([note.content isEqualToString:content], @"Note content not match");
    NSAssert([note.createdDate isEqualToDate:createdDate], @"Note date not match");
}

- (void)testCreateCategorySimple {
    NSString *title = @"Category Title";
    NSString *identifier = @"categoryID";
    
    Category *category = [[Category alloc] initWithId:identifier andTitle:title];
    
    NSAssert([category.title isEqualToString:title], @"Category title not match");
    NSAssert([category.identifier isEqualToString:identifier], @"Category identifier not match");
    NSAssert(category.createdDate, @"Category without date");
}

- (void)testCreateCategoryComplete {
    NSString *identifier = @"categoryID";
    NSString *title = @"Category Title";
    NSDate *createdDate = [NSDate date];
    
    Category *category = [[Category alloc] initWithId:identifier title:title andCreatedDate:createdDate];
    
    NSAssert([category.identifier isEqualToString:identifier], @"Note identifier not match");
    NSAssert([category.title isEqualToString:title], @"Note title not match");
    NSAssert([category.createdDate isEqualToDate:createdDate], @"Note date not match");
}

- (void)testRefreshNotes {
    [[DataManager sharedManager] refreshNotesWithCompletionBlock:^(NSArray * _Nullable notes, NSError * _Nullable error) {
        NSAssert(!error, @"Error found refreshing notes");
        NSAssert([notes count], @"Notes came empty");
    }];
}

- (void)testAddNote {
    NSString *title = @"Note Title";
    NSString *categoryTitle = @"Category Title";
    NSString *categoryId = @"categoryId";
    NSString *content = @"Content of the note";
    
    Note *note = [[Note alloc] initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
    NSArray <Note *> *notes = [[DataManager sharedManager] getNotes];
    
    NSAssert([notes count] == 6, @"Initial notes error");
    
    [[DataManager sharedManager] addNote:note];
    notes = [[DataManager sharedManager] getNotes];
    Note *addedNote = [notes lastObject];
    
    NSAssert([notes count] == 7, @"Note not added");
    NSAssert([addedNote.identifier isEqualToString:note.identifier], @"Note added diferent from created");
}

- (void)testEditNote {
    NSString *title = @"Note Title";
    NSString *categoryTitle = @"Category Title";
    NSString *categoryId = @"categoryId";
    NSString *content = @"Content of the note";
    
    Note *note = [[Note alloc] initWithTitle:title content:content categoryTitle:categoryTitle andCategoryId:categoryId];
    [[DataManager sharedManager] addNote:note];
    content = @"Diferent content of the note";
    note.content = content;
    [[DataManager sharedManager] editNote:note];
    Note *editedNote = [[DataManager sharedManager] noteById:note.identifier];
    
    NSAssert([editedNote.identifier isEqualToString:note.identifier], @"Note added diferent from created");
    NSAssert([editedNote.content isEqualToString:content], @"Content not edited");
}

@end
