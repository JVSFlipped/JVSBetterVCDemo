//
//  JVSTestTableViewCell+ConfigureCellMethod.m
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "JVSTestTableViewCell+ConfigureCellMethod.h"
#import "JVSTestCellModel.h"
@implementation JVSTestTableViewCell (ConfigureCellMethod)

- (void)configureCellWithModel:(JVSTestCellModel *)item
{
    if (item.imageName.length>0) {
        self.imageV.image = [UIImage imageNamed:item.imageName];
    } else {
       self.titleL.text = item.title;
    }
}
@end
