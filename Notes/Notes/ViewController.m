//
//  ViewController.m
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import "Note.h"
#import "Category.h"
#import "NoteTableViewCell.h"

@interface ViewController ()

    @property NSMutableArray<Category *> *categoryData;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoteTableViewCell" bundle:nil] forCellReuseIdentifier:[NoteTableViewCell identifier]];
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"notes"
                                                         ofType:@"json"];

    self.categoryData = [NSMutableArray new];
    //check file exists
    if (fileName) {
        //retrieve file content
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:fileName];
        
        //convert JSON NSData to a usable NSDictionary
        NSError *error;
        NSDictionary *notesDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:0
                                                                error:&error];
        
        
        if (error) {
            NSLog(@"Something went wrong! %@", error.localizedDescription);
        }
        else {
            NSArray *notes = [notesDictionary objectForKey:@"notes"];
            NSArray *categories = [notesDictionary objectForKey:@"categories"];
            for (NSDictionary *element in categories){
                NSString *categoryId = [element objectForKey:@"id"];
                NSString *categoryTitle = [element objectForKey:@"title"];
                NSDate *categoryCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[element objectForKey:@"createdDate"] integerValue]];
                Category *category = [[Category alloc] initWithId:categoryId title:categoryTitle andCreatedDate:categoryCreatedDate];
                [self.categoryData addObject:category];
            }
            for (NSDictionary *element in notes){
                NSString *noteId = [element objectForKey:@"id"];
                NSString *noteTitle = [element objectForKey:@"title"];
                NSString *noteContent = [element objectForKey:@"content"];
                NSString *noteCategoryId = [element objectForKey:@"categoryId"];
                NSDate *noteCreatedDate = [NSDate dateWithTimeIntervalSince1970:[[element objectForKey:@"createdDate"] integerValue]];
                Note *note = [[Note alloc] initWithId: noteId createdDate:noteCreatedDate  title:noteTitle content:noteContent andCategoryId:noteCategoryId];
                Category *categoryNote = [self categoryById:noteCategoryId];
                [categoryNote.notes addObject:note];
            }
            
        }
    }
    else {
        NSLog(@"Couldn't find file!");
    }    // Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.categoryData count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Category *category = [self.categoryData objectAtIndex:section];
    return [category.notes count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Category *category = [self.categoryData objectAtIndex:section];
    return category.categoryTitle;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Category *category = [self.categoryData objectAtIndex:indexPath.section];
    Note *note = [category.notes objectAtIndex:indexPath.item];
    
     NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NoteTableViewCell identifier]];
    if (!cell)
        cell = [NoteTableViewCell new];
    cell.titleLabel.text = note.noteTitle;
    cell.contentLabel.text = note.noteContent;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    cell.createdDateLabel.text = [formatter stringFromDate:note.noteCreatedDate];
    return cell;
}

- (Category *)categoryById:(NSString *)categoryId{
    __block Category *categoryNote;
    [self.categoryData enumerateObjectsUsingBlock:^(Category * _Nonnull category, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([category.categoryId isEqualToString:categoryId]){
            categoryNote = category;
        }
    }];
    return categoryNote;
}
@end
