//
//  DetailsViewController.m
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "DetailsViewController.h"
#import "NotesTableViewController.h"

@interface DetailsViewController ()

@property (assign, nonatomic) BOOL isNoteChosen;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.noteTextView becomeFirstResponder];
    
    [self.shareBarButtonItem setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.noteForShow) {
        
        self.noteTextView.text = self.noteForShow.content;
        self.isNoteChosen = YES;
    }
    
    if ([self.noteForShow.content length] > 0) {
        
        [self.shareBarButtonItem setEnabled:YES];
    }
}

#pragma mark - Actions

- (IBAction)doneBarButtonAction:(UIBarButtonItem *)sender {
    
    
    if (!self.isNoteChosen) {
        
        if ([self.noteTextView.text length] > 0) {
            
            NSError *error = nil;
            Note *note = [Note noteWithContent:self.noteTextView.text inManagedObjectContext:self.managedObjectContext];
            [note.managedObjectContext save:nil];
            
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"%@", [error localizedDescription]);
            }
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
            
            [request setEntity:description];
            
            NSError *requestError = nil;
            
            if (requestError) {
                NSLog(@"ERROR: %@", [requestError localizedDescription]);
            }
            
            self.currentNoteID = note.noteID;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        
        [self changeNote];
    }
    
    [self.noteTextView resignFirstResponder];
}

- (void)changeNote {
    
    if ([self.noteTextView.text length] > 0) {
        
        self.noteForShow.content = self.noteTextView.text;
        self.noteForShow.noteDate = [NSDate date];
        
        [self.noteForShow.managedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Share a note
- (IBAction)shareBarButtonAction:(UIBarButtonItem *)sender {
    
    NSArray *dataToShare = @[self.noteForShow.content];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[[DataManager sharedManager] persistentContainer] viewContext];
    }
    
    return _managedObjectContext;
}

- (NSFetchedResultsController*)fetchedResultsController {
    return nil;
}

@end
