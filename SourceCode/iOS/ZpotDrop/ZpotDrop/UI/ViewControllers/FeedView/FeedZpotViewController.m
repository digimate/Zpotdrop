//
//  FeedZpotViewController.m
//  ZpotDrop
//
//  Created by ME on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedZpotViewController.h"
#import "FeedNormalViewCell.h"
#import "FeedSelectedViewCell.h"
#import "FeedCommentViewController.h"
#import "Utils.h"

@interface FeedZpotViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, UIScrollViewDelegate>{
    UITableView* _feedTableView;
    //UIView* _commentPostView;
    //UITextView* _tvComment;
    //UIButton* _btnSendComment;
    NSMutableArray* _feedData;
    //UILabel* lblHolder;
    FeedDataModel* selectedData;
    TableViewDataHandler* insertDataHandler;
    //NSLayoutConstraint* mLayoutComposeHeight;
    //NSLayoutConstraint* mLayoutBottom;
    FeedSelectedViewCell* feedSelectedCell;
    BOOL canLoadMore;
    UIButton *_newDropButton;
    UIButton *_postButton;
    NSTimer *autoUpdatedTimer;
}

@end

@implementation FeedZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    canLoadMore = YES;
    self.title = @"feed".localized.uppercaseString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    /*============Feed TableView============*/
    _feedData = [NSMutableArray array];
    _feedTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _feedTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _feedTableView.dataSource = self;
    _feedTableView.delegate = self;
    [self.view addSubview:_feedTableView];
    
    [_feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedNormalViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedNormalViewCell class])];
    [_feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedSelectedViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedSelectedViewCell class])];
    
    /*============Layout with Constraints============*/
    NSDictionary* dictItems = NSDictionaryOfVariableBindings(_feedTableView);
//    NSArray* commentPostW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentPostView]|" options:0 metrics:nil views:dictItems];
    NSArray* feedTableW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_feedTableView]|" options:0 metrics:nil views:dictItems];
//    NSArray* combineH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_feedTableView]-0-[_commentPostView(40)]-0-|" options:0 metrics:nil views:dictItems];
     NSArray* combineH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_feedTableView]-0-|" options:0 metrics:nil views:dictItems];
//    [self.view addConstraints:commentPostW];
    [self.view addConstraints:feedTableW];
    [self.view addConstraints:combineH];
    
//    mLayoutComposeHeight = [self constraintForAttribute:NSLayoutAttributeHeight firstItem:_commentPostView secondItem:nil];
//    mLayoutComposeHeight.constant = 0;
//    mLayoutBottom = [self constraintForAttribute:NSLayoutAttributeBottom firstItem:self.view secondItem:_commentPostView];
//
    // New drop
    int newDropButtonWidth = 86;
    int newDropButtonHeight = 22;
    _newDropButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - newDropButtonWidth) / 2, 5, newDropButtonWidth, newDropButtonHeight)];
    _newDropButton.layer.borderWidth = 1.0f;
    _newDropButton.layer.borderColor = [[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f] CGColor];
    [_newDropButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f blue:255.0f alpha:0.5f]];
    [_newDropButton setTitle:@"New Drop" forState:UIControlStateNormal];
    [_newDropButton setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    _newDropButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:10];
    [_newDropButton addTarget:self action:@selector(newDropButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    _newDropButton.hidden = YES;
    [self.view addSubview:_newDropButton];
    
    // Post Button
    int postButtonWidth = 78;
    int postButtonHeight = 78;
    _postButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - postButtonWidth) / 2, (CGRectGetHeight(self.view.frame) - postButtonHeight - 10 - 64), postButtonWidth, postButtonHeight)];
    [_postButton setBackgroundImage:[UIImage imageNamed:@"ic_feed_post"] forState:UIControlStateNormal];
    [_postButton addTarget:self action:@selector(postButtonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_postButton];
    
    [self getFeedsFromServer];
}

-(void)loadFeedsFromLocal:(void(^)(NSMutableArray* returnArray))completion{
    NSMutableArray* returnArray = [NSMutableArray array];
    NSSortDescriptor* sortByTime = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    [returnArray addObjectsFromArray:[FeedDataModel fetchObjectsWithPredicate:nil sorts:@[sortByTime]]];
    completion(returnArray);
}

