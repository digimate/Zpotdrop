//
//  ScannedUserAnnoView.h
//  ZpotDrop
//
//  Created by Son Truong on 8/8/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ScannedUserAnnotation.h"

@interface ScannedUserAnnoView : MKAnnotationView
- (id)initWithAnnotation:(ScannedUserAnnotation*)annotation reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupUIWithAnnotation:(ScannedUserAnnotation*)annotation;
@end
