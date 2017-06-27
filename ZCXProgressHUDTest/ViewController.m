//
//  ViewController.m
//  ZCXProgressHUDTest
//
//  Created by ZhangCX on 2017/6/26.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//

#import "ViewController.h"
#import "ZCXHUDView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = [[NSArray alloc]initWithObjects:@"弹框",@"进度条",@"自定义", nil];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(self.view.frame.size.width / 2 - 50, 100 * i + 100, 100, 50);
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 100:
            [ZCXHUDView textMassageWith:@"alkdjflj" onView:self.view];
            break;
        case 101:
            [ZCXHUDView uploadHUDWith:@"正在上传" andName:@"取消" onView:self.view];
            
            for (NSInteger i = 0; i < 10000; i++) {
                float pro = i / 10000.0;
                [ZCXHUDView shareZCXHUDView].progress = pro;
                sleep(0.1);
            }
            break;
        case 102:
            [ZCXHUDView addHUDWithText:@"正在登陆" detailText:@"点击取消登录" showProgress:NO toVC:self.view];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
