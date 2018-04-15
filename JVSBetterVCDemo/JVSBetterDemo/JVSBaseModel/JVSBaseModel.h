//
//  JVSBaseModel.h
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JVSBaseModel : NSObject

/**
 * 判断 model 对应的 cell 是否是被选中状态
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 * model 对应 cell 的 identifier
 */
@property (nonatomic, copy) NSString *identifier;


/**
 * cell 的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;


/**
 * 子类一定要实现的方法, 一般用来根据 model 的内容来设置 identifier 以达到区分不同 cell 的目的.
 */
- (void)configureModel;

@end