-(void)getFeedsFromServer {
    [[Utils instance]showProgressWithMessage:nil];
    [[APIService shareAPIService]getFeedsFromServer:^(NSMutableArray *returnArray, NSString *error) {
        [[Utils instance]hideProgess];
        if (error) {
            [[Utils instance]showAlertWithTitle:@"error_title".localized message:error yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            }];
        } else{
            [_feedData removeAllObjects];
            [_feedData addObjectsFromArray:returnArray];
            [_feedTableView reloadData];
            [_feedTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }
    }];
}

-(void)loadMoreFeeds{
    FeedDataModel* oldFeed = [_feedData lastObject];
    [[APIService shareAPIService]getOldFeedsFromServer:oldFeed.time completion:^(NSMutableArray *returnArray, NSString *error) {
        if (returnArray && returnArray.count > 0) {
            NSSortDescriptor* sortByTime = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
            [returnArray sortUsingDescriptors:@[sortByTime]];
            NSMutableArray* insertArrays = [NSMutableArray array];
            for (FeedDataModel* feed in returnArray) {
                if (![_feedData containsObject:feed]) {
                    [insertArrays addObject:[NSIndexPath indexPathForRow:_feedData.count inSection:0]];
                    [_feedData addObject:feed];
                }
            }
            [_feedTableView insertRowsAtIndexPaths:insertArrays withRowAnimation:UITableViewRowAnimationBottom];
            if (returnArray.count == API_PAGE_SIZE) {
                canLoadMore = YES;
            }
        }
    }];
}

-(void)appBecomeActive{
    //check GPS
    if (![Utils instance].isGPS) {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarDidTouch:) name:@"AvatarDidTouchNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameDidTouch:) name:@"NameDidTouchNotification" object:nil];
    
    if (!insertDataHandler) {
        insertDataHandler = [[TableViewDataHandler alloc]init];
        [insertDataHandler handleData:_feedData ofTableView:_feedTableView];
    }
    [self registerAppBecomActiveNotification];
    
    //check GPS
    if (![Utils instance].isGPS) {
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_no_gps".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
    [_feedTableView reloadData];

    [self setupAutoUpdatedTimer];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeAppBecomActiveNotification];
    [autoUpdatedTimer invalidate];
    autoUpdatedTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AvatarDidTouchNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NameDidTouchNotification" object:nil];
}
-(void)insertNewFeedInTable:(id)data{
    [insertDataHandler insertData:data];
}

