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

@property (strong, nonatomic) NSMutableArray *filteredNotes;
@property (assign, nonatomic) BOOL isFiltered;

@end

@implementation NotesTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
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
    
    return !self.isFiltered ?  [self.notesArray count] : [self.filteredNotes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    NoteTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[NoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *showNoteContent = [[NSString alloc] init];
    
    if (!self.isFiltered) {
        
        Note *note = [self.notesArray objectAtIndex:indexPath.row];
        
        showNoteContent = note.content;
        
        // Output max length of note
        showNoteContent = [self substringNote:showNoteContent];
        
        cell.contentLabel.text = showNoteContent;
        
        [dateFormatter setDateFormat:@"dd.MM.yy"];
        cell.dateLabel.text = [dateFormatter stringFromDate:note.noteDate];
        
        [dateFormatter setDateFormat:@"hh:mm"];
        cell.timeLabel.text = [dateFormatter stringFromDate:note.noteDate];
        
    } else {
        
        Note *note = [self.filteredNotes objectAtIndex:indexPath.row];
        
        showNoteContent = note.content;
        
        // Output max length of note
        showNoteContent = [self substringNote:showNoteContent];
        
        cell.contentLabel.text = showNoteContent;
        
        [dateFormatter setDateFormat:@"dd.MM.yy"];
        cell.dateLabel.text = [dateFormatter stringFromDate:note.noteDate];
        
        [dateFormatter setDateFormat:@"hh:mm"];
        cell.timeLabel.text = [dateFormatter stringFromDate:note.noteDate];
    }
    
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

#pragma mark - Help Methods

// Output max length of note
- (NSString*) substringNote:(NSString*) noteContent {
    
    if ([noteContent length] > 100) {
        
        return [noteContent substringToIndex:100];
    }
    
    return noteContent;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
}

#pragma mark - Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"addNewNoteSegue"]) {
        
        DetailsViewController *detailViewController = (DetailsViewController*)segue.destinationViewController;
        detailViewController.notesViewController = self;
        
    } else if ([segue.identifier isEqualToString:@"selectNoteSeque"]) {
        
        DetailsViewController *noteDetailViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        noteDetailViewController.noteForShow = self.notesArray[selectedIndexPath.row];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        
        self.isFiltered = false;
        
        [self.searchBar endEditing:YES];
        
    } else {
        
        self.isFiltered = true;
        
        self.filteredNotes = [[NSMutableArray alloc] init];
        
        for (Note *note in self.notesArray) {
            
            NSRange range = [note.content rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (range.location != NSNotFound) {
                
                [self.filteredNotes addObject:note];
            }
        }
    }
    
    [self.tableView reloadData];
}

@end
