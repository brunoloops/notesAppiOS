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

    func testAddCategory() {
        let title = "Category title"
        let category = Category.init(title:title)
        
        DataManager.shared().add(category)
        
        let categories = DataManager.shared().getCategories()
        let lastCategoryAdded = categories.last
        
        expect(title).to(equal(lastCategoryAdded?.title))
    }
    
    func testEditCategory() {
      let newTitle = "New Category title"
      let categoryToEdit = DataManager.shared().getCategories().last!
      let newCategory = Category.init(title:newTitle)
      newCategory.identifier = categoryToEdit.identifier
      DataManager.shared().edit(newCategory, withError: nil)


      let categoryEdited = DataManager.shared().category(byId: categoryToEdit.identifier)

      expect(categoryEdited.title).to(equal(newTitle))
    }
    
    func testEditCategoryTitle() {
      let note = DataManager.shared().getNotes().first!
      let category = DataManager.shared().getCategoryByTitle(note.categoryTitle)
      let newTitle = "This is the new category title"

      category.title = newTitle
      DataManager.shared().edit(category, withError: nil)
      let newNote = DataManager.shared().getNotes().first!

      expect(newNote.categoryTitle).to(equal(newTitle))
    }
    
    func testDeleteCategory() {
      let categories = DataManager.shared().getCategories()
      let categoriesCount = categories.count
      
      DataManager.shared().delete(categories.last!)
      let newCategories = DataManager.shared().getCategories()
      
      expect(categoriesCount - 1).to(equal(newCategories.count))
    }
    
    func testDeleteNote() {
      let notes = DataManager.shared().getNotes()
      let notesCount = notes.count
      
      DataManager.shared().delete(notes.last!)
      let newNotes = DataManager.shared().getNotes()
      
      expect(notesCount - 1).to(equal(newNotes.count))
    }
}
