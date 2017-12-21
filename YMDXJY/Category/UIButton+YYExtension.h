//
//  UIButton+YYExtension.h
//  yunyue
//
//  Created by LiuQingying on 2016/12/24.
//  Copyright © 2016年 zhanlijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YYExtension)
/**
 增大按钮的点击范围
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;


// button 创建
+ (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)color;

+ (UIButton *)buttonWithImage:(NSString *)image;

@end
