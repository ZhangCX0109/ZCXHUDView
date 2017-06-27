//
//  ZCXHUDView.m
//  01_AFN
//
//  Created by ZhangCX on 2017/6/8.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#import "ZCXHUDView.h"
#import "MBProgressHUD.h"
@interface ZCXHUDView ()
@property (nonatomic, strong)UIView *HUDView;//需要刷新UI的view
@property (nonatomic, strong)MBProgressHUD *HUD;//进度条hud；
@end
@implementation ZCXHUDView
+(ZCXHUDView *)shareZCXHUDView{
    static dispatch_once_t token;
    static ZCXHUDView * shareZCXHUDView;
    dispatch_once(&token, ^{
        shareZCXHUDView = [[ZCXHUDView alloc]init];
        shareZCXHUDView.userInteractionEnabled = YES;
    });
    return shareZCXHUDView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        float screenWidth = [UIScreen mainScreen].bounds.size.width;
        float screenHeight = [UIScreen mainScreen].bounds.size.height;
        self.backgroundColor = RGBA(255, 255, 255, 0.2);
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        //监听进度的变化
        [self addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

+ (void)addHUDWithText:(NSString *)text detailText:(NSString *)detailText showProgress:(BOOL)show toVC:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self shareZCXHUDView] animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    [view addSubview:[self shareZCXHUDView]];
    hud.label.text = text;
    hud.detailsLabel.text = detailText;
    hud.tag = 100;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hudTouched:)];
    
    [hud addGestureRecognizer:tap];
}

+ (void)hudTouched:(UITapGestureRecognizer *)tap{
    MBProgressHUD *hud = [[self shareZCXHUDView] viewWithTag:100];
    if (hud) {
        [hud hideAnimated:YES];
        [[self shareZCXHUDView] removeFromSuperview];
        [[self shareZCXHUDView].HUDDelegate whenHUDDidHidden];
    }
    
}

+ (void)hiddenWithAnimation{
    MBProgressHUD *hud = [[self shareZCXHUDView] viewWithTag:100];
    if (hud) {
        [hud hideAnimated:YES];
        [[self shareZCXHUDView] removeFromSuperview];
        [[self shareZCXHUDView].HUDDelegate whenHUDDidHidden];
    }
}

#pragma mark - hud功能块
//弹出信息框
+ (void)textMassageWith:(NSString *)msg onView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(msg, @"HUD message title");
    hud.offset = CGPointMake(0.f, -200.f);
    [hud hideAnimated:YES afterDelay:3.f];
}

//带进度条的加载动画
+ (void)uploadHUDWith:(NSString *)title andName:(NSString *)btnName onView:(UIView *)view{
    [ZCXHUDView shareZCXHUDView].HUDView = view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = NSLocalizedString(title, @"HUD loading title");
    [hud.button setTitle:NSLocalizedString(btnName, @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [ZCXHUDView shareZCXHUDView].HUD = hud;
    //进度条操作
    [[ZCXHUDView shareZCXHUDView]updateProgressOnView];
}
- (void)updateProgressOnView{
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    if (_progress <= 0.9900) {
        [MBProgressHUD HUDForView:_HUDView].progress = _progress;
    }else{
        [[ZCXHUDView shareZCXHUDView].HUD hideAnimated:YES];
    }
}
+ (void)cancelBtnClick:(UIButton *)btn{
    [[ZCXHUDView shareZCXHUDView].HUD hideAnimated:YES];
    [[self shareZCXHUDView].HUDDelegate cancelBtnClick];
}
#pragma mark - kvo 回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    float new = [change[@"new"] floatValue];
    float old = [change[@"old"] floatValue];
    if (new != old) {
        [self updateProgressOnView];
    }
    
}
@end
