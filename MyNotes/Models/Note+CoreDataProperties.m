//
//  Note+CoreDataProperties.m
//  MyNotes
//
//  Created by Eduard Galchenko on 5/21/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

@dynamic content;
@dynamic noteDate;
@dynamic noteID;

+ (NSFetchRequest<Note *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"Note"];
}

+ (Note*)noteWithContent:(NSString *) content inManagedObjectContext:(NSManagedObjectContext *) context {
    
    Note *note = nil;
    
    note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                         inManagedObjectContext:context];
    
    note.content = content;
    
    note.noteDate = [NSDate date];
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    
    
    note.noteID =  (__bridge NSString *)uuidStringRef;
    
    return  note;
}

@end
