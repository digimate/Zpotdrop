//
//  TableViewInsertDataHandler.m
//  ZpotDrop
//
//  Created by Son Truong on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "TableViewInsertDataHandler.h"

@implementation TableViewInsertDataHandler
-(instancetype)init{
    self = [super init];
    waitingData = [NSMutableArray array];
    canInsert = YES;
    self.addOnTop = YES;
    return self;
}
-(void)handleInsertData:(NSMutableArray *)array ofTableView:(UITableView *)tableView{
    self.tableData = array;
    self.tableView = tableView;
}

-(void)insertData:(id)data{
    if (canInsert) {
        if (self.addOnTop) {
            [self.tableData insertObject:data atIndex:0];
            [self beginReloadData:[NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]];
        }else{
            [self.tableData addObject:data];
            [self beginReloadData:[NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:self.tableData.count-1 inSection:0]]];
        }
        
    }else{
        @synchronized(waitingData)
        {
            [waitingData addObject:data];
        }
    }
}
-(void)beginReloadData:(NSMutableArray*)indexPaths{
    canInsert = NO;
    if (self.addOnTop) {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
    }
    [self performSelector:@selector(resetFlag) withObject:nil afterDelay:0.3];
}

-(void)resetFlag{
    canInsert = YES;
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
