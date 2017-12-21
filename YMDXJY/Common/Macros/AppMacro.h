//
//  AppMacro.h
//  yunmaimai
//
//  Created by 祥翔李 on 2017/10/26.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
//----------------- app 配置----------------------------------------------------
#define HOST @"http://60.217.33.51:8086"

// 拼接上 host
#define kRequestURL(url) [NSString stringWithFormat:@"%@%@",HOST,url]
#define kRequestSucess [responseDict[@"error_code"] integerValue] == 0
//----------------------------------- 常用宏 ------------------------------------
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define YMMStrFormat(...) [NSString stringWithFormat:__VA_ARGS__]

#define WEAK  @weakify(self);
#define STRONG  @strongify(self);
// 颜色
#define YYNavBarColor Color(249, 59, 44)
#define YYBackGroundColor [UIColor colorWithHexString:@"#F9F9F9"]
#define YYLineColor [UIColor colorWithHexString:@"#ebebeb"]
#define YMMGreyColor(r) Color(r, r, r)
#define YMMStringColor(str) [UIColor colorWithHexString:str]
// 字体
#define PHFont(size) [UIFont systemFontOfSize:size]
// 登录后的保存信息
#define YMMLoginInfo [[NSUserDefaults standardUserDefaults] objectForKey:loginKey]
// 图片宏---正方形
#define YMMSquareDefaultImage [UIImage imageNamed:@"ymm_squareDefaultImage"]
// 图片宏---长方形
#define YMMRectangleDefaultImage [UIImage imageNamed:@"ymm_rectangleDefaultImage"]
#define YMMPeopleHeader [UIImage imageNamed:@"ymm_person_placeholderImage"]


// 异常提示
//#define kShowTips if([NSString ymm_stringWithErrorCode:[NSString stringWithFormat:@"%@",responseDict[@"error_code"]]]){YMMShowServerTips}else{YMMShowMessageError}
// 服务器提示信息
#define kShowTips \
    if([responseDict.allKeys containsObject:@"errors"]){\
        NSDictionary *errorDict = responseDict[@"errors"];\
        if (errorDict.allKeys.count>0) {\
            NSLog(@"%@",errorDict.allKeys[0]);\
            [SVProgressHUD showErrorTips:errorDict[errorDict.allKeys[0]][0] times:2];\
        }\
    }else{\
        YMMShowMessageError\
    }

#define YMMShowServerTips [SVProgressHUD showTips:[NSString ymm_stringWithErrorCode:[NSString stringWithFormat:@"%@",responseDict[@"error_code"]]] times:2];
// 异常提示
#define YMMShowMessageError [SVProgressHUD showErrorTips:responseDict[@"message"] times:2];
#define YMMShowServerError [SVProgressHUD showErrorTips:@"网络错误，请检查网络" times:2];
#define YMMShowTips(message,time) [SVProgressHUD showTips:message times:time];
// 登录
#define isLogin [[NSUserDefaults standardUserDefaults] objectForKey:loginKey]
// 弱引用
#define YMMWeakSelf __weak typeof(self) weakSelf = self;

/**
 打印
 */
#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

#define app_password @"apP_PASSWORD"
#define app_cid @"c1000_ID" // 所属教学点ID
#define app_id @"id" // 主键
#define app_name @"logiN_NAME"
#define app_user_type @"useR_TYPE"
#define app_login_name @"logiN_NAME"

//"apP_PASSWORD" = 202cb962ac59075b964b07152d234b70;
//"c1000_ID" = 10e8844255d349d494df0f7a181ab3a2;
//id = 2b0c1b6c00ad4194a712e5878e197bab;
//"logiN_NAME" = swdx;
//name = "\U5e02\U59d4\U515a\U6821";
//password = 9bd146e319219c5885f1eb7a37ccb3441b64d5d9135696c43b06250d;
//"useR_TYPE" = 8;


#endif /* AppMacro_h */
