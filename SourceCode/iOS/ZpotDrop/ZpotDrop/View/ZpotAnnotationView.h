//
//  ZpotAnnotationView.h
//  ZpotDrop
//
//  Created by ME on 8/6/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ZpotAnnotation.h"

@interface ZpotAnnotationView : MKAnnotationView
- (id)initWithAnnotation:(ZpotAnnotation*)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
