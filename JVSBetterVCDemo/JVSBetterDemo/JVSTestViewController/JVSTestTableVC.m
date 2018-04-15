//
//  JVSTestTableVC.m
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/14.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "JVSTestTableVC.h"
#import "JVSTableViewDataSource.h"
#import "JVSTableViewDelegate.h"
#import "JVSTestTableViewCell+ConfigureCellMethod.h"
#import "JVSTestCellModel.h"


@interface JVSTestTableVC ()<JVSTabelViewSeletedDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *itemArrM;

@property (nonatomic, strong) JVSTableViewDelegate *tableViewDelegate;

@property (nonatomic, strong) JVSTableViewDataSource *tableViewDataSource;

@end

@implementation JVSTestTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addTableView];
    [self addData];
    
//    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"JVSTestTableVC的viewWillAppear调用了");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"JVSTestTableVC的viewDidAppear调用了");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"JVSTestTableVC的viewWillDisappear调用了");
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"JVSTestTableVC的viewDidDisappear调用了");
}

- (void)dealloc
{
    NSLog(@"JVSTestTableVC的dealloc调用了");
}
- (void)addTableView
{
    
    _tableView = [[UITableView alloc] init];
    [_tableView registerClass:[JVSTestTableViewCell class] forCellReuseIdentifier:@"JVSTestCellStyleTitle"];
    [_tableView registerClass:[JVSTestTableViewCell class] forCellReuseIdentifier:@"JVSTestCellStyleImage"];
    
    JVSTableViewDataSource *dataSource =  [[JVSTableViewDataSource alloc] initWithItems:self.itemArrM andConfigureCellBlock:^(UITableViewCell *cell, JVSBaseModel *item) {
        JVSTestTableViewCell *sameCell = (JVSTestTableViewCell *)cell;
        JVSTestCellModel *sameItem = (JVSTestCellModel *)item;
        [sameCell configureCellWithModel:sameItem];
    }];
    _tableView.dataSource = dataSource;
    _tableViewDataSource = dataSource;
    
    JVSTableViewDelegate *delegate = [[JVSTableViewDelegate alloc] initWithItems:self.itemArrM andSelectedDelegate:self];
    _tableViewDelegate = delegate;
    _tableView.delegate = delegate;
    
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200);
    [self.view addSubview:_tableView];
    
}

- (NSMutableArray *)itemArrM
{
    if (!_itemArrM) {
        _itemArrM = [NSMutableArray array];
    }
    return _itemArrM;
}

- (void)addData
{
    
    for (NSInteger i = 0; i<20; i++) {
        JVSTestCellModel *item = [[JVSTestCellModel alloc] init];
        BOOL isTitle = ((i%2) == 0);
        if (isTitle) {
            item.imageName = @"ZELDA";
        } else {
            item.title = @"塞尔达天下第一";
        }
        [item configureModel];
        [self.itemArrM addObject:item];
    }
    
}

- (void)selectedCellWithItem:(JVSBaseModel *)item
{
    JVSTestCellModel *sameItem = (JVSTestCellModel *)item;
    NSString *content = sameItem.imageName.length>0?sameItem.imageName:sameItem.title;
    NSLog(@"点击的cell的表标识为%@",content);
}

- (void)reloadData
{
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
