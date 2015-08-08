//
//  ScannedUserCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/8/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ScannedUserCell.h"
#import "Utils.h"

@implementation ScannedUserCell

- (void)awakeFromNib {
    // Initialization code
    _imgvAvatar.layer.masksToBounds = YES;
    _viewAvatar.layer.masksToBounds = YES;
    _viewAvatar.backgroundColor = COLOR_DARK_GREEN;
    _topConstraint.constant = _leftConstraint.constant = _rightConstraint.constant = _botConstraint.constant = 10;
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
    if (param != nil && [param objectForKey:@"isSelected"]) {
        BOOL isSelected = [[param objectForKey:@"isSelected"] boolValue];
        [self setSelectedUser:isSelected withAnimated:NO];
    }else{
        [self setSelectedUser:NO withAnimated:NO];
    }
}
-(void)setSelectedUser:(BOOL)isSel withAnimated:(BOOL)flag{
    if (isSel) {
        _topConstraint.constant = _leftConstraint.constant = _rightConstraint.constant = _botConstraint.constant = 2;
    }else{
        _topConstraint.constant = _leftConstraint.constant = _rightConstraint.constant = _botConstraint.constant = 10;
    }
    
//    if (flag) {
//        [_viewAvatar updateConstraintsIfNeeded];
//        [UIView animateWithDuration:0.2 animations:^{
//            [self layoutIfNeeded];
//        }];
//    }
    int viewWidth = self.width - _leftConstraint.constant - _rightConstraint.constant;
    _viewAvatar.layer.cornerRadius = viewWidth/2;
    viewWidth -= 4;
    _imgvAvatar.layer.cornerRadius = viewWidth/2;
}
@end
