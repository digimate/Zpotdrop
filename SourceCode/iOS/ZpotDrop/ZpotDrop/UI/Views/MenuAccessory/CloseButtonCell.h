//
//  CloseButtonCell.h
//  ZpotDrop
//
//  Created by Nguyen Phuc Loc on 12/13/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CloseButtonCellDelegate

@optional
- (void)closeButtonClicked:(id)sender;
@end

@interface CloseButtonCell : UITableViewCell

@property id<CloseButtonCellDelegate> delegate;

@end
