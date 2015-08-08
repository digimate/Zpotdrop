//
//  UserProfileViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/8/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController (){
    UIView* viewHeader;
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"profile".localized.uppercaseString;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    /*=============Profile header=========*/
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
    [self.view addSubview:viewHeader];

    UIImageView* imgvAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    imgvAvatar.layer.cornerRadius = imgvAvatar.width/2;
    imgvAvatar.layer.masksToBounds = YES;
    imgvAvatar.image = [UIImage imageNamed:@"avatar"];
    [viewHeader addSubview:imgvAvatar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
