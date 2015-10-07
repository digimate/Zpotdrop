//
//  CreateLocationCell.h
//  ZpotDrop
//
//  Created by Son Truong on 8/11/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface CreateLocationCell : BaseTableViewCell<UITextFieldDelegate>{
    IBOutlet UILabel* lblName;
    IBOutlet UILabel* lblAddress;
    IBOutlet UITextField* tfName;
    IBOutlet UITextField* tfAddress;
    IBOutlet UIButton* btnCreate;
}
@property(nonatomic, copy)NSString* address;
@property(nonatomic, readonly)NSString* name;
@property(nonatomic, copy)void(^onCreateLocationPressed)(NSString* name,NSString* address);
@end
