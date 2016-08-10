//
//  JHHJView.m
//  JHLoadingForHJ
//
//  Created by 简豪 on 16/8/10.
//  Copyright © 2016年 codingMan. All rights reserved.
//

#import "JHHJView.h"
#import "JHHJAnimation.h"
#import "JHHJCenterBGView.h"

@interface JHHJView ()

//中心背景视图
@property (nonatomic,strong)JHHJCenterBGView *centerBGView;

//计时器
@property (nonatomic,strong)NSTimer * clipTimer;

//层数组
@property (nonatomic,strong)NSMutableArray * clipLayerArr;

//计时器计量数
@property (nonatomic,assign) long long currentTimerIndex;

//背景层
@property (nonatomic,strong) CAShapeLayer *bgLayer;
@end

@implementation JHHJView


/**
 *  对象单例化
 *
 *  @return 单例对象
 */
+ (JHHJView *)shareInstanceJHHJView{
    
    static JHHJView * instance = nil;
    if (!instance) {
        
        instance                     = [[JHHJView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        instance.centerBGView        = [[JHHJCenterBGView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        instance.centerBGView.center = CGPointMake(K_IOS_WIDTH / 2, K_IOS_HEIGHT/2);
        [instance addSubview:instance.centerBGView];
    }
    
    return instance;
}

/**
 *  设置加载视图的背景颜色 默认透明色
 *
 *  @param color 目标背景颜色
 */
+(void)backgroudColor:(UIColor *)color{
    [[self class] shareInstanceJHHJView].backgroundColor = color;
}



/**
 *  展示动画视图 并添加到依赖视图上
 *
 *  @param superView 依赖的父视图
 *  @param type      动画样式
 */
+ (void)showLoadingOnView:(UIView *)superView Type:(JHHJViewType)type{
    /*        在显示前  先从父视图移除当前动画视图         */
    JHHJView *instance = [[self class] shareInstanceJHHJView];
    [[self class] hideLoading];
    
    
    /*        显示前 先将动画图层从中心视图上移除         */
    for (CALayer *layer in instance.centerBGView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    /*        按照type初始化动画         */
    switch (type) {
        case JHHJViewTypeSingleLine:
        {
            CALayer *layer = [instance lineAnimation];
            layer.position = CGPointMake(CGRectGetWidth(instance.centerBGView.frame)/2 - 25, CGRectGetHeight(instance.centerBGView.frame)/2);
            [instance.centerBGView.layer addSublayer:layer];
        }break;
            
        case JHHJViewTypeSquare:
        {
            CALayer *layer = [[self class] qurareAnimation];
            layer.position = CGPointMake(CGRectGetWidth(instance.centerBGView.frame)/2, CGRectGetHeight(instance.centerBGView.frame)/2);
            [instance.centerBGView.layer addSublayer:layer];
        }break;
        case JHHJViewTypeTriangleTranslate:
        {
            CALayer *layer = [[self class] triangleAnimation];
            layer.position = CGPointMake(CGRectGetWidth(instance.centerBGView.frame)/2 - 18, CGRectGetHeight(instance.centerBGView.frame)/2 - 15);
            [instance.centerBGView.layer addSublayer:layer];
        }break;
        case JHHJViewTypeClip:
        {
            
            CALayer *layer = [[self class] clipAnimation];
            layer.position = CGPointMake(CGRectGetWidth(instance.centerBGView.frame)/2 , CGRectGetHeight(instance.centerBGView.frame)/2 - 15);
            [instance.centerBGView.layer addSublayer:layer];
            
        }break;
        default:
            break;
    }
    [superView addSubview:instance];
}


/**
 *  在主窗口显示动画
 *
 *  @param type 动画类型
 */
+ (void)showLoadingOnTheKeyWindowWithType:(JHHJViewType)type{
 
    [[self class] showLoadingOnView:[[[UIApplication sharedApplication] delegate] window] Type:type];
}


/**
 *  停止动画
 */
+ (void)hideLoading{
    JHHJView *instance = [[self class] shareInstanceJHHJView];
    if (instance.clipTimer) {
        [instance.clipTimer invalidate];
        instance.clipTimer = nil;
    }
    [[[self class] shareInstanceJHHJView] removeFromSuperview];
}



/**
 *  线性点动画
 *
 *  @return 动画实例对象
 */
- (CALayer *)lineAnimation{
    /*        创建模板层         */
    CAShapeLayer *shape           = [CAShapeLayer layer];
    shape.frame                   = CGRectMake(0, 0, 20, 20);
    shape.path                    = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)].CGPath;
    shape.fillColor               = [UIColor redColor].CGColor;
    [shape addAnimation:[JHHJAnimation animationForScaleSmall] forKey:nil];

    
    /*        创建克隆层的持有对象         */
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame              = CGRectMake(0, 0, 20, 20);
    replicator.instanceDelay      = 0.35;
    replicator.instanceCount      = 3;
    replicator.instanceTransform  = CATransform3DMakeTranslation(25, 0, 0);
    [replicator addSublayer:shape];
    return replicator;

}

/**
 *  正方形点动加载动画
 *
 *  @return <#return value description#>
 */
+ (CALayer *)qurareAnimation{
    /*        基本间距及模板层的创建         */
    NSInteger column                    = 3;
    CGFloat between                     = 5.0;
    CGFloat radius                      = (50 - between * (column - 1))/column;
    CAShapeLayer *shape                 = [CAShapeLayer layer];
    shape.frame                         = CGRectMake(0, 0, radius, radius);
    shape.path                          = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.fillColor                     = [UIColor redColor].CGColor;
    
    
    /*        创建动画组         */
    CAAnimationGroup *animationGroup    = [CAAnimationGroup animation];
    animationGroup.animations           = @[[JHHJAnimation animationForScaleAutoreverses], [JHHJAnimation animationForAlpha]];
    animationGroup.duration             = 0.8;
    animationGroup.autoreverses         = YES;
    animationGroup.repeatCount          = HUGE;
    [shape addAnimation:animationGroup forKey:@"groupAnimation"];
    
    
    /*        创建第一行的动画克隆层对象         */
    CAReplicatorLayer *replicatorLayerX = [CAReplicatorLayer layer];
    replicatorLayerX.frame              = CGRectMake(0, 0, 100, 100);
    replicatorLayerX.instanceDelay      = 0.3;
    replicatorLayerX.instanceCount      = column;
    replicatorLayerX.instanceTransform  = CATransform3DTranslate(CATransform3DIdentity, radius+between, 0, 0);
    [replicatorLayerX addSublayer:shape];
    
    
    /*        创建3行的动画克隆层对象         */
    CAReplicatorLayer *replicatorLayerY = [CAReplicatorLayer layer];
    replicatorLayerY.frame              = CGRectMake(0, 0, 50, 50);
    replicatorLayerY.instanceDelay      = 0.3;
    replicatorLayerY.instanceCount      = column;
    
    
    /*        给CAReplicatorLayer对象的子层添加转换规则 这里决定了子层的布局         */
    replicatorLayerY.instanceTransform  = CATransform3DTranslate(CATransform3DIdentity, 0, radius+between, 0);
    [replicatorLayerY addSublayer:replicatorLayerX];
    return replicatorLayerY;

}

/**
 *  三角形运动动画
 *
 *  @return 动画实例对象
 */
+ (CALayer *)triangleAnimation{
    /*        基本间距确定及模板层的创建         */
    CGFloat radius                     = 50/4.0;
    CGFloat transX                     = 50 - radius;
    CAShapeLayer *shape                = [CAShapeLayer layer];
    shape.frame                        = CGRectMake(0, 0, radius, radius);
    shape.path                         = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.strokeColor                  = [UIColor redColor].CGColor;
    shape.fillColor                    = [UIColor redColor].CGColor;
    shape.lineWidth                    = 1;
    [shape addAnimation:[JHHJAnimation rotateAnimation] forKey:@"rotateAnimation"];
    
    /*        创建克隆层         */
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame              = CGRectMake(0, 0, radius, radius);
    replicatorLayer.instanceDelay      = 0.0;
    replicatorLayer.instanceCount      = 3;
    CATransform3D trans3D              = CATransform3DIdentity;
    trans3D                            = CATransform3DTranslate(trans3D, transX, 0, 0);
    trans3D                            = CATransform3DRotate(trans3D, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    replicatorLayer.instanceTransform  = trans3D;
    [replicatorLayer addSublayer:shape];
    return replicatorLayer;

}

/**
 *  设置中心动画的背景视图背景颜色
 *
 *  @param color 背景颜色
 */
+(void)centerBGViewBackgroudColor:(UIColor *)color{
    
    JHHJView *instance  = [[self class] shareInstanceJHHJView];
    CAShapeLayer *layer = (CAShapeLayer *)instance.centerBGView.layer;
    layer.fillColor     = color.CGColor;
    
}

/**
 *  滚动动画
 *
 *  @return 动画实例
 */
+ (CALayer *)clipAnimation{
    /*        创建背景层         */
    CALayer * BGLayer         = [CALayer layer];
    CAShapeLayer *bottomShape = [CAShapeLayer layer];
    bottomShape.path          = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 40, 40)].CGPath;
    bottomShape.fillColor     = [UIColor redColor].CGColor;
    BGLayer.frame             = CGRectMake(0, 0, 40, 40);
    [BGLayer addSublayer:bottomShape];
    
    
    /*        创建4个动画层的起点中心数组         */
    NSArray *fromValueArr = @[
                             [NSValue valueWithCGPoint:CGPointMake(60, 20)], //右
                             [NSValue valueWithCGPoint:CGPointMake(20, -20)],//上
                             [NSValue valueWithCGPoint:CGPointMake(-20, 20)],//左
                             [NSValue valueWithCGPoint:CGPointMake(20, -60)]//下
    ];
    

    JHHJView *instance = [[self class] shareInstanceJHHJView];
    instance.clipLayerArr = [NSMutableArray array];
    
    
    /*        添加滚动的layer到数组中         */
    for (NSInteger i = 0; i<fromValueArr.count; i++) {
        CGPoint p               = [fromValueArr[i] CGPointValue];
        CAShapeLayer *clipShape = [CAShapeLayer layer];
        clipShape.path          = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0, 40, 40)].CGPath;
        clipShape.fillColor     = [UIColor whiteColor].CGColor;
        clipShape.frame         = CGRectMake(0, 0, 40, 40);
        clipShape.position      = p;
        [BGLayer addSublayer:clipShape];
        [instance.clipLayerArr addObject:clipShape];
    }
    
    /*        启动定时器         */
    instance.clipTimer         = [NSTimer scheduledTimerWithTimeInterval:.5f target:instance selector:@selector(clipFire) userInfo:nil repeats:YES];
    instance.currentTimerIndex = -1;
    [instance.clipTimer fire];
    instance.bgLayer           = bottomShape;
    return BGLayer;
    
    
}


