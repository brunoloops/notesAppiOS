//
//  ViewController.m
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "NotesTableViewController.h"
#import "Note.h"
#import "Category.h"
#import "NoteTableViewCell.h"
#import "DataManager.h"
#import "Notes-Swift.h"

@interface NotesTableViewController ()

@property (nonatomic, strong) NSArray<Note *> *tableData;
@property (readonly) NSString *noteDetailSegueIdentifier;

@end

@implementation NotesTableViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:[DataManager updateNotesNotificationName] object:nil];
}

- (void)refreshTable {
    DataManager *dataManager = [DataManager sharedManager];
    __weak NotesTableViewController *weakSelf = self;
    [dataManager refreshNotesWithCompletionBlock:^(NSArray * _Nullable notes, NSError * _Nullable error) {
        if (!error) {
            weakSelf.tableData = notes;
            [weakSelf.refreshControl endRefreshing];
            [weakSelf.tableView reloadData];
        }
        else {
            UIViewController *alertViewController = [UIAlertController alertControllerWithTitle:@"Error reading data" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertViewController animated:YES completion:^{
                [alertViewController dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.refreshControl endRefreshing];
            }];
            
        }
    }];
}

- (void) reloadData {
    self.tableData = [[DataManager sharedManager] getNotes];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([self.tableData count]) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
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
    cell.createdDateLabel.text = note.readableCreatedDate;
    cell.categoryLabel.text = note.categoryTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:[self noteDetailSegueIdentifier] sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if  ([segue.identifier isEqualToString: [self noteDetailSegueIdentifier]]) {
        NoteDetailsViewController *destination = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        Note *note = [self.tableData objectAtIndex:indexPath.item];
        destination.note = note;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak NotesTableViewController *weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        Note *note = [weakSelf.tableData objectAtIndex:indexPath.row];
        [[DataManager sharedManager] deleteNote:note];
    }];
    return [NSArray arrayWithObject:deleteAction];
}

- (NSString *)noteDetailSegueIdentifier {
    return @"NoteDetail";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
