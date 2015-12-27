//
//  ScannedUserCell.h
//  ZpotDrop
//
//  Created by Son Truong on 8/8/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewCell.h"
@interface ScannedUserCell : BaseCollectionViewCell{
    IBOutlet UIImageView* _imgvAvatar;
    IBOutlet UIView* _viewAvatar;
    IBOutlet UILabel *_nameLabel;
    IBOutlet NSLayoutConstraint* _topConstraint;
    IBOutlet NSLayoutConstraint* _botConstraint;
    IBOutlet NSLayoutConstraint* _leftConstraint;
    IBOutlet NSLayoutConstraint* _rightConstraint;
    UIView* viewMask;
}
@property(nonatomic, retain)BaseDataModel* dataModel;
-(void)setSelectedUser:(BOOL)isSel withAnimated:(BOOL)flag;
@property(nonatomic, copy)void(^onDeleteCell)(BaseDataModel* data);
-(void)updateMask;
@end
