//
//  JHHJCenterBGView.m
//  JHLoadingForHJ
//
//  Created by 简豪 on 16/8/10.
//  Copyright © 2016年 codingMan. All rights reserved.
//

#import "JHHJCenterBGView.h"

@implementation JHHJCenterBGView


/**
*  重载系统方法 设置self.layer为CAShapeLayer对象 以实现圆角效果 避免离屏渲染
*
*  @return self.layer类
*/
+(Class)layerClass{
    
    
    return [CAShapeLayer class];
    
}


/**
 *  重写初始化方法 设置圆角效果
 *
 *  @param 布局frame
 *
 *  @return 实例对象
 */
-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        /*        设置圆角         */
        [self setup];
    }
    return self;
    
}

/**
 *  重写Nib方式唤起方法 设置圆角
 */
-(void)awakeFromNib{
    /*        设置圆角         */
    [self setup];
}


/**
 *  设置圆角效果
 */
- (void)setup{
    CAShapeLayer *shapelayer = (CAShapeLayer *)self.layer;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:15];
    shapelayer.path = path.CGPath;
    shapelayer.fillColor = [UIColor clearColor].CGColor;
}
@end
