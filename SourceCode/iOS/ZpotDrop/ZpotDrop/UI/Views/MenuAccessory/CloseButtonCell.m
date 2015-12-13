//
//  CloseButtonCell.m
//  ZpotDrop
//
//  Created by Nguyen Phuc Loc on 12/13/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "CloseButtonCell.h"

@implementation CloseButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)closeButtonClick:(id)sender {
    [self.delegate closeButtonClicked:sender];
}

@end
