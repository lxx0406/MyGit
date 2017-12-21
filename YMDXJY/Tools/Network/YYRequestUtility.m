//
//  YYRequestUtility.m
//  yunyue
//
//  Created by LiuQingying on 2016/12/17.
//  Copyright © 2016年 zhanlijun. All rights reserved.
//

#import "YYRequestUtility.h"
#import "YYHTTPSessionManager.h"
@implementation YYRequestUtility
- (void)start{
    
    if (self.sessionTask) {
        [self.sessionTask resume];
    }
}
- (void)stop{
    if (self.sessionTask) {
        [self.sessionTask cancel];
    }
}
+ (void)cancleAllRequest{
    YYHTTPSessionManager *manager = [YYHTTPSessionManager shareInstance];
    [manager.operationQueue cancelAllOperations];
}
+ (YYRequestUtility *)get:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                 progress:(requestProgressHandleBlock)progress
                  success:(requestSuccessHandleBlock)sucess
                  failure:(requestFailedHandleBlock)failure{
    
    YYRequestUtility *requestProxy = [[YYRequestUtility alloc] init];
    YYHTTPSessionManager *manager = [YYHTTPSessionManager shareInstance];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];

    requestProxy.sessionTask = [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (sucess) {
                sucess(responseObject);
            }
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            ;
            if (sucess) {
                sucess(dict);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
    }];
    
    return requestProxy;
}
+ (YYRequestUtility *)Get:(NSString *)urlString
            addParameters:(NSDictionary *)parameters
                 progress:(requestProgressHandleBlock)progress
                  success:(requestSuccessHandleBlock)sucess
                  failure:(requestFailedHandleBlock)failure{
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:20];
//    parametersDict[@"version"] = kAPPPortVersion;
//    parametersDict[@"timestamp"] = [NSString stringWithTimestamp];
//    if (YMMLoginInfo) {
//        NSLog(@"%@",YMMLoginInfo[@"token"]);
//        parametersDict[@"token"] = YMMLoginInfo[@"token"];
//    }
//    parametersDict[@"nonce"] = [NSString random8LengthString];
    if (parameters) {
        [parametersDict addEntriesFromDictionary:parameters];
    }
//    NSString *sign = [NSString stringWithDict:parametersDict];
//    NSString *md5Sign = [NSString md5:sign];
//    parametersDict[@"sign"] = md5Sign;
//    if(ISDEBUG){
//        parametersDict[@"debug"] = @"1";
//    }
    YYRequestUtility *requestProxy = [[YYRequestUtility alloc] init];
    YYHTTPSessionManager *manager = [YYHTTPSessionManager shareInstance];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
    
    requestProxy.sessionTask = [manager GET:urlString parameters:parametersDict progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (sucess) {
                sucess(responseObject);
//                NSLog(@"请求路径%@\n请求数据%@",urlString ,responseObject);
            }
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            ;
            if (sucess) {
                sucess(dict);
//                NSLog(@"请求路径%@\n请求数据%@",urlString ,dict);

            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
    }];
    
    return requestProxy;

}
+ (YYRequestUtility *)post:(NSString *)urlString
                parameters:(NSDictionary *)parameters
                  progress:(requestProgressHandleBlock)progress
                   success:(requestSuccessHandleBlock)sucess
                   failure:(requestFailedHandleBlock)failure{
    YYRequestUtility *requestProxy = [[YYRequestUtility alloc] init];
    YYHTTPSessionManager *manager = [YYHTTPSessionManager shareInstance];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
    requestProxy.sessionTask = [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (sucess) {
                sucess(responseObject);
            }
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            ;
            if (sucess) {
                sucess(dict);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
        
    }];
    return requestProxy;
}
+ (YYRequestUtility *)Post:(NSString *)urlString
             addParameters:(NSDictionary *)parameters
                  progress:(requestProgressHandleBlock)progress
                   success:(requestSuccessHandleBlock)sucess
                   failure:(requestFailedHandleBlock)failure{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
//    dict[@"version"] = kAPPPortVersion;
//    dict[@"timestamp"] = [NSString stringWithTimestamp];
//    if (YMMLoginInfo) {
//        dict[@"token"] = YMMLoginInfo[@"token"];
//    }
//    dict[@"nonce"] = [NSString random8LengthString];
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionaryWithCapacity:20];
    if (parameters) {
        [parametersDict addEntriesFromDictionary:parameters];
    }
//    NSString *sign = [NSString stringWithDict:dict];
//    NSString *md5Sign = [NSString md5:sign];
//    dict[@"sign"] = md5Sign;
//    dict[@"token"] = AFPercentEscapedStringFromString(YMMLoginInfo[@"token"]);
//    if(ISDEBUG){
//        dict[@"debug"] = @"1";
//    }
    NSString *requestStr = [NSString stringRequestTypeWithDict:dict];
    urlString = [urlString stringByAppendingString:requestStr];
    YYRequestUtility *requestProxy = [[YYRequestUtility alloc] init];
    YYHTTPSessionManager *manager = [YYHTTPSessionManager shareInstance];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
    requestProxy.sessionTask = [manager POST:urlString parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (sucess) {
                sucess(responseObject);
//                NSLog(@"请求路径%@\n请求数据%@",urlString ,responseObject);

            }
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            ;
            if (sucess) {
                sucess(dict);
//                NSLog(@"请求路径%@\n请求数据%@",urlString ,dict);

            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
        
    }];
    return requestProxy;

}
+ (YYRequestUtility *)post:(NSString *)urlString
                parameters:(NSDictionary *)parameters
                imageArray:(NSArray *)imageArray
                  progress:(requestProgressHandleBlock)progress
                   success:(requestSuccessHandleBlock)sucess
                   failure:(requestFailedHandleBlock)failure{

    YYRequestUtility *requestProxy = [[YYRequestUtility alloc] init];
    YYHTTPSessionManager *manager = [YYHTTPSessionManager shareInstance];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestProxy.sessionTask = [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        for (UIImage *image in imageArray) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.6f);
            if(imageData!=nil){
                NSString *name = [NSString stringWithFormat:@"photo%d",i];
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"multipart/form-data"];
                
            }
            i++;
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (sucess) {
                sucess(responseObject);
            }
        }else{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            ;
            if (sucess) {
                sucess(dict);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
    }];
    return requestProxy;
}



@end
