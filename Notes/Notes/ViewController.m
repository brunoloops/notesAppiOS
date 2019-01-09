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
#import "Notes-Swift.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray<Note *> *tableData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoteTableViewCell" bundle:nil] forCellReuseIdentifier:[NoteTableViewCell identifier]];
    [self refreshTable];
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = self.refreshControl;
    } else {
        [self.tableView addSubview:self.refreshControl];
    }
}

- (void)refreshTable {
    DataManager *dataManager = [DataManager sharedManager];
    __weak ViewController *weakSelf = self;
    [dataManager getNotesWithCompletionBlock:^(NSArray * _Nonnull notes, NSError *error) {
        if (!error) {
            weakSelf.tableData = notes;
            [weakSelf.refreshControl endRefreshing];
            [weakSelf.tableView reloadData];
        }
        else {
            UIViewController *alertViewController = [UIAlertController alertControllerWithTitle:@"Error reading data" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertViewController animated:TRUE completion:^{
                [alertViewController dismissViewControllerAnimated:TRUE completion:nil];
                [weakSelf.refreshControl endRefreshing];
            }];
            
        }
    }];
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
    cell.createdDateLabel.text = [note readableCreatedDate];
    cell.categoryLabel.text = note.categoryTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"NoteDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if  ([segue.identifier isEqualToString: @"NoteDetail"]) {
        NoteDetailsViewController *destination = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        Note *note = [self.tableData objectAtIndex:indexPath.item];
        destination.note = note;
    }
}

@end
