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
    
    // Do any additional setup after loading the view.
    topCell = (FeedNormalViewCell*)[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([FeedNormalViewCell class]) owner:self options:nil] firstObject];
    [self.view addSubview:topCell];
    [topCell setupCellWithData:self.feedData andOptions:nil];
    
    /*============Comment Input View============*/
    _commentPostView = [[UIView alloc]initWithFrame:CGRectMake(0, originalFrame.size.height-40, self.view.width, 40)];
    _commentPostView.translatesAutoresizingMaskIntoConstraints = NO;
    [_commentPostView addTopBorderWithHeight:1.0 andColor:COLOR_SEPEARATE_LINE];
    _commentPostView.backgroundColor = [UIColor clearColor];
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
        FeedCommentDataModel* comment = (FeedCommentDataModel*)[FeedCommentDataModel fetchObjectWithID:[[NSDate date] string]];
        comment.message = _tvComment.text;
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
            [self loadCommentsFromLocal];
        }];
    }
}

-(void)loadOldComments:(UIButton*)sender{
    
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
    mLayoutBottom.constant = frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];

}

-(void)keyboardHide:(CGRect)frame{
    mLayoutBottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self closeKeyboard];
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
    if (section == 0) {
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
