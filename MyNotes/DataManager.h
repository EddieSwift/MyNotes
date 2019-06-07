//
//  DataManager.h
//  MyNotes
//
//  Created by Eduard Galchenko on 5/21/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject <NSFetchedResultsControllerDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;

+ (DataManager*) sharedManager;

- (void)saveContext;
//- (NSArray*) getAllObjects;

@end

NS_ASSUME_NONNULL_END
