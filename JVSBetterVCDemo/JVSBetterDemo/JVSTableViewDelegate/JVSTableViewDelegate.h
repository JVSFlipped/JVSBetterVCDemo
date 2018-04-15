//
//  JVSTableViewDelegate.h
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JVSBaseModel;
@protocol JVSTabelViewSeletedDelegate

/**
 * 点击 cell 的代理

 @param item 点击的 cell 对应的模型
 */
- (void)selectedCellWithItem:(JVSBaseModel *)item;

@end

/**
 * 通用的 tableView 代理, 支持不同样式的 cell, 但是不支持多个 section, 也不支持 sectionHeader 和 footerHeader.
 */
@interface JVSTableViewDelegate : NSObject <UITableViewDelegate>


/**
 * 点击 cell 时候处理的代理.
 */
@property (nonatomic, weak) id<JVSTabelViewSeletedDelegate, NSObject> delegate;

/**
 * 初始化方法

 @param items 模型数组
 @param delegate 点击cell的代理
 @return 实例
 */
- (instancetype)initWithItems:(NSMutableArray *)items andSelectedDelegate:(id)delegate;

@end
