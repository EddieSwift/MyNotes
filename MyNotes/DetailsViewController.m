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
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.noteForShow) {
        
        self.noteTextView.text = self.noteForShow.content;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneBarButtonAction:(UIBarButtonItem *)sender {
    
    NSLog(@"doneBarButtonAction: %@", self.noteTextView.text);
    
    Note *note = [[Note alloc] init];
    note.content = self.noteTextView.text;
    note.noteDate = [NSDate date];
    
    [self.notesViewController.notesArray addObject:note];
    
    [self.noteTextView resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
