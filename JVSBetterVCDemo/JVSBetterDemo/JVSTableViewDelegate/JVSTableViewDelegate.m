//
//  JVSTableViewDelegate.m
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "JVSTableViewDelegate.h"
#import "JVSBaseModel.h"
@interface JVSTableViewDelegate()

@property (nonatomic, strong) NSMutableArray *itemsArrM;
@end
@implementation JVSTableViewDelegate

- (instancetype)initWithItems:(NSMutableArray *)items andSelectedDelegate:(id)delegate
{
    if (self = [super init]) {
        self.itemsArrM = items;
        self.delegate = delegate;
    }
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVSBaseModel *item = self.itemsArrM[indexPath.row];
    return item.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVSBaseModel *item = self.itemsArrM[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectedCellWithItem:)]) {
        [self.delegate selectedCellWithItem:item];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


@end
