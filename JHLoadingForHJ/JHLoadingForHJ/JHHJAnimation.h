//
//  JHHJAnimation.h
//  JHLoadingForHJ
//
//  Created by 简豪 on 16/8/10.
//  Copyright © 2016年 codingMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JHHJAnimation : NSObject

/*        缩小动画 无自动恢复效果         */
+ (CABasicAnimation *)animationForScaleSmall;

/*        缩小动画 自动恢复效果         */
+ (CABasicAnimation *)animationForScaleAutoreverses;

/*        透明度动画         */
+ (CABasicAnimation *)animationForAlpha;

/*        旋转动画         */
+ (CABasicAnimation *)rotateAnimation;




@end
