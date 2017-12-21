//
//  UIColor+YMMExtention.h
//  yunmaimai
//
//  Created by laiyiss on 2017/10/25.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YMMExtention)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end
