//
//  Note.h
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Note : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *noteDate;

@end

NS_ASSUME_NONNULL_END
