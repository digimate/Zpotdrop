//
//  ZDConstant.h
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/8/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef ZDConstant_h
#define ZDConstant_h

#define API_PAGE_SIZE   20
#define ZD_ALERT_TITLE_COLOR [UIColor colorWithRed:178.0f/255.0f green:204.0f/255.0f blue:138.0f/255.0f alpha:1.0f]
#define ZD_ALERT_TEXT_COLOR [UIColor colorWithRed:133.0f/255.0f green:133.0f/255.0f blue:133.0f/255.0f alpha:1.0f]

// Find
#define OVERLAYMETERS 1500

// Push Notifications
static NSString *const kAppDelegateDidReceivePushNotification = @"AppDelegateDidReceivePushNotification";
static NSString *const kAPNTypeRequest = @"request";
static NSString *const kAPNTypeNotify = @"notify";
static NSString *const kAPNTypeBroadcast = @"broadcast";

// Feed View
static NSString *const kFeedViewControllerWillPostNotification = @"FeedViewControllerWillPostNotification";

#endif /* ZDConstant_h */

extern const struct CellHeights{
    float Close;
    float Profile;
}CellHeights;

extern const struct OriginBorder{
    float xBottom;
    float height;
}OriginBorder;