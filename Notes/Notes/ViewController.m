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
#import "DataManager.h"
#import <JGProgressHUD.h>

@interface ViewController ()

    @property NSArray<Note *> *tableData;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoteTableViewCell" bundle:nil] forCellReuseIdentifier:[NoteTableViewCell identifier]];
    DataManager *dataManager = [DataManager sharedManager];
    self.tableData = dataManager.notes;
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Loading";
    [HUD showInView:self.view];
    [HUD dismissAfterDelay:3.0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([self.tableData count]) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Note *note = [self.tableData objectAtIndex:indexPath.item];
    
     NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NoteTableViewCell identifier]];
    if (!cell)
        cell = [NoteTableViewCell new];
    cell.titleLabel.text = note.title;
    cell.contentLabel.text = note.content;
    cell.contentLabel.textContainer.maximumNumberOfLines = 2;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    cell.createdDateLabel.text = [formatter stringFromDate:note.createdDate];
    cell.categoryLabel.text = note.categoryTitle;
    return cell;
}

@end
