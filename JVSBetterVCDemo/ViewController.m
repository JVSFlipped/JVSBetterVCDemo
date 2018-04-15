//
//  ViewController.m
//  JVSBetterVCDemo
//
//  Created by 程硕 on 2018/4/16.
//  Copyright © 2018年 Flipped. All rights reserved.
//

#import "ViewController.h"
#import "JVSTestVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    JVSTestVC *testVC = [[JVSTestVC alloc] init];
    
    [self presentViewController:testVC animated:YES completion:nil];
}


@end
