//
//  ContactCell.m
//  ZpotDrop
//
//  Created by Nguyenh on 8/9/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ContactCell.h"
#import "Utils.h"

@implementation ContactCell

-(void)setupCellWithData:(UserDataModel*)data inSize:(CGSize)size
{
    if (!_avatar)
    {
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, size.height - 20, size.height - 20)];
        [_avatar.layer setCornerRadius:_avatar.frame.size.width/2];
        [_avatar.layer setMasksToBounds:YES];
        [_avatar setImage:[UIImage imageNamed:@"avatar"]];
        [self addSubview:_avatar];
        
        _folow = [UIButton buttonWithType:UIButtonTypeCustom];
        [_folow setFrame:CGRectMake(size.width - 20 - 55, size.height/2 - 10, 55, 20)];
        [_folow setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_folow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_folow];
        
        _username = [[UILabel alloc]initWithFrame:CGRectMake(_avatar.frame.size.width + _avatar.frame.origin.x + 10, _avatar.frame.origin.y, size.width - (_avatar.frame.size.width + _avatar.frame.origin.x + 10) - (_folow.frame.size.width + 20), _avatar.frame.size.height)];
        [_username setFont:[UIFont fontWithName:@"PTSans-Bold" size:13.f]];
        [_username setTextColor:[UIColor colorWithHexString:MAIN_COLOR]];
        [_username setText:@"User name"];
        
        [self addSubview:_username];
    }
}

-(void)setFollow:(BOOL)follow
{
    NSMutableAttributedString *myString;
    if (follow)
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"ic_follow"];
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        myString = [[NSMutableAttributedString alloc]initWithAttributedString:attachmentString];
        
        [myString appendAttributedString:[[NSAttributedString alloc] initWithString:@"following".localized]];
        [_folow setBackgroundColor:[UIColor colorWithHexString:MAIN_COLOR]];
    }
    else
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"ic_add"];
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        myString = [[NSMutableAttributedString alloc]initWithAttributedString:attachmentString];
        [myString appendAttributedString:[[NSAttributedString alloc] initWithString:@"follow".localized]];
        [_folow setBackgroundColor:[UIColor colorWithHexString:@"d9d9d9"]];
    }
    [myString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, myString.length)];
    
    [myString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PTSans-Regular" size:10.f] range:NSMakeRange(0, myString.length)];
    
    [_folow setAttributedTitle:myString forState:UIControlStateNormal];
}

@end
