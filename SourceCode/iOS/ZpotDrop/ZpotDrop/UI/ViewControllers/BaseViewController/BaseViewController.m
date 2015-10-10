//
//  BaseViewController.m
//  ZpotDrop
//
//  Created by Nguyenh on 7/29/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _api = [APIService shareAPIService];
    _rule = [RuleService shareRuleService];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:MAIN_COLOR]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerAppBecomActiveNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)appBecomeActive{

}

-(void)removeAppBecomActiveNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)registerKeyboardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeKeyboardNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification*)notif{
    NSValue *rectValue = [notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    [self keyboardShow:[rectValue CGRectValue]];
}

-(void)keyboardShow:(CGRect)frame{
    //heritance class do it
}

-(void)keyboardWillHide:(NSNotification*)notif{
    NSValue *rectValue = [notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    [self keyboardHide:[rectValue CGRectValue]];
}

-(void)keyboardHide:(CGRect)frame{
    //heritance class do it
}

-(void)registerOpenLeftMenuNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuOpened) name:KEY_OPEN_LEFT_MENU object:nil];
   
}
-(void)removeOpenLeftMenuNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KEY_OPEN_LEFT_MENU object:nil];
}
-(void)leftMenuOpened{
    //heritance class do it
}
-(void)registerOpenRightMenuNotification{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightMenuOpened) name:KEY_OPEN_RIGHT_MENU object:nil];
}
-(void)removeOpenRightMenuNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KEY_OPEN_RIGHT_MENU object:nil];
}
-(void)rightMenuOpened{
    //heritance class do it
}

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute firstItem:(id)first secondItem:(id)second
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d AND firstItem = %@ AND secondItem = %@", attribute, first, second];
    return [[self.view.constraints filteredArrayUsingPredicate:predicate] firstObject];
}


#pragma mark - Public

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
