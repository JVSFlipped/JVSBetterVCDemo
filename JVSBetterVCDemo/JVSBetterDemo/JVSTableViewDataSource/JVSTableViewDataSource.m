//
//  JVSTableViewDataSource.m
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "JVSTableViewDataSource.h"
#import "JVSBaseModel.h"

@implementation JVSTableViewDataSource

- (instancetype)initWithItems:(NSMutableArray *)items  andConfigureCellBlock:(configureCell)configureCellBlock
{
    if (self = [super init]) {
        self.cellConfigureCellBlock = configureCellBlock;
        self.itemsArrM = items;
    }
    return self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVSBaseModel *item = self.itemsArrM[indexPath.row];
    if (!item.identifier) {
        @throw [NSException exceptionWithName:@"identifierError" reason:
                [NSString stringWithFormat:@"identifier为空"] userInfo:nil];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.identifier];
    if (nil == cell) {
        @throw [NSException exceptionWithName:@"cellNilError" reason:
                [NSString stringWithFormat:@"有取到对应的cell, 请检查该tableView是否注册了%@的cell",item.identifier] userInfo:nil];
    }
    
    self.cellConfigureCellBlock(cell, item);
    return cell;
}
@end
