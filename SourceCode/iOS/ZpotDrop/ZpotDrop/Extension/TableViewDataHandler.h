//
//  TableViewInsertDataHandler.h
//  ZpotDrop
//
//  Created by Son Truong on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableViewDataHandler : NSObject{
    NSMutableArray* waitingData;
    BOOL canExcute;
}
@property(atomic,weak)NSMutableArray* tableData;
@property(atomic,weak)UITableView* tableView;
@property(nonatomic, assign)BOOL addOnTop;
-(void)handleData:(NSMutableArray*)array ofTableView:(UITableView*)tableView;
-(void)insertData:(id)data;
@end
