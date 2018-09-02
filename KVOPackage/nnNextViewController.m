//
//  nnNextViewController.m
//  KVOPackage
//
//  Created by 张楠 on 2018/8/5.
//  Copyright © 2018年 nangnahz.nan. All rights reserved.
//

#import "nnNextViewController.h"
//#import "NSObject+NNKVO.h"
#import "NSObject+NNNewKVO.h"
#import "Person.h"

@interface nnNextViewController ()

//@property (nonatomic, strong) Person *person;

@end

@implementation nnNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"第二个";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    btn.frame = CGRectMake(100, 150, 100, 100);
    [btn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    Person *person = [[Person alloc] init];
    [self nnObserver:person keyPath:@"name" block:^{
        NSLog(@"good!!");
    }];
//    [person nnObserver:self keyPath:@"name" block:^{
//        NSLog(@"good");
//    }];
    person.name = @"122";
}

- (void)popAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
