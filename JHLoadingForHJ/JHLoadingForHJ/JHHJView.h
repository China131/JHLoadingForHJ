//
//  JHHJView.h
//  JHLoadingForHJ
//
//  Created by 简豪 on 16/8/10.
//  Copyright © 2016年 codingMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define K_IOS_WIDTH [UIScreen mainScreen].bounds.size.width
#define K_IOS_HEIGHT [UIScreen mainScreen].bounds.size.height
#define weakSelf(a) __weak typeof(self) a = self;

typedef  NS_ENUM(NSInteger,JHHJViewType){
    /**
     *  线性动画
     */
    JHHJViewTypeSingleLine = 0,
    
    /**
     *  方形点动画
     */
    JHHJViewTypeSquare = 1,
    
    /**
     *  三角形运动动画
     */
    JHHJViewTypeTriangleTranslate = 2,
    
    /**
     *  原型视图裁剪动画
     */
    JHHJViewTypeClip
};

@interface JHHJView : UIView


/*        显示加载动画 并添加到父视图上         */
+ (void)showLoadingOnView:(UIView *)superView Type:(JHHJViewType)type;

/*        显示动画 并添加在主窗口上         */
+ (void)showLoadingOnTheKeyWindowWithType:(JHHJViewType)type;

/*        停止动画         */
+ (void)hideLoading;

/*        设置动画背景色（全屏背景色）         */
+ (void)backgroudColor:(UIColor *)color;

/*        设置中心视图的动画背景颜色 默认透明色         */
+ (void)centerBGViewBackgroudColor:(UIColor *)color;
@end
