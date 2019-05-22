//
//  Note+CoreDataProperties.h
//  MyNotes
//
//  Created by Eduard Galchenko on 5/21/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//
//

#import "Note+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *noteDate;
@property (nullable, nonatomic, copy) NSString *noteID;

+ (Note*)noteWithContent:(NSString *)content inManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END
