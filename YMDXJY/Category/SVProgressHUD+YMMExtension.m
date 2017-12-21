//
//  SVProgressHUD+YMMExtension.m
//  yunmaimai
//
//  Created by LiuQingying on 2017/10/31.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import "SVProgressHUD+YMMExtension.h"

@implementation SVProgressHUD (YMMExtension)
+ (void)showTips:(NSString*)message times:(CGFloat)second{
    [SVProgressHUD setImageViewSize:CGSizeZero];
    [SVProgressHUD showImage:[UIImage imageWithColor:[UIColor clearColor]] status:message];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
    [self performSelector:@selector(resumeImageSizeFrame) withObject:nil afterDelay:second];
}
+ (void)resumeImageSizeFrame{
    [SVProgressHUD setImageViewSize:CGSizeMake(25, 25)];
}
+ (void)showErrorTips:(NSString*)message times:(CGFloat)second{
    [SVProgressHUD showErrorWithStatus:message];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
}

+ (void)showSuccessTips:(NSString*)message times:(CGFloat)second{
    [SVProgressHUD showSuccessWithStatus:message];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:second];
}

@end
