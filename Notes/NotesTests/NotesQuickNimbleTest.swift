//
//  NotesQuickNimbleTest.swift
//  NotesTests
//
//  Created by admin on 1/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import XCTest
import Nimble

class NotesQuickNimbleTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateNote() {
        let title = "Note title"
        let categoryTitle = "Category title"
        let categoryId = "categoryId"
        let content = "This is the content of the note"
        
        let note = Note.init(title: title, content: content, categoryTitle: categoryTitle, andCategoryId: categoryId)
        
        expect(title).to(equal(note.title))
        expect(content).to(equal(note.content))
        expect(categoryId).to(equal(note.categoryId))
        expect(categoryTitle).to(equal(note.categoryTitle))
        expect(note.createdDate).notTo(beNil())
    }

}