/**
 *  定时器回调方法
 */
- (void)clipFire{
    /*        当前计量+1         */
    _currentTimerIndex ++;
    
    
    /*        创建下一个动画的起点中心数组和终点中心数组         */
    NSArray *fromValueArr = @[
                              [NSValue valueWithCGPoint:CGPointMake(60, 20)], //右
                              [NSValue valueWithCGPoint:CGPointMake(20, -20)],//上
                              [NSValue valueWithCGPoint:CGPointMake(-20, 20)],//左
                              [NSValue valueWithCGPoint:CGPointMake(20, 60)]//下
                              ];
    
    NSArray *toValueArr  = @[
                             [NSValue valueWithCGPoint:CGPointMake(-20, 20)],
                             [NSValue valueWithCGPoint:CGPointMake(20, 60)],
                             [NSValue valueWithCGPoint:CGPointMake(60, 20)],
                             [NSValue valueWithCGPoint:CGPointMake(20, -20)]
                             ];
    
    /*        动画背景层的填充颜色数组         */
    NSArray *color = @[[UIColor redColor],[UIColor greenColor],[UIColor orangeColor],[UIColor blueColor]];
    
    /*        给下一个要启动的layer添加动画         */
    if (_clipLayerArr.count>=4) {
        CAShapeLayer *layer     = _clipLayerArr[_currentTimerIndex%_clipLayerArr.count];
        [layer removeAllAnimations];
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"position"];
        _bgLayer.fillColor      = [color[_currentTimerIndex%_clipLayerArr.count] CGColor];
        basic.fromValue         = fromValueArr[_currentTimerIndex%_clipLayerArr.count];
        basic.toValue           = toValueArr[_currentTimerIndex%_clipLayerArr.count];
        basic.autoreverses      = NO;
        basic.duration          = .5;
        basic.repeatCount       = 1;
        basic.fillMode          = kCAFillModeForwards;
        basic.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [layer addAnimation:basic forKey:nil];

    }
    
}

@end
