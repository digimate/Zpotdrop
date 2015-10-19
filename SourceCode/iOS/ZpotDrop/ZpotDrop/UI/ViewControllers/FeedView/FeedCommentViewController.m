//
//  FeedCommentViewController.m
//  ZpotDrop
//
//  Created by Son Truong on 8/18/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "FeedCommentViewController.h"
#import "FeedNormalViewCell.h"
#import "FeedCommentNotifyCell.h"
#import "FeedCommentCell.h"
#import "Utils.h"
#import "BaseDataModel.h"
#import "FeedCommentDataModel.h"
#import "BaseTableViewCell.h"
#import "LoadingView.h"

@interface FeedCommentViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIView* _commentPostView;
    UITextView* _tvComment;
    UIButton* _btnSendComment;
    UILabel* lblHolder;
    NSLayoutConstraint* mLayoutBottom;
    NSLayoutConstraint* mLayoutComposeHeight;
    UITableView* _tableViewComment;
    CGRect originalFrame;
    FeedNormalViewCell* topCell;
    NSMutableArray* _commentsData;
    TableViewDataHandler* tableDataHandler;
    LoadingView* loadingView;
    BOOL canLoadOldComments;
    UIButton* btnCloseKeyboard;
    UILabel* _lblLikeInfo;
    UILabel* _lblCommingInfo;
}

@end

