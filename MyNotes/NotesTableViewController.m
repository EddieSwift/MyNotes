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
#import "DataManager.h"

@interface NotesTableViewController ()

@property (strong, nonatomic) NSMutableArray *filteredNotes;
@property (assign, nonatomic) BOOL isFiltered;

@end

@implementation NotesTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"Note"
                inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    // Pagination - loading per 20 notes from the database
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor* dateDescription =
    [[NSSortDescriptor alloc] initWithKey:@"noteDate" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[dateDescription]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return !self.isFiltered ? [sectionInfo numberOfObjects] : [self.filteredNotes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[NoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *showNoteContent = [[NSString alloc] init];
    
    if (!self.isFiltered) {
        
        Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        showNoteContent = note.content;
        
        // Output max length of note
        showNoteContent = [self substringNote:showNoteContent];
        
        cell.contentLabel.text = showNoteContent;
        
        [dateFormatter setDateFormat:@"dd.MM.yy"];
        cell.dateLabel.text = [dateFormatter stringFromDate:note.noteDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        cell.timeLabel.text = [dateFormatter stringFromDate:note.noteDate];
        
    } else {
        
        Note *note = [self.filteredNotes objectAtIndex:indexPath.row];
        
        showNoteContent = note.content;
        
        // Output max length of note
        showNoteContent = [self substringNote:showNoteContent];
        
        cell.contentLabel.text = showNoteContent;
        
        [dateFormatter setDateFormat:@"dd.MM.yy"];
        cell.dateLabel.text = [dateFormatter stringFromDate:note.noteDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        cell.timeLabel.text = [dateFormatter stringFromDate:note.noteDate];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteNote:indexPath];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Note *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = note.content;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *updateAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Update" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [self updateNote:indexPath];
        
        [self.tableView setEditing:NO];
    }];
    updateAction.backgroundColor = [UIColor grayColor];
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        [self deleteNote:indexPath];
    }];
    
    return @[deleteAction, updateAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailsViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsNote"];
    Note *passNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
    detailViewController.noteForShow = passNote;
    [self.navigationController pushViewController:detailViewController animated:YES];
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
        
        [self filterNotes:searchText];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[[DataManager sharedManager] persistentContainer] viewContext];
    }
    
    return _managedObjectContext;
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:newIndexPath];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
}

#pragma mark - Help Methods

- (void) updateNote:(NSIndexPath*) indexPath {
    
    DetailsViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsNote"];
    
    Note *passNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
    detailViewController.noteForShow = passNote;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void) deleteNote:(NSIndexPath*) indexPath {
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

// Output max length of note
- (NSString*) substringNote:(NSString*) noteContent {
    
    if ([noteContent length] > 100) {
        
        return [noteContent substringToIndex:100];
    }
    
    return noteContent;
}

- (void) filterNotes:(NSString*) searchText {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Note" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"content" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"content CONTAINS[cd] %@", searchText];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    
    NSArray* loadedEntities = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.filteredNotes = [[NSMutableArray alloc] initWithArray:loadedEntities];
    
    [self.tableView reloadData];
}

@end
