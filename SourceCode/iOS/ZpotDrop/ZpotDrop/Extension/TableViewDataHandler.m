//
//  TableViewInsertDataHandler.m
//  ZpotDrop
//
//  Created by Son Truong on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "TableViewDataHandler.h"

@implementation TableViewDataHandler
-(instancetype)init{
    self = [super init];
    waitingData = [NSMutableArray array];
    canExcute = YES;
    self.addOnTop = YES;
    return self;
}
-(void)handleData:(NSMutableArray *)array ofTableView:(UITableView *)tableView{
    self.tableData = array;
    self.tableView = tableView;
}

-(void)insertData:(id)dataInsert{
    if (canExcute) {
        if ([dataInsert isKindOfClass:[NSArray class]] || [dataInsert isKindOfClass:[NSMutableArray class]]) {
            NSArray* array = (NSArray*)dataInsert;
            NSMutableArray* indexPaths = [NSMutableArray array];
            for (int i = 0; i < array.count; i++) {
                id data = [array objectAtIndex:(array.count - i -1)];
                if (self.addOnTop) {
                    [self.tableData insertObject:data atIndex:0];
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:array.count - i -1 inSection:0];
                    [indexPaths addObject:indexPath];
                }else{
                    [self.tableData addObject:data];
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.tableData.count-1 inSection:0];
                    [indexPaths addObject:indexPath];
                }
            }
        }else{
            if (self.addOnTop) {
                [self.tableData insertObject:dataInsert atIndex:0];
                [self beginReloadData:[NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]];
            }else{
                [self.tableData addObject:dataInsert];
                [self beginReloadData:[NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:self.tableData.count-1 inSection:0]]];
            }
        }
        
        
    }else{
        @synchronized(waitingData)
        {
            [waitingData addObject:dataInsert];
        }
    }
}
-(void)beginReloadData:(NSMutableArray*)indexPaths{
    canExcute = NO;
    if (self.addOnTop) {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
    }
    [self performSelector:@selector(resetFlag) withObject:nil afterDelay:0.3];
}

-(void)resetFlag{
    canExcute = YES;
    @synchronized(waitingData)
    {
        if (waitingData.count > 0) {
            NSMutableArray* indexPaths = [NSMutableArray array];
            for (int i = 0; i < waitingData.count; i++) {
                id data = [waitingData objectAtIndex:i];
                if (self.addOnTop) {
                    [self.tableData insertObject:data atIndex:0];
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:waitingData.count - i -1 inSection:0];
                    [indexPaths addObject:indexPath];
                }else{
                    [self.tableData addObject:data];
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.tableData.count-1 inSection:0];
                    [indexPaths addObject:indexPath];
                }
            }
            [waitingData removeAllObjects];
            [self beginReloadData:indexPaths];
        }
    }
}
@end
