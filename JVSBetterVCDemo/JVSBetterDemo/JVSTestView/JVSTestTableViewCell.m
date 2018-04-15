//
//  JVSTestTableViewCell.m
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "JVSTestTableViewCell.h"
@implementation JVSTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier isEqualToString:@"JVSTestCellStyleImage"])
        {
            [self initImageCell];
        } else if([reuseIdentifier isEqualToString:@"JVSTestCellStyleTitle"])
        {
            [self initTitleCell];
        }
    }
    return self;
}

- (void)initTitleCell
{
    _titleL = [[UILabel alloc] init];
    _titleL.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleL];
}


- (void)initImageCell
{
    _imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageV];
    
}

- (void)layoutSubviews
{
    if ([self.reuseIdentifier isEqualToString:@"JVSTestCellStyleImage"]) {
        self.imageV.frame = self.contentView.bounds;
    } else if ([self.reuseIdentifier isEqualToString:@"JVSTestCellStyleTitle"]) {
        self.titleL.frame = self.contentView.bounds;
    }
}
@end
