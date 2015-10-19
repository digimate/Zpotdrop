//
//  PostZpotViewController.h
//  ZpotDrop
//
//  Created by Son Truong on 8/4/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface PostZpotViewController : BaseViewController {
    IBOutlet TPKeyboardAvoidingScrollView *scvMain;
    IBOutlet UIView *vMap;
    IBOutlet UIButton *btnAddText;
    IBOutlet UIButton *btnAddFriends;
    IBOutlet UIImageView *imvSeparator;
    IBOutlet UIView *vAddText;
    IBOutlet UITextField *tfAddText;
    IBOutlet UIView *vWith;
    IBOutlet UILabel *lbWith;
    IBOutlet UIButton *btnFindLocation;
    UIImageView *imvLastSeparator;
    
    IBOutlet NSLayoutConstraint *consAddTextAndWithFriend;
    NSLayoutConstraint *consAddTextAndButtonAddText;
    
    // Location View
    IBOutlet UIView *vLocation;
    IBOutlet UILabel *lbLocationName;
    IBOutlet UILabel *lbLocationAddress;
}
@end