@implementation FeedCommentViewController
@synthesize feedData;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"feed".localized.uppercaseString;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    canLoadOldComments = YES;
    tableDataHandler = [[TableViewDataHandler alloc]init];
    tableDataHandler.addOnTop = NO;
    loadingView = [[LoadingView alloc]init];
    
    _commentsData = [NSMutableArray array];
    originalFrame = [UIScreen mainScreen].bounds;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        originalFrame.size.height -= 64;
    }else{
        originalFrame.size.height -= 44;
    }
    
    btnCloseKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCloseKeyboard setFrame:originalFrame];
    [btnCloseKeyboard addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
    topCell = (FeedNormalViewCell*)[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([FeedNormalViewCell class]) owner:self options:nil] firstObject];
    [self.view addSubview:topCell];
    [topCell setupCellWithData:self.feedData andOptions:nil];
    
    /*============Comment Input View============*/
    _commentPostView = [[UIView alloc]initWithFrame:CGRectMake(0, originalFrame.size.height-40, self.view.width, 40)];
    _commentPostView.translatesAutoresizingMaskIntoConstraints = NO;
    [_commentPostView addTopBorderWithHeight:1.0 andColor:COLOR_SEPEARATE_LINE];
    _commentPostView.backgroundColor = [UIColor whiteColor];
    _commentPostView.layer.masksToBounds = YES;
    [self.view addSubview:_commentPostView];
    
    _btnSendComment = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSendComment.enabled = NO;
    _btnSendComment.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnSendComment setBackgroundColor:COLOR_DARK_GREEN];
    [[_btnSendComment titleLabel]setFont:[UIFont fontWithName:@"PTSans-Regular" size:16.f]];
    [_btnSendComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSendComment setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [_btnSendComment setTitle:@"post".localized forState:UIControlStateNormal];
    [_btnSendComment addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    
    _tvComment = [[UITextView alloc]init];
    _tvComment.autoresizesSubviews = YES;
    _tvComment.font = [UIFont fontWithName:@"PTSans-Regular" size:16.f];
    _tvComment.textColor = [UIColor blackColor];
    _tvComment.translatesAutoresizingMaskIntoConstraints = NO;
    _tvComment.backgroundColor = [UIColor clearColor];
    _tvComment.delegate = self;
    _tvComment.textContainerInset = UIEdgeInsetsMake(11, 0, 0, 0);
    
    [_commentPostView addSubview:_tvComment];
    [_commentPostView addSubview:_btnSendComment];
    
    NSDictionary *dictBot = NSDictionaryOfVariableBindings(_tvComment,_btnSendComment);
    NSArray *constraint_H_Bot = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tvComment]-0-[_btnSendComment(60)]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:dictBot];
    NSArray *constraint_V_B1= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tvComment]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:dictBot];
    NSArray *constraint_V_B2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_btnSendComment(40)]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:dictBot];
    [_commentPostView addConstraints:constraint_H_Bot];
    [_commentPostView addConstraints:constraint_V_B1];
    [_commentPostView addConstraints:constraint_V_B2];
    
    
    lblHolder = [[UILabel alloc]init];
    lblHolder.font = [UIFont fontWithName:@"PTSans-Italic" size:16.f];
    lblHolder.textColor = [UIColor lightGrayColor];
    lblHolder.text = @"place_holder_feed_comment".localized;
    lblHolder.translatesAutoresizingMaskIntoConstraints = NO;
    lblHolder.backgroundColor = [UIColor clearColor];
    [_tvComment addSubview:lblHolder];
    
    dictBot = NSDictionaryOfVariableBindings(lblHolder);
    [_tvComment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[lblHolder(==40)]-(>=0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:dictBot]];
    [_tvComment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[lblHolder]-0-|" options:0 metrics:nil views:dictBot]];
    
    /////////Setup TableView
    _tableViewComment = [[UITableView alloc]initWithFrame:CGRectMake(0, topCell.height, self.view.width, _commentPostView.y - topCell.height) style:UITableViewStyleGrouped];
    _tableViewComment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableViewComment];
    [_tableViewComment registerNib:[UINib nibWithNibName:NSStringFromClass([FeedCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedCommentCell class])];
    [_tableViewComment registerNib:[UINib nibWithNibName:NSStringFromClass([FeedCommentNotifyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedCommentNotifyCell class])];
    _tableViewComment.translatesAutoresizingMaskIntoConstraints = NO;
    _tableViewComment.delegate = self;
    _tableViewComment.dataSource = self;
    [tableDataHandler handleData:_commentsData ofTableView:_tableViewComment];
    
    /*============Layout with Constraints============*/
    NSDictionary *metrics = @{@"topAlign":@(topCell.height)};
    NSDictionary* dictItems = NSDictionaryOfVariableBindings(_tableViewComment,_commentPostView);
    NSArray* commentPostW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentPostView]|" options:0 metrics:nil views:dictItems];
    NSArray* feedTableW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableViewComment]|" options:0 metrics:nil views:dictItems];
    NSArray* combineH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topAlign-[_tableViewComment]-0-[_commentPostView(40)]-0-|" options:0 metrics:metrics views:dictItems];
    [self.view addConstraints:commentPostW];
    [self.view addConstraints:feedTableW];
    [self.view addConstraints:combineH];
    
    
    mLayoutComposeHeight = [self constraintForAttribute:NSLayoutAttributeHeight firstItem:_commentPostView secondItem:nil];
    mLayoutBottom = [self constraintForAttribute:NSLayoutAttributeBottom firstItem:self.view secondItem:_commentPostView];
    
    //headerView
    _tableViewComment.tableHeaderView = nil;
    UIView* viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableViewComment.width, 50)];
    _lblLikeInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, 0,viewHeader.width-10, viewHeader.height/2)];
    _lblLikeInfo.textColor = [UIColor colorWithRed:192 green:192 blue:192];
    _lblLikeInfo.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    _lblLikeInfo.text = nil;
    [viewHeader addSubview:_lblLikeInfo];
    
    _lblCommingInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, viewHeader.height/2,viewHeader.width-10, viewHeader.height/2)];
    _lblCommingInfo.textColor = [UIColor colorWithRed:192 green:192 blue:192];
    _lblCommingInfo.font = [UIFont fontWithName:@"PTSans-Regular" size:14];
    _lblCommingInfo.text = nil;
    [viewHeader addSubview:_lblCommingInfo];
    
    _tableViewComment.tableHeaderView = viewHeader;
    //show Like Info
    NSArray* arrayLikeUserID;
    if (feedData.like_userIds.length > 0) {
        arrayLikeUserID = [feedData.like_userIds componentsSeparatedByString:@","];
    }else{
        arrayLikeUserID = @[];
    }
    [[Utils instance]convertLikeIDsToInfo:arrayLikeUserID completion:^(NSString *txt,NSArray* rangeArray) {
        NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc]initWithString:txt];
        NSDictionary* dict = @{NSForegroundColorAttributeName : [UIColor colorWithRed:125 green:125 blue:125]};
        for (NSValue* value in rangeArray) {
            NSRange range = [value rangeValue];
            if (range.location != NSNotFound) {
                [attStr addAttributes:dict range:range];
            }
        }
        _lblLikeInfo.attributedText = attStr;
    }];
    //show Comming Info
    NSArray* arrayCommingUserID;
    if (feedData.comming_userIds.length > 0) {
        arrayCommingUserID = [feedData.comming_userIds componentsSeparatedByString:@","];
    }else{
        arrayCommingUserID = @[];
    }
    [[Utils instance]convertCommingIDsToInfo:arrayCommingUserID completion:^(NSString *txt, NSArray *rangeArray) {
        NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc]initWithString:txt];
        NSDictionary* dict = @{NSForegroundColorAttributeName : [UIColor colorWithRed:125 green:125 blue:125]};
        for (NSValue* value in rangeArray) {
            NSRange range = [value rangeValue];
            if (range.location != NSNotFound) {
                [attStr addAttributes:dict range:range];
            }
        }
        _lblCommingInfo.attributedText = attStr;
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerKeyboardNotification];
    if (_commentsData.count == 0) {
        [self loadComments];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
}

