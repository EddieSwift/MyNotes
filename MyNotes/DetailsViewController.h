//
//  DetailsViewController.h
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@class NotesTableViewController;

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) NotesTableViewController *notesViewController;
@property (strong, nonatomic) Note *noteForShow;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButtonItem;

- (IBAction)doneBarButtonAction:(UIBarButtonItem *)sender;
- (IBAction)shareBarButtonAction:(UIBarButtonItem *)sender;


@end

NS_ASSUME_NONNULL_END
