//
//  NoteTableViewCell.m
//  MyNotes
//
//  Created by Eduard Galchenko on 5/19/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "NoteTableViewCell.h"

@implementation NoteTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) cofigureNote:(Note*) note {
    
    self.showNoteContent = note.content;
    
    // Output max length of note
    self.showNoteContent = [self substringNote:self.showNoteContent];
    
    self.contentLabel.text = self.showNoteContent;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];

    [self.dateFormatter setDateFormat:@"dd.MM.yy"];
    self.dateLabel.text = [self.dateFormatter stringFromDate:note.noteDate];
    
    [self.dateFormatter setDateFormat:@"HH:mm"];
    self.timeLabel.text = [self.dateFormatter stringFromDate:note.noteDate];
}

// Output max length of note
- (NSString*) substringNote:(NSString*) noteContent {
    
    if ([noteContent length] > 100) {
        
        return [noteContent substringToIndex:100];
    }
    
    return noteContent;
}

@end
