//
//  UserModel.h
//  ZpotDrop
//
//  Created by Nguyenh on 8/2/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserModel : PFUser

@property (nonatomic, retain, getter=getAvatar) NSURL* avatar;
@property (nonatomic, retain, getter=getName) NSString* name;

@end
