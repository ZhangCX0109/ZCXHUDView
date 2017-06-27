//
//  ZCXHUDView.h
//  01_AFN
//
//  Created by ZhangCX on 2017/6/8.
//  Copyright © 2017年 ZhangCX. All rights reserved.
//

#import <UIKit/UIKit.h>
//取消按钮的block回调
typedef void (^CancelBtnblock) (void);
@protocol ZCXHUDViewDelegate <NSObject>

- (void)whenHUDDidHidden;
- (void)cancelBtnClick;
@end

@interface ZCXHUDView : UIView
@property (nonatomic, assign)id<ZCXHUDViewDelegate> HUDDelegate;
@property (nonatomic, assign)float progress;

+(ZCXHUDView *)shareZCXHUDView;
+ (void)hiddenWithAnimation;
+ (void)addHUDWithText:(NSString *)text detailText:(NSString *)detailText showProgress:(BOOL)show toVC:(UIView *)view;
+ (void)textMassageWith:(NSString *)msg onView:(UIView *)view;
+ (void)uploadHUDWith:(NSString *)title andName:(NSString *)btnName onView:(UIView *)view;
@end
