//
//  JVSTestTableViewCell+ConfigureCellMethod.h
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "JVSTestTableViewCell.h"
@class JVSTestCellModel;
@interface JVSTestTableViewCell (ConfigureCellMethod)
- (void)configureCellWithModel:(JVSTestCellModel *)item;
@end
