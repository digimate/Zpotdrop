//
//  AddLocationViewController.h
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/18/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AddLocationViewController : BaseViewController {
    IBOutletCollection(NSLayoutConstraint) NSArray *consButtonAddLocation;
}
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scvMain;
@property (strong, nonatomic) IBOutlet UITextField *tfLocationName;
@property (strong, nonatomic) IBOutlet UITextField *tfLocationAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnAddLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnAddLocationInputAccessory;
@property (nonatomic, strong) NSString *locationName;
@end
