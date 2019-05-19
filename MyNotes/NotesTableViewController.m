//
//  NotesTableViewController.m
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "NotesTableViewController.h"
#import "DetailsViewController.h"

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

    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Note *note = [self.notesArray objectAtIndex:indexPath.row];
    
    NSString *showNoteContent = note.content;
    
    // Output max length of note
    if ([showNoteContent length] > 100) {
        
        showNoteContent = [showNoteContent substringToIndex:100];
    }
    
    cell.textLabel.text = showNoteContent;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
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
