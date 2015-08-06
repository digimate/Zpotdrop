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

@interface FeedZpotViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    UITableView* _feedTableView;
    UIView* _commentPostView;
    UITextView* _tvComment;
    UIButton* _btnSendComment;
    NSMutableArray* _feedData;
    UILabel* lblHolder;
    id selectedData;
    TableViewInsertDataHandler* insertDataHandler;
    NSLayoutConstraint* mLayoutComposeHeight;
    NSLayoutConstraint* mLayoutBottom;
}

@end

@implementation FeedZpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"feed".localized.uppercaseString;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    /*============Feed TableView============*/
    _feedData = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3"]];
    _feedTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _feedTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _feedTableView.dataSource = self;
    _feedTableView.delegate = self;
    [self.view addSubview:_feedTableView];
    
    [_feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedNormalViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedNormalViewCell class])];
    [_feedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FeedSelectedViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedSelectedViewCell class])];
    
    /*============Comment Input View============*/
    _commentPostView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [_commentPostView addTopBorderWithHeight:1.0 andColor:COLOR_SEPEARATE_LINE];
    _commentPostView.translatesAutoresizingMaskIntoConstraints = NO;
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
    [_btnSendComment setTitle:@"Send" forState:UIControlStateNormal];
    [_btnSendComment addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
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
    lblHolder.text = @"New Message";
    lblHolder.translatesAutoresizingMaskIntoConstraints = NO;
    lblHolder.backgroundColor = [UIColor clearColor];
    [_tvComment addSubview:lblHolder];
    
    dictBot = NSDictionaryOfVariableBindings(lblHolder);
    [_tvComment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[lblHolder(==40)]-(>=0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:dictBot]];
    [_tvComment addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[lblHolder]-0-|" options:0 metrics:nil views:dictBot]];

    /*============Layout with Constraints============*/
    NSDictionary* dictItems = NSDictionaryOfVariableBindings(_feedTableView,_commentPostView);
    NSArray* commentPostW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentPostView]|" options:0 metrics:nil views:dictItems];
    NSArray* feedTableW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_feedTableView]|" options:0 metrics:nil views:dictItems];
    NSArray* combineH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_feedTableView]-0-[_commentPostView(40)]-0-|" options:0 metrics:nil views:dictItems];
    [self.view addConstraints:commentPostW];
    [self.view addConstraints:feedTableW];
    [self.view addConstraints:combineH];
    
    mLayoutComposeHeight = [self constraintForAttribute:NSLayoutAttributeHeight firstItem:_commentPostView secondItem:nil];
    mLayoutComposeHeight.constant = 0;
    mLayoutBottom = [self constraintForAttribute:NSLayoutAttributeBottom firstItem:self.view secondItem:_commentPostView];
}

-(void)closeKeyboard{
    [_tvComment resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!insertDataHandler) {
        insertDataHandler = [[TableViewInsertDataHandler alloc]init];
        [insertDataHandler handleInsertData:_feedData ofTableView:_feedTableView];
    }
    [self registerKeyboardNotification];
    [self registerOpenLeftMenuNotification];
    [self registerOpenRightMenuNotification];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
    [self removeOpenLeftMenuNotification];
    [self removeOpenRightMenuNotification];
}
-(void)insertNewFeedInTable:(id)data{
    [insertDataHandler insertData:data];
}
-(void)leftMenuOpened{
    [self closeKeyboard];
}
-(void)rightMenuOpened{
    [self closeKeyboard];
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
        return [FeedSelectedViewCell cellHeight];
    }
    return [FeedNormalViewCell cellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentiferForIndexPath:indexPath]];
    [cell setupCellWithData:nil andOptions:nil];
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
        mLayoutComposeHeight.constant = 0;
        [_tvComment setText:@""];
        [_tvComment resignFirstResponder];
        lblHolder.hidden = false;
    }else{
        if (selectedData != nil && [_feedData containsObject:selectedData]) {
            NSInteger row = [_feedData indexOfObject:selectedData];
            [reloadIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
        }
        selectedData = data;
        mLayoutComposeHeight.constant = 40;
    }
    [tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
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
    if ([text isEqualToString:@"\n"]) {
        [self closeKeyboard];
        return NO;
    }
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
    if (selectedData) {
        NSInteger row = [_feedData indexOfObject:selectedData];
        [_feedTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
-(void)keyboardHide:(CGRect)frame{
    mLayoutBottom.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
