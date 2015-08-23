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
-(void)closeLeftMenu;

@end
@interface LeftMenuViewController : BaseViewController{
    UITableView* _tableView;
    NSInteger currentSelectedRow;
}
+ (LeftMenuViewController *) instance;
-(void)changeViewToClass:(NSString*)clsString;
-(void)setupData;
@property(nonatomic,readonly)UITableView* tableView;
@property(nonatomic, weak)id<LeftMenuDelegate>delegate;
@end
