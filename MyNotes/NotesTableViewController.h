//
//  NotesTableViewController.h
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotesTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *notesArray;

@end

NS_ASSUME_NONNULL_END
