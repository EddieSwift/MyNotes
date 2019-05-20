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
    }
    
    if ([self.noteForShow.content length] > 0) {
        
        [self.shareBarButtonItem setEnabled:YES];
    }
}

#pragma mark - Actions

- (IBAction)doneBarButtonAction:(UIBarButtonItem *)sender {
    
    NSLog(@"doneBarButtonAction: %@", self.noteTextView.text);
    
    Note *note = [[Note alloc] init];
    note.content = self.noteTextView.text;
    note.noteDate = [NSDate date];
    
    [self.notesViewController.notesArray addObject:note];
    
    [self.noteTextView resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// Share a note
- (IBAction)shareBarButtonAction:(UIBarButtonItem *)sender {
    
    NSArray *dataToShare = @[self.noteForShow.content];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

@end
