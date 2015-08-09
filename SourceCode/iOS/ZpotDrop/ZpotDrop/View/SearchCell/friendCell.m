//
//  friendCell.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "friendCell.h"

@implementation friendCell

-(void)faceBookCell
{
    [self.imageView setImage:[UIImage imageNamed:@"ic_facebook"]];
    [self.textLabel setText:@"Find facebook friends"];
    [self.textLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:13.f]];
    [self.textLabel setTextColor:[UIColor lightGrayColor]];
}

-(void)contactCell
{
    [self.imageView setImage:[UIImage imageNamed:@"ic_contact"]];
    [self.textLabel setText:@"Find people from contacts"];
    [self.textLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:13.f]];
    [self.textLabel setTextColor:[UIColor lightGrayColor]];
}

@end
