//
//  SettingSwitchCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "SettingSwitchCell.h"
#import "Utils.h"

@implementation SettingSwitchCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    lblSubtitle.numberOfLines = 0;
    lblTitle.text = lblSubtitle.text = nil;
    [switchControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)valueChanged:(id)sender{
    self.onSwitchChanged(switchControl.isOn);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGSize)sizeForSubTitle:(NSString*)subtitle{
    lblSubtitle.text = subtitle;
    CGSize s = [lblSubtitle sizeThatFits:CGSizeMake(lblSubtitle.width, MAXFLOAT)];
    return s;
}
+(CGFloat)cellHeightWithData:(BaseDataModel *)data{
    return 0;
}
+(CGFloat)ceilHeigthWithParams:(NSDictionary *)dict{
    if (dict && [dict objectForKey:@"subtitle"]) {
        NSString* subtitle = [dict objectForKey:@"subtitle"];
        return 40 + [[SettingSwitchCell instance] sizeForSubTitle:subtitle].height;
    }
    return 40;
}
-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    if (param && [param objectForKey:@"title"]) {
        lblTitle.text = [param objectForKey:@"title"];
    }
    if (param && [param objectForKey:@"subtitle"]) {
        lblSubtitle.text = [param objectForKey:@"subtitle"];
    }
    if (param && [param objectForKey:@"switch"]) {
        switchControl.on = [[param objectForKey:@"switch"] boolValue];
    }
}

+(id)instance{
    static SettingSwitchCell *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    });
    return _sharedInstance;
}
@end
