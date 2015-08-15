//
//  LoadingView.m
//  ZpotDrop
//
//  Created by Son Truong on 8/15/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "LoadingView.h"
#import "SCSkypeActivityIndicatorView.h"
#import "Utils.h"

@interface LoadingView (){
    SCSkypeActivityIndicatorView* _indicatorView;
}

@end

@implementation LoadingView

-(instancetype)init{
    self = [super init];
    [self setupUI];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setupUI];
    return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    _indicatorView = [[SCSkypeActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:_indicatorView];
    [_indicatorView setBubbleColor:COLOR_DARK_GREEN];
    [_indicatorView setNumberOfBubbles:4];
    [_indicatorView setBubbleSize:CGSizeMake(8, 8)];
}

-(void)showViewInView:(UIView *)view{
    self.frame = view.bounds;
    [view addSubview:self];
    _indicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [_indicatorView startAnimating];
}
-(void)hideView{
    [_indicatorView stopAnimating];
    [self removeFromSuperview];
}
@end
