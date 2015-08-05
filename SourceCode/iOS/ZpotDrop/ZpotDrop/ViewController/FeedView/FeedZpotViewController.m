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

@interface FeedZpotViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* _feedTableView;
    UIView* _commentPostView;
    NSMutableArray* _feedData;
    id selectedData;
    TableViewInsertDataHandler* insertDataHandler;
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
    _commentPostView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_commentPostView];
    
    /*============Layout with Constraints============*/
    NSDictionary* dictItems = NSDictionaryOfVariableBindings(_feedTableView,_commentPostView);
    NSArray* commentPostW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentPostView]|" options:0 metrics:nil views:dictItems];
    NSArray* feedTableW = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_feedTableView]|" options:0 metrics:nil views:dictItems];
    NSArray* combineH = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_feedTableView]-0-[_commentPostView(40)]-0-|" options:0 metrics:nil views:dictItems];
    [self.view addConstraints:commentPostW];
    [self.view addConstraints:feedTableW];
    [self.view addConstraints:combineH];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!insertDataHandler) {
        insertDataHandler = [[TableViewInsertDataHandler alloc]init];
        [insertDataHandler handleInsertData:_feedData ofTableView:_feedTableView];
    }
}

-(void)insertNewFeedInTable:(id)data{
    [insertDataHandler insertData:data];
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
    }else{
        if (selectedData != nil && [_feedData containsObject:selectedData]) {
            NSInteger row = [_feedData indexOfObject:selectedData];
            [reloadIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
        }
        selectedData = data;
    }
   
    [tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
