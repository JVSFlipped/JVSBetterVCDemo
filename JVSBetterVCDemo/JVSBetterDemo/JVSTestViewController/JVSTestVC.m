//
//  JVSTestVC.m
//  JVSDataSourceTest
//
//  Created by 程硕 on 2018/4/15.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "JVSTestVC.h"
#import "JVSTestTableVC.h"
@interface JVSTestVC ()
@property (nonatomic, strong) UIButton *setTabLeViewBtn;

@property (nonatomic, strong) UIButton *removeTableViewBtn;

@property (nonatomic, strong) UIButton *disMissVCBtn;

@end

@implementation JVSTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (void)dealloc
{
    
}
- (void)initUI
{
    _setTabLeViewBtn = [UIButton new];
    self.view.backgroundColor = [UIColor whiteColor];
    [_setTabLeViewBtn setTitle:@"添加子控制器的View" forState:UIControlStateNormal];
    [_setTabLeViewBtn setTitle:@"添加子控制器的View" forState:UIControlStateSelected];
    _setTabLeViewBtn.backgroundColor = [UIColor lightGrayColor];
    [_setTabLeViewBtn addTarget:self action:@selector(addTableView) forControlEvents:UIControlEventTouchUpInside];
    _setTabLeViewBtn.frame = CGRectMake(self.view.frame.size.width/2-150, 50, 300, 40);
    _setTabLeViewBtn.clipsToBounds = YES;
    _setTabLeViewBtn.layer.cornerRadius = 5;
    [self.view addSubview:_setTabLeViewBtn];
    
    _removeTableViewBtn = [UIButton new];
    [_removeTableViewBtn setTitle:@"移除子控制器的View" forState:UIControlStateNormal];
    [_removeTableViewBtn setTitle:@"移除子控制器的View" forState:UIControlStateSelected];
    _removeTableViewBtn.backgroundColor = [UIColor lightGrayColor];
    [_removeTableViewBtn addTarget:self action:@selector(removeTableView) forControlEvents:UIControlEventTouchUpInside];
    _removeTableViewBtn.frame = CGRectMake(self.view.frame.size.width/2-150, 100, 300, 40);
    _removeTableViewBtn.clipsToBounds = YES;
    _removeTableViewBtn.layer.cornerRadius = 5;
    [self.view addSubview:_removeTableViewBtn];
    
    _disMissVCBtn = [UIButton new];
    [_disMissVCBtn setTitle:@"弹出控制器" forState:UIControlStateNormal];
    [_disMissVCBtn setTitle:@"弹出控制器" forState:UIControlStateSelected];
    _disMissVCBtn.backgroundColor = [UIColor lightGrayColor];
    [_disMissVCBtn addTarget:self action:@selector(disMissVC) forControlEvents:UIControlEventTouchUpInside];
    _disMissVCBtn.frame = CGRectMake(self.view.frame.size.width/2-150, 150, 300, 40);
    _disMissVCBtn.clipsToBounds = YES;
    _disMissVCBtn.layer.cornerRadius = 5;
    [self.view addSubview:_disMissVCBtn];
    
    
}

- (void)addTableView
{
    if (self.childViewControllers.count) {
        return;
    }
    JVSTestTableVC *TESTVC = [[JVSTestTableVC alloc] init];
    // 添加子控制器,必须写,否则此方法结束, TESTVC就被释放了
    [self addChildViewController:TESTVC];
//    [TESTVC willMoveToParentViewController:self]; 自动调用, 省略
//    [TESTVC didMoveToParentViewController:self]; 可省略
    UIView *subTableView = TESTVC.view;
    subTableView.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height-300);
    [self.view addSubview:subTableView];
}

- (void)removeTableView
{
    JVSTestVC *childVC = self.childViewControllers.firstObject;
    [childVC willMoveToParentViewController:nil];
    [childVC removeFromParentViewController];
    //    [_TESTChildVC didMoveToParentViewController:nil]; 自动调用, 省略
    NSLog(@"还剩%lu个控制器", self.childViewControllers.count); //打印为0
}
- (void)disMissVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    JVSTestTableVC *vc = self.childViewControllers.firstObject;
    if ([vc respondsToSelector:@selector(reloadData)]) {
        [vc reloadData];
    }
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
