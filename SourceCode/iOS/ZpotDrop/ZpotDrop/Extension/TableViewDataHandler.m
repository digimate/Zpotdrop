//
//  TableViewInsertDataHandler.m
//  ZpotDrop
//
//  Created by Son Truong on 8/5/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "TableViewDataHandler.h"
#import "CoreDataService.h"

#define TIME_RESET 0.2

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

-(void)removeData:(id)data{
    if (canExcute) {
        if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSMutableArray class]]) {
            NSArray* dataArray = (NSArray*)data;
            canExcute = NO;
            NSMutableArray* deleteIndexPaths = [NSMutableArray array];
            for (id object in dataArray) {
                if ([self.tableData containsObject:object]) {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.tableData indexOfObject:object] inSection:0];
                    [deleteIndexPaths addObject:indexPath];
                    [self.tableData removeObject:object];
                    if ([object isKindOfClass:[NSManagedObject class]]&& ![(NSManagedObject*)object isFault]) {
                        [[CoreDataService instance] deleteEntity:object];
                        [[CoreDataService instance]saveContext];
                    }
                }
            }
            [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationRight];
            [self performSelector:@selector(resetFlag) withObject:nil afterDelay:TIME_RESET];
        }else{
            if ([self.tableData containsObject:data]) {
                canExcute = NO;
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.tableData indexOfObject:data] inSection:0];
                [self.tableData removeObject:data];
                if ([data isKindOfClass:[NSManagedObject class]] && ![(NSManagedObject*)data isFault]) {
                    [[CoreDataService instance] deleteEntity:data];
                    [[CoreDataService instance]saveContext];
                }
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self performSelector:@selector(resetFlag) withObject:nil afterDelay:TIME_RESET];
            }
        }
        
    }else{
       
        if (!removeList) {
            removeList = [NSMutableArray array];
        }
        @synchronized(removeList){
            if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSMutableArray class]]) {
                [removeList addObjectsFromArray:data];
            }else{
                [removeList addObject:data];
            }
        }
    }
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
    [self performSelector:@selector(resetFlag) withObject:nil afterDelay:TIME_RESET];
}

-(void)resetFlag{
    canExcute = YES;
    
    if (waitingData.count > 0) {
        @synchronized(waitingData)
        {
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
    }else if (removeList.count > 0){
        @synchronized(removeList)
        {
            NSMutableArray* indexPaths = [NSMutableArray array];
            for (id data in removeList) {
                if ([self.tableData containsObject:data]) {
                    canExcute = NO;
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.tableData indexOfObject:data] inSection:0];
                    if ([data isKindOfClass:[NSManagedObject class]]) {
                        [[CoreDataService instance] deleteEntity:data];
                    }
                    [self.tableData removeObjectAtIndex:indexPath.row];
                    
                    [indexPaths addObject:indexPath];
                }
            }
            [removeList removeAllObjects];
            [[CoreDataService instance]saveContext];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
            [self performSelector:@selector(resetFlag) withObject:nil afterDelay:TIME_RESET];
        }
    }
}
@end
