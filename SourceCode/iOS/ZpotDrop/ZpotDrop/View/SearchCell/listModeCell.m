//
//  listModeCell.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "listModeCell.h"
#import "Utils.h"

@implementation listModeCell

-(void)setupCellWithMode:(CONTACT_MODE)mode inSize:(CGSize)size AndHandler:(contactHandler)handler
{
    _handler = handler;
    if (!_btFollower)
    {
        _btFollower = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btFollower setFrame:CGRectMake(0, 0, size.width/2, size.height)];
        [_btFollower setTitle:@"Followers" forState:UIControlStateNormal];
        [_btFollower setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btFollower.layer setBorderWidth:1.f];
        [_btFollower.layer setBorderColor:[UIColor colorWithHexString:@"e8e9ea"].CGColor];
        [_btFollower setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
        [_btFollower.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:13.f]];
        [_btFollower setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btFollower addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btFollower];
        
        _btFollowing = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btFollowing setFrame:CGRectMake(size.width/2, 0, size.width/2, size.height)];
        [_btFollowing setTitle:@"Following" forState:UIControlStateNormal];
        [_btFollowing.layer setBorderWidth:1.f];
        [_btFollowing setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btFollowing.layer setBorderColor:[UIColor colorWithHexString:@"e8e9ea"].CGColor];
        [_btFollowing setBackgroundColor:[UIColor whiteColor]];
        [_btFollowing.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:13.f]];
        [_btFollowing setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btFollowing addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btFollowing];
    }
}

-(IBAction)btnPressed:(id)sender
{
    if (sender == _btFollower)
    {
        _handler(FOLLOWER);
        [_btFollower setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
        [_btFollowing setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
    }
    else
    {
        _handler(FOLLOWING);
        [_btFollower setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [_btFollowing setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
    }
}

@end
