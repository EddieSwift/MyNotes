//
//  NotesTableViewController.m
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "NotesTableViewController.h"
#import "DetailsViewController.h"
#import "NoteTableViewCell.h"

@interface NotesTableViewController ()

@end

@implementation NotesTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.notesArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"self.notesArray count: %ld", [self.notesArray count]);
 
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.notesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";

    NoteTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[NoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Note *note = [self.notesArray objectAtIndex:indexPath.row];
    
    NSString *showNoteContent = note.content;
    
    // Output max length of note
    if ([showNoteContent length] > 100) {
        
        showNoteContent = [showNoteContent substringToIndex:100];
    }
    
    cell.contentLabel.text = showNoteContent;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy"];
    cell.dateLabel.text = [dateFormatter stringFromDate:note.noteDate];
    
    [dateFormatter setDateFormat:@"hh:mm"];
    cell.timeLabel.text = [dateFormatter stringFromDate:note.noteDate];
    
    return cell;
}

// Deleting notes

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.notesArray removeObjectAtIndex:indexPath.row];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
}

#pragma mark - Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"addNewNoteSegue"]) {
        
        DetailsViewController *detailViewController = (DetailsViewController*)segue.destinationViewController;
        detailViewController.notesViewController = self;
    }
    
    if ([segue.identifier isEqualToString:@"selectNoteSeque"]) {
        
        DetailsViewController *noteDetailViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        noteDetailViewController.noteForShow = self.notesArray[selectedIndexPath.row];
    }
}

@end
