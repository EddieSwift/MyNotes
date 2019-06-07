//
//  NoteTableViewCell.h
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *showNoteContent;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void) cofigureNote:(Note*) note;

@end

NS_ASSUME_NONNULL_END
