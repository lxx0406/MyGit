//
//  YMMTool.h
//  yunmaimai
//
//  Created by 祥翔李 on 2017/11/7.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^postFileSuccessHandleBlock)(NSDictionary *responseDict);
typedef void (^postFileProgressHandleBlock)(NSProgress *progress);
typedef void (^postFileFailedHandleBlock)(NSError *error);

@interface YMMTool : NSObject
/**
 上传图片文件
 @param fileData 上传的文件的data
 */
+ (void)postImageWithData:(NSData *)fileData
                      dir:(NSString *)dir
                progress:(requestProgressHandleBlock)progress
                 success:(requestSuccessHandleBlock)sucess
                 failure:(requestFailedHandleBlock)failure;

/**
 上传多个图片

 @param images image数组
 @param dir 字段
 @param progress 进度条
 @param sucess 成功
 @param failure 失败
 */
+ (void)postImageWithImageArray:(NSArray *)images
                            dir:(NSString *)dir
                       progress:(requestProgressHandleBlock)progress
                        success:(requestSuccessHandleBlock)sucess
                        failure:(requestFailedHandleBlock)failure;


/**
 上传视频

 @param data 视频的数据流
 @param dir 字段
 @param progress 进度条
 @param sucess 成功
 @param failure 失败
 */
+ (void)postVideoWithData:(NSData *)data
                            dir:(NSString *)dir
                       progress:(requestProgressHandleBlock)progress
                        success:(requestSuccessHandleBlock)sucess
                        failure:(requestFailedHandleBlock)failure;


/**
 获取当前控制器

 @return  获取当前控制器
 */
+ (UIViewController *)getCurrentViewController;


@end
