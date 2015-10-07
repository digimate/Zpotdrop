//
//  BaseTableViewCell.m
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Utils.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setWidth:[UIScreen mainScreen].bounds.size.width];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCellWithData:(BaseDataModel*)data andOptions:(NSDictionary*)param
{
    
}

+(CGFloat)cellHeightWithData:(BaseDataModel*)data{
    return 0;
}
+(id)instance{
    return nil;
}
-(void)updateUIForDataModel:(BaseDataModel *)model options:(NSDictionary*)params{

}
@end
