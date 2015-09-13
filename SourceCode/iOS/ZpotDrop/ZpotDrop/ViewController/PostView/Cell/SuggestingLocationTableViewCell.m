//
//  SuggestingLocationTableViewCell.m
//  ZpotDrop
//
//  Created by Nguyen Huynh on 9/12/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "SuggestingLocationTableViewCell.h"

@implementation SuggestingLocationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(NSAttributedString*)attString withHandle:(suggestionHandler)handler
{
    if (!_name)
    {
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_name setNumberOfLines:2];
        [self addSubview:_name];
    }
    [_name setAttributedText:attString];
}

@end
