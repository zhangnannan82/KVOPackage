//
//  nnNextViewController.m
//  KVOPackage
//
//  Created by 张楠 on 2018/8/5.
//  Copyright © 2018年 nangnahz.nan. All rights reserved.
//

#import "nnNextViewController.h"

@interface nnNextViewController ()

@end

@implementation nnNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"第二个";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    btn.frame = CGRectMake(100, 150, 100, 100);
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