-(void)sendComment:(UIButton*)sender{
    NSString* text = [_tvComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length > 0) {
        FeedCommentDataModel* comment = (FeedCommentDataModel*)[FeedCommentDataModel fetchObjectWithID:[[NSDate date] string]];
        comment.message = text;
        comment.feed_id = feedData.mid;
        comment.user_id = [AccountModel currentAccountModel].user_id;
        comment.status = STATUS_SENDING;
        comment.type = TYPE_COMMENT;
        comment.time = [NSDate date];
        [self addComment:comment];
        [_tvComment setText:@""];
        [self textViewDidChange:_tvComment];
        [[APIService shareAPIService]postComment:comment completion:^(BOOL isSuccess,NSString* error) {
            [comment.dataDelegate updateUIForDataModel:comment options:@{@"status":@""}];
        }];
    }else{
        [[Utils instance]showAlertWithTitle:@"error_title".localized message:@"error_send_comment_empty".localized yesTitle:nil noTitle:@"ok".localized handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
}

-(void)closeKeyboard{
    [_tvComment resignFirstResponder];
}
-(void)scrollToBottom{
    if (_tableViewComment.contentSize.height > _tableViewComment.height) {
        [_tableViewComment setContentOffset:CGPointMake(0, _tableViewComment.contentSize.height - _tableViewComment.height)];
    }
}
-(void)addComment:(BaseDataModel*)data{
    [tableDataHandler insertData:data];
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.3];
}
-(void)removeComment:(BaseDataModel*)data{
    if (data != nil) {
        [tableDataHandler removeData:data];
    }
}

-(void)loadComments{
    if (self.feedData) {
        [loadingView showViewInView:_tableViewComment];
        [[APIService shareAPIService]getCommentsFromServerForFeedID:self.feedData.mid completion:^(NSMutableArray *returnData, NSString *error) {
            [loadingView hideView];
            NSSortDescriptor* sortByTime = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
            [returnData sortUsingDescriptors:@[sortByTime]];
            if (returnData.count < API_PAGE_SIZE) {
                canLoadOldComments = NO;
            }
            [_commentsData addObjectsFromArray:returnData];
            [_tableViewComment reloadData];
        }];
    }
}

-(void)loadOldComments:(UIButton*)sender{
    if (canLoadOldComments) {
        sender.hidden = YES;
        FeedDataModel* feedModel = (FeedDataModel*)self.feedData;
        FeedCommentDataModel* comment = _commentsData.firstObject;
        [[APIService shareAPIService]getOldCommentsFromServerForFeedID:feedModel.mid time:comment.time completion:^(NSMutableArray *returnData, NSString *error) {
            if (returnData && returnData.count > 0) {
                if (returnData.count == API_PAGE_SIZE) {
                    sender.hidden = NO;
                }else{
                    canLoadOldComments = NO;
                }
                [_commentsData addObjectsFromArray:returnData];
                [_tableViewComment reloadData];
            }
            
        }];
    }
}

-(void)loadCommentsFromLocal{
    if (self.feedData) {
        NSSortDescriptor* sortByTime = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
        NSArray* comments = [FeedCommentDataModel fetchObjectsWithPredicate:[NSPredicate predicateWithFormat:@"feed_id = %@",self.feedData.mid] sorts:@[sortByTime]];
        [_commentsData removeAllObjects];
        [_commentsData addObjectsFromArray:comments];
        [_tableViewComment reloadData];
    }
    
}
#pragma mark - TextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    lblHolder.hidden = true;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        lblHolder.hidden = false;
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //    if ([text isEqualToString:@"\n"]) {
    //        [self closeKeyboard];
    //        return NO;
    //    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    CGFloat height = ceil([textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)].height);
    if (height < 40) {
        height = 40;
    }else if(height > 100){
        height = 100;
    }
    if (mLayoutComposeHeight.constant != height) {
        mLayoutComposeHeight.constant = height;
        textView.scrollEnabled = true;
    }
    _btnSendComment.enabled = (textView.text.length > 0);
}
#pragma mark - UIKeyboard
-(void)keyboardShow:(CGRect)frame{
    if (btnCloseKeyboard.superview == nil) {
        [self.view addSubview:btnCloseKeyboard];
    }
    [self.view bringSubviewToFront:_commentPostView];
    mLayoutBottom.constant = frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];

}

