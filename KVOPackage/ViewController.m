//
//  ViewController.m
//  KVOPackage
//
//  Created by 张楠 on 2018/8/5.
//  Copyright © 2018年 nangnahz.nan. All rights reserved.
//

#import "ViewController.h"
#import "nnNextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"首页";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 150, 100, 100);
    [btn addTarget:self action:@selector(naxtpage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)naxtpage:(UIButton *)button {
    nnNextViewController *nextVC = [[nnNextViewController alloc] init];
    [self presentViewController:nextVC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