-(void)moveToSelectedCell{
//    if (feedSelectedCell) {
//        if (feedSelectedCell.height < _feedTableView.height) {
//            [_feedTableView setContentOffset:CGPointMake(0, feedSelectedCell.y) animated:YES];
//        }else{
//            [_feedTableView setContentOffset:CGPointMake(0, feedSelectedCell.y + (feedSelectedCell.height - _feedTableView.height)) animated:YES];
//        }
//    }
    if (selectedData) {
        NSInteger row = [_feedData indexOfObject:selectedData];
        [_feedTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)showCommentView:(FeedDataModel*)feedModel{
    FeedCommentViewController* commentVC = [[FeedCommentViewController alloc]init];
    commentVC.feedData = feedModel;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)setupAutoUpdatedTimer {
    if (!autoUpdatedTimer) {
        autoUpdatedTimer = [NSTimer scheduledTimerWithTimeInterval:120.0f
                                                            target:self
                                                          selector:@selector(autoUpdatedTimerDidFire:)
                                                          userInfo:nil
                                                           repeats:YES];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _feedData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id data = [_feedData objectAtIndex:indexPath.row];
    if (data == selectedData) {
        return [FeedSelectedViewCell cellHeightWithData:data];
    }
    return [FeedNormalViewCell cellHeightWithData:data];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedDataModel* model = [_feedData objectAtIndex:indexPath.row];
    NSString* identifier = [self cellIdentiferForIndexPath:indexPath];
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if ([identifier isEqualToString:NSStringFromClass([FeedSelectedViewCell class])]) {
        if (model != cell.dataModel) {
            cell.dataModel.dataDelegate = nil;
            cell.dataModel = nil;
//            [cell setupCellWithData:model andOptions:nil];
        }
        if (!selectedData) {
            feedSelectedCell = nil;
        }
        [cell setupCellWithData:model andOptions:nil];
        
        feedSelectedCell = (FeedSelectedViewCell*)cell;
        FeedZpotViewController* weak = weakObject(self);
        FeedSelectedViewCell* weakCell = weakObject(feedSelectedCell);
        feedSelectedCell.onShowComment = ^{
            [weak showCommentView:(FeedDataModel*)weakCell.dataModel];
        };
    }else{
        cell.dataModel.dataDelegate = nil;
        cell.dataModel = nil;
        [cell setupCellWithData:model andOptions:nil];
        if (!selectedData) {
            feedSelectedCell = nil;
        }
        
        FeedZpotViewController* weak = weakObject(self);
        FeedNormalViewCell* normalCell = (FeedNormalViewCell*)cell;
        FeedNormalViewCell* weakCell = weakObject(normalCell);
        normalCell.onShowComment = ^{
            [weak showCommentView:(FeedDataModel*)weakCell.dataModel];
        };
    }
    return cell;
}

-(NSString*)cellIdentiferForIndexPath:(NSIndexPath*)indexPath{
    id data = [_feedData objectAtIndex:indexPath.row];
    if (data == selectedData) {
        return NSStringFromClass([FeedSelectedViewCell class]);
    }
    return NSStringFromClass([FeedNormalViewCell class]);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id data = [_feedData objectAtIndex:indexPath.row];
    NSMutableArray* reloadIndexPaths = [NSMutableArray arrayWithObject:indexPath];
    if (data == selectedData) {
        selectedData = nil;
    }else{
        if (selectedData != nil && [_feedData containsObject:selectedData]) {
            NSInteger row = [_feedData indexOfObject:selectedData];
            [reloadIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
        }
        selectedData = data;
        [self moveToSelectedCell];
    }
    [tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= API_PAGE_SIZE-3 && _feedData.count >= API_PAGE_SIZE && canLoadMore) {
        canLoadMore = NO;
        [self loadMoreFeeds];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.3f animations:^{
        _newDropButton.alpha = 0.0f;
        _postButton.alpha = 0.0f;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.3f animations:^{
        _newDropButton.alpha = 1.0f;
        _postButton.alpha = 1.0f;
    }];
}

#pragma mark - Event Handler

- (IBAction)newDropButtonDidTouch:(id)sender {
//    NSLog(@"should load new posts here");
    _newDropButton.hidden = YES;
    [self getFeedsFromServer];
    [self setupAutoUpdatedTimer];
}

- (IBAction)postButtonDidTouch:(id)sender {
    // TODO: Need to implement better router here
    [[NSNotificationCenter defaultCenter] postNotificationName:kFeedViewControllerWillPostNotification object:nil];
//    NSLog(@"should post new drop here :)");
}

- (IBAction)autoUpdatedTimerDidFire:(id)sender {
    if (_newDropButton.hidden) {
        [[APIService shareAPIService]getFeedsFromServer:^(NSMutableArray *returnArray, NSString *error) {
            if (!error) {
                FeedDataModel *latestFeed = [returnArray firstObject];
                FeedDataModel *currentFirstFeed = [_feedData firstObject];
                if (![latestFeed.mid isEqualToString:currentFirstFeed.mid]) {
                    // There is new feed
                    _newDropButton.hidden = NO;
                    [autoUpdatedTimer invalidate];
                    autoUpdatedTimer = nil;
                }
            }
        }];
    }
}

- (void)avatarDidTouch:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *userId = [userInfo objectForKey:@"UserId"];
    // show profile
    [[Utils instance]showUserProfile:[UserDataModel fetchObjectWithID:userId] fromViewController:self];
}

- (void)nameDidTouch:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *userId = [userInfo objectForKey:@"UserId"];
    // show profile
    [[Utils instance]showUserProfile:[UserDataModel fetchObjectWithID:userId] fromViewController:self];
}

@end
