//
//  JVSTestCellModel.m
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "JVSTestCellModel.h"

@implementation JVSTestCellModel

- (void)configureModel
{
    if (self.title) {
        self.identifier = @"JVSTestCellStyleTitle";
        self.cellHeight = 100;
    }
    if (self.imageName) {
        self.identifier = @"JVSTestCellStyleImage";
        self.cellHeight = 200;
    }
}
@end
