//
//  ScannedUserCell.m
//  ZpotDrop
//
//  Created by Son Truong on 8/8/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ScannedUserCell.h"
#import "Utils.h"
#import "UserDataModel.h"

@implementation ScannedUserCell

- (void)awakeFromNib {
    // Initialization code
    _imgvAvatar.layer.masksToBounds = YES;
    _viewAvatar.layer.masksToBounds = YES;
    _viewAvatar.backgroundColor = COLOR_DARK_GREEN;
    _topConstraint.constant = 8;
    _leftConstraint.constant = _rightConstraint.constant = 20;
    _botConstraint.constant = 32;
//    _topConstraint.constant = _leftConstraint.constant = _rightConstraint.constant = _botConstraint.constant = 10;
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeUp:)];
    swipeRight.numberOfTouchesRequired = 1;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipeRight];

}

-(void)didSwipeUp:(id)gesture{
    self.onDeleteCell(self.dataModel);
}

-(void)updateMask{
    if (!viewMask) {
        viewMask = [[UIView alloc]initWithFrame:CGRectMake(_leftConstraint.constant , _topConstraint.constant, self.width - _leftConstraint.constant - _rightConstraint.constant, self.height - _topConstraint.constant - _botConstraint.constant)];
        [viewMask setBackgroundColor:[COLOR_DARK_GREEN colorWithAlphaComponent:0.7]];
        [self addSubview:viewMask];
    }else{
        viewMask.frame = CGRectMake(_leftConstraint.constant , _topConstraint.constant, self.width - _leftConstraint.constant - _rightConstraint.constant, self.height - _topConstraint.constant - _botConstraint.constant);
    }
    //Add mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = viewMask.bounds;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.needsDisplayOnBoundsChange = YES;
    
    CGFloat maskLayerWidth = maskLayer.bounds.size.width;
    CGFloat maskLayerHeight = maskLayer.bounds.size.height;
    CGPoint maskLayerCenter =
    CGPointMake(maskLayerWidth/2,maskLayerHeight/2);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:maskLayerCenter];
    

    if ([self.dataModel isKindOfClass:[FeedDataModel class]]) {
        FeedDataModel* feedModel = (FeedDataModel*)self.dataModel;
        double deltaSecond = [[NSDate date] timeIntervalSince1970] - [feedModel.time timeIntervalSince1970];
        float angle = (deltaSecond * 360.0) / (60*60);
        if (angle > 360) {
            angle = 360;
        }
        [path addArcWithCenter:maskLayerCenter radius:(maskLayerWidth/2)
                    startAngle:degreesToRadians(0-90) endAngle:degreesToRadians(angle-90) clockwise:YES];
        
        [path closePath];
        maskLayer.path = path.CGPath;
        viewMask.layer.mask = maskLayer;
    }else{
        [viewMask setBackgroundColor:[UIColor clearColor]];

        [path addArcWithCenter:maskLayerCenter radius:(maskLayerWidth/2)
                    startAngle:degreesToRadians(0) endAngle:degreesToRadians(360) clockwise:YES];
        
        [path closePath];
        maskLayer.path = path.CGPath;
        viewMask.layer.mask = maskLayer;
    }
}

-(void)setupCellWithData:(BaseDataModel *)data andOptions:(NSDictionary *)param{
    self.dataModel = data;
    
    if ([data isKindOfClass:[FeedDataModel class]]) {
        FeedDataModel* feedModel = (FeedDataModel*)data;
        UserDataModel* userModel = (UserDataModel*)[UserDataModel fetchObjectWithID:feedModel.user_id];
        _nameLabel.text = userModel.first_name;
        _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
        [userModel updateObjectForUse:^{
            if (userModel.avatar.length > 0) {
                _imgvAvatar.image = [userModel.avatar stringToUIImage];
            }
        }];
        [self updateMask];
    }else if ([data isKindOfClass:[UserDataModel class]]){
        UserDataModel* userModel = (UserDataModel*)data;
        _nameLabel.text = userModel.first_name;
        _imgvAvatar.image = [UIImage imageNamed:@"avatar"];
        [userModel updateObjectForUse:^{
            if (userModel.avatar.length > 0) {
                _imgvAvatar.image = [userModel.avatar stringToUIImage];
            }
        }];
        [self updateMask];
    }
    
    if (param != nil && [param objectForKey:@"isSelected"]) {
        BOOL isSelected = [[param objectForKey:@"isSelected"] boolValue];
        [self setSelectedUser:isSelected withAnimated:NO];
    }else{
        [self setSelectedUser:NO withAnimated:NO];
    }
}
-(void)setSelectedUser:(BOOL)isSel withAnimated:(BOOL)flag{
    if (isSel) {
        _topConstraint.constant = _leftConstraint.constant = _rightConstraint.constant = _botConstraint.constant = 20;
    }else{
        _topConstraint.constant = _leftConstraint.constant = _rightConstraint.constant = _botConstraint.constant = 25;
    }
    [self updateMask];
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
