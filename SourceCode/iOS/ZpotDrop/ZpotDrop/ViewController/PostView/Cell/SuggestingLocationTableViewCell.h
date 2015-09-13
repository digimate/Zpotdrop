//
//  SuggestingLocationTableViewCell.h
//  ZpotDrop
//
//  Created by Nguyen Huynh on 9/12/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^suggestionHandler)(NSString* name);
@interface SuggestingLocationTableViewCell : UITableViewCell
{
    UILabel* _name;
}
-(void)setupCellWithData:(NSAttributedString*)attString withHandle:(suggestionHandler)handler;

@end
