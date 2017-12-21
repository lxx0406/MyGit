//
//  YMMTool.m
//  yunmaimai
//
//  Created by 祥翔李 on 2017/11/7.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import "YMMTool.h"
#import <CYLTabBarController.h>

@implementation YMMTool

+ (void)postImageWithData:(NSData *)fileData dir:(NSString *)dir progress:(requestProgressHandleBlock)progress success:(requestSuccessHandleBlock)sucess failure:(requestFailedHandleBlock)failure{
    //    formDate 设置数据name：@“改为传给后台的参数名”
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    NSString *urlString;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
//    dict[@"version"] = kAPPPortVersion;
//    dict[@"timestamp"] = [NSString stringWithTimestamp];
//    if (YMMLoginInfo) {
//        dict[@"token"] = YMMLoginInfo[@"token"];
//    }
//    dict[@"nonce"] = [NSString random8LengthString];
//    if(ISDEBUG){
//        dict[@"debug"] = @"1";
//    }
//    dict[@"dir"] = dir;
//    NSString *sign = [NSString stringWithDict:dict];
//    NSString *md5Sign = [NSString md5:sign];
//    dict[@"token"] = AFPercentEscapedStringFromString(YMMLoginInfo[@"token"]);
//    dict[@"sign"] = md5Sign;
    NSString *requestStr = [NSString stringRequestTypeWithDict:dict];
    urlString = [kRequestURL(@"/api/default/upload") stringByAppendingString:requestStr];
    
    NSURLSessionDataTask *task = [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageDatas = fileData;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageDatas
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        if (progress) {
            progress(uploadProgress);
        }
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //上传成功
        NSLog(@"上传成功");
        if ([responseObject[@"error_code"] integerValue] == 0) {
            if (sucess) {
                sucess(responseObject);
            }
        }else{
            [SVProgressHUD showErrorTips:responseObject[@"message"] times:1];
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败
        if (failure) {
            failure(error);
        }
        YMMShowServerError
        NSLog(@"上传失败");
    }];
    
    [task resume];
}

+ (void)postImageWithImageArray:(NSArray *)images dir:(NSString *)dir progress:(requestProgressHandleBlock)progress success:(requestSuccessHandleBlock)sucess failure:(requestFailedHandleBlock)failure{
    
    //    formDate 设置数据name：@“改为传给后台的参数名”
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    NSString *urlString;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
//    dict[@"version"] = kAPPPortVersion;
//    dict[@"timestamp"] = [NSString stringWithTimestamp];
//    if (YMMLoginInfo) {
//        dict[@"token"] = YMMLoginInfo[@"token"];
//    }
//    dict[@"nonce"] = [NSString random8LengthString];
//    if(ISDEBUG){
//        dict[@"debug"] = @"1";
//    }
//    dict[@"dir"] = dir;
//    NSString *sign = [NSString stringWithDict:dict];
//    NSString *md5Sign = [NSString md5:sign];
//    dict[@"token"] = AFPercentEscapedStringFromString(YMMLoginInfo[@"token"]);
//    dict[@"sign"] = md5Sign;
    NSString *requestStr = [NSString stringRequestTypeWithDict:dict];
    urlString = [kRequestURL(@"/api/default/upload-multi") stringByAppendingString:requestStr];
    
    NSURLSessionDataTask *task = [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传 多张图片
        for(NSInteger i = 0; i < images.count; i++) {
            NSData * imageData = UIImageJPEGRepresentation([images objectAtIndex: i], 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:imageData name:@"files[]" fileName:fileName   mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //上传成功
        NSString *str = YMMStrFormat(@"%@",responseObject[@"error_code"]);
        if ([str isEqualToString:@"0"]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *uri in responseObject[@"file_list"]) {
                [array addObject:uri[@"uri"]];
            }
            
            if (sucess) {
                sucess(@{@"responseObject":array});
            }
        }else{
            [SVProgressHUD showErrorTips:responseObject[@"message"] times:1];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败
        if (failure) {
            failure(error);
        }
        NSLog(@"上传失败");
    }];
    [task resume];
}

+ (void)postVideoWithData:(NSData *)data dir:(NSString *)dir progress:(requestProgressHandleBlock)progress success:(requestSuccessHandleBlock)sucess failure:(requestFailedHandleBlock)failure{
    
    //初始化请求管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置接受类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
//    dict[@"version"] = kAPPPortVersion;
//    dict[@"timestamp"] = [NSString stringWithTimestamp];
//    if (YMMLoginInfo) {
//        dict[@"token"] = YMMLoginInfo[@"token"];
//    }
//    dict[@"nonce"] = [NSString random8LengthString];
//    if(ISDEBUG){
//        dict[@"debug"] = @"1";
//    }
//    dict[@"dir"] = dir;
//    NSString *sign = [NSString stringWithDict:dict];
//    NSString *md5Sign = [NSString md5:sign];
//    dict[@"token"] = AFPercentEscapedStringFromString(YMMLoginInfo[@"token"]);
//    dict[@"sign"] = md5Sign;
    NSString *requestStr = [NSString stringRequestTypeWithDict:dict];
    urlString = [kRequestURL(@"测试") stringByAppendingString:requestStr];
    
    //发送POST请求
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
        
        
    }progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"上传进度: %f", downloadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功 %@",responseObject);
        //上传成功
        NSLog(@"上传成功");
        if ([responseObject[@"error_code"] integerValue] == 0) {
            if (sucess) {
                sucess(responseObject);
            }
        }else{
            [SVProgressHUD showErrorTips:responseObject[@"message"] times:1];
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败
        if (failure) {
            failure(error);
        }
        NSLog(@"上传失败");
     }];
}

+ (UIViewController *)getCurrentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }else if ([Rootvc isKindOfClass:[CYLTabBarController class]]){
            CYLTabBarController * tabVC = (CYLTabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = tabVC.selectedViewController;
            continue;
        }
    } while (Rootvc!=nil);
    return currVC;
}


@end
