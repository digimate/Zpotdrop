//
//  SearchLocationViewController.h
//  ZpotDrop
//
//  Created by Tuyen Nguyen on 10/18/15.
//  Copyright © 2015 zpotdrop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LocationDataModel.h"

@class SearchLocationViewController;


@protocol SearchLocationViewControllerDelegate <NSObject>
- (void)searchLocationViewController:(SearchLocationViewController *)viewController
                   didSelectLocation:(LocationDataModel *)location;
@end


@interface SearchLocationViewController : BaseViewController
@property (weak, nonatomic) id<SearchLocationViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tblLocation;
@end
