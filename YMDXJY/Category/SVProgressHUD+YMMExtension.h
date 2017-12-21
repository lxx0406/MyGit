//
//  SVProgressHUD+YMMExtension.h
//  yunmaimai
//
//  Created by LiuQingying on 2017/10/31.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (YMMExtension)

/**
 提示几秒后消失

 @param message 提示信息
 @param second 展示时长
 */
+ (void)showTips:(NSString*)message times:(CGFloat)second;
/**
 提示几秒后消失
 
 @param message 错误信息
 @param second 展示时长
 */
+ (void)showErrorTips:(NSString*)message times:(CGFloat)second;

+ (void)showSuccessTips:(NSString*)message times:(CGFloat)second;

@end
