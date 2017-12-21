//
//  NSString+YYExtension.h
//  yunyue
//
//  Created by LiuQingying on 2017/9/27.
//  Copyright © 2017年 yunshangzhijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YYExtension)


/** 手机号码验证 */
- (BOOL)isValidPhoneNum;

- (NSString *)numberSuitScanf:(NSString*)number;

/** 昵称验证 */
- (BOOL)isNickName;

/**
 document 文件路径

 @param fileName 文件名
 @return 文件完整路径
 */
+(NSString *)stringForDocumentFileWithString:(NSString *)fileName;


/**
 获取documentsPath路径

 @return 路径
 */
+ (NSString *)documentsPath;

/**
 获取手机型号
 */
+ (NSString *)stringForIphoneType;

/**
 获取app当前版本号

 @return 获取app当前版本号
 */
+ (NSString *)stringForAppVersion;

/**
 根据字典key进行排序将value生成字符串
 */
+(NSString*)stringWithDict:(NSDictionary*)dict;
/**
 根据字典key进行排序将value生成请求地址样式字符串
 */
+(NSString*)stringRequestTypeWithDict:(NSDictionary*)dict;
/**
 md5加盐加密方法
 */
+ (NSString *)md5EncryptWithString:(NSString *)string;

/**
 md5加密字符串

 */
+ (NSString *)md5Encryption:(NSString *)string;

/**
 生成随机8位字符串
 */
+ (NSString *)random8LengthString;

/**
 获取时间戳
 */
+ (NSString *)stringWithTimestamp;

/**
 根据字符串获取宽度

 @param text 字符串
 @return 返回的size
 */
+ (CGSize)getSizeWithString:(NSString *)text maxSize:(CGSize)maxSize font:(NSInteger)font;

/**
 根据时间戳获取时间
 
 @param creat_time 时间戳
 @return 返回的时间
 */
+ (NSString *)stringWithCreat_time:(NSString *)creat_time;

/**
 根据时间转成时间戳
 */
+ (NSString *)stringWithTimeStr:(NSString *)timeStr;

/**
 字符串转成字典
 
 @return 字符串转成字典
 */
+ (NSDictionary *)ymm_dictWithString:(NSString *)jsonStr;
/**
 字典转成字符串
 
 @return 字典转成字符串
 */
+ (NSString *)ymm_stringWithDict:(NSDictionary *)dic;
/**
 data编码，返回字符串
 
 @return 字典转成字符串
 */
+ (NSString *)ymm_stringWithData:(NSData *)data;

/**
 根据服务器返回错误码或获取对应提示信息
 */
+ (NSString *)ymm_stringWithErrorCode:(NSString *)errorCode;



///**
// AES加密字符串
// */
//+ (NSString *)ymm_stringWithAES256String:(NSString *)string;
@end
