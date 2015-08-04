//
//  LeftMenuViewController.h
//  ZpotDrop
//
//  Created by ME on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class LeftMenuViewController;
@protocol LeftMenuDelegate <NSObject>

-(void)leftmenuChangeViewToClass:(NSString*)clsString;

@end
@interface LeftMenuViewController : BaseViewController{
    UITableView* _tableView;
    NSInteger currentSelectedRow;
}
@property(nonatomic,readonly)UITableView* tableView;
@property(nonatomic, weak)id<LeftMenuDelegate>delegate;
@end
