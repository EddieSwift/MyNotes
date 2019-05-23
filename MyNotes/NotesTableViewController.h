//
//  NotesTableViewController.h
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Note+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotesTableViewController : UITableViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortBarButtonItem;

- (IBAction)sortBurButtonAction:(UIBarButtonItem *)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