-(void)keyboardHide:(CGRect)frame{
    [btnCloseKeyboard removeFromSuperview];
    mLayoutBottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //[self closeKeyboard];
}
#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [_commentsData sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]]];
    return _commentsData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id data = [_commentsData objectAtIndex:indexPath.row];
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath] forIndexPath:indexPath];
    cell.dataModel.dataDelegate = nil;
    cell.dataModel = nil;
    [cell setupCellWithData:data andOptions:nil];
    if ([cell isKindOfClass:[FeedCommentCell class]]) {
        FeedCommentViewController* weak = weakObject(self);
        FeedCommentCell* weakCommentCell = weakObject(cell);
        [(FeedCommentCell*)cell setOnDeleteComment:^{
            [weak removeComment:weakCommentCell.dataModel];
        }];
    }
    return cell;
}
-(NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    FeedCommentDataModel* data = (FeedCommentDataModel*)[_commentsData objectAtIndex:indexPath.row];
    if ([data.type isEqualToString:TYPE_NOTIFY]) {
        return NSStringFromClass([FeedCommentNotifyCell class]);
    }
    return NSStringFromClass([FeedCommentCell class]);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedCommentDataModel* data = (FeedCommentDataModel*)[_commentsData objectAtIndex:indexPath.row];
    if ([data.type isEqualToString:TYPE_NOTIFY]) {
        return [FeedCommentNotifyCell cellHeightWithData:data];
    }
    return [FeedCommentCell cellHeightWithData:data];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && canLoadOldComments) {
        return 24;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView* viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 24)];
        UIButton* btnViewOldComment = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnViewOldComment setFrame:CGRectMake(10, 0, viewHeader.width - 10, viewHeader.height)];
        [btnViewOldComment setTitleColor:[UIColor colorWithRed:152 green:152 blue:152] forState:UIControlStateNormal];
        [btnViewOldComment addTarget:self action:@selector(loadOldComments:) forControlEvents:UIControlEventTouchUpInside];
        [btnViewOldComment setTitle:@"view_previous_comment".localized forState:UIControlStateNormal];
        [[btnViewOldComment titleLabel]setFont:[UIFont fontWithName:@"PTSans-Bold" size:14]];
        [btnViewOldComment setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [viewHeader addSubview:btnViewOldComment];
        return viewHeader;
    }
    return nil;
}
@end
