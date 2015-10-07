//
//  SettingSwitchCell.h
//  ZpotDrop
//
//  Created by Son Truong on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface SettingSwitchCell : BaseTableViewCell{
    IBOutlet UILabel* lblTitle;
    IBOutlet UILabel* lblSubtitle;
    IBOutlet UISwitch* switchControl;
}
+(CGFloat)ceilHeigthWithParams:(NSDictionary*)dict;
@property(nonatomic,copy)void(^onSwitchChanged)(BOOL flag);
@end
