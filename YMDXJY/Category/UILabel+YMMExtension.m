//
//  UILabel+YMMExtension.m
//  yunmaimai
//
//  Created by laiyiss on 2017/11/4.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import "UILabel+YMMExtension.h"

@implementation UILabel (YMMExtension)

+ (UILabel *)labelWithTextColor:(UIColor *)color font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = textAlignment;
    [label sizeToFit];
    return label;
}

@end
