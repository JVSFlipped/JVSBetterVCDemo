//
//  JVSTableViewDataSource.h
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JVSBaseModel.h"

/**
 * 配置 cell 的 block

 @param cell 需要配置的 cell
 @param item 模型
 */
typedef void (^configureCell)(UITableViewCell *cell, JVSBaseModel *item);

/**
 * 通用的简易 tableViewDataSource, 支持多种不同的 cell, 不过不支持多个 section 以及头部和尾部视图
 */
@interface JVSTableViewDataSource : NSObject<UITableViewDataSource>

/**
 * 配置 cell 的 block
 */
@property (nonatomic, copy) configureCell cellConfigureCellBlock;


/**
 * 模型数组
 */
@property (nonatomic, strong) NSMutableArray *itemsArrM;

/**
 * 初始化方法

 @param items 模型数组
 @param configureCellBlock 配置 cell 的 block
 @return 实例对象
 */
- (instancetype)initWithItems:(NSMutableArray *)items  andConfigureCellBlock:(configureCell)configureCellBlock;
@end
