//
//  YYShopWebVC.m
//  yunyue
//
//  Created by admin on 2017/3/1.
//  Copyright © 2017年 zhanlijun. All rights reserved.
//

#import "YYShopWebVC.h"
#import <WebKit/WebKit.h>
//#import "ContactListSelectViewController.h"
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
//#import "YYAddMomentsViewController.h"
#import <SDWebImageDownloader.h>
//#import "YYHitMoneyVC.h"
@interface YYShopWebVC ()<WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate,WKScriptMessageHandler>
/**
 webview
*/
@property (nonatomic, strong) WKWebView *wKWebView;

/**
 进度条
 */
@property (nonatomic, strong) UIProgressView *progressView;
/**
 上次加载URL时间
 */
@property (nonatomic, strong) NSDate *lastLoadDate;
/**
 定时器隐藏progressView
 */
@property (nonatomic, strong) NSTimer *timer;
/** 是否包含中View中 */
@property (assign, nonatomic) BOOL isInView;
/** 返回按钮 */
@property (nonatomic, strong) UIBarButtonItem *backItem;
/** 关闭按钮 */
@property (nonatomic, strong) UIBarButtonItem *closeItem;
/** 网址 */
@property (nonatomic, strong) NSString *webUrl;
/** 标题 */
@property (nonatomic, strong) NSString *webTitle;
/** 图片链接 */
@property (nonatomic, strong) NSString *webImageUrl;
/** 网页内容 */
@property (nonatomic, strong) NSString *webContent;
/** 网页中的所有的图片链接 */
@property (nonatomic, strong) NSMutableArray *webImageUrlsArr;
/** 交互对象，使用它个页面注入JS代码给能够获取到的页面图片添加点击事件 */
@property (nonatomic, strong) WKUserScript *userScript;
/** 长按图片识别的二维码地址 */
@property (nonatomic, strong) NSString *QRCodeURLStr;
/**
 userContentController
 */
@property (nonatomic, strong) WKUserContentController *userContentController;

@end

@implementation YYShopWebVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.wKWebView];
    [self.view addSubview:self.progressView];
//    NSString *newURLStr = [_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//    NSURL *newURL = [NSURL URLWithString:newURLStr];
    [_wKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    if (@available(iOS 11.0, *)) {
        _wKWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setProgress) userInfo:nil repeats:YES];
    [self setNavigationBar];
//    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 40;
    
}
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    // Unsure why WKWebView calls this controller - instead of it's own parent controller
    if (self.presentedViewController) {
        [self.presentedViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_userContentController){
        [_userContentController removeScriptMessageHandlerForName:@"hitMoneyForNews"];
        [_userContentController addScriptMessageHandler:self name:@"hitMoneyForNews"];
    }
//    [MobClick beginLogPageView:visitYSJJShopPage];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [_userContentController removeScriptMessageHandlerForName:@"hitMoneyForNews"];

//    [MobClick endLogPageView:visitYSJJShopPage];
}
- (void)setProgress{
    if (_lastLoadDate) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastLoadDate];
        if (interval>1) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
                [self.progressView setProgress:1 animated:YES];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
            
        }
        
    }

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = self.wKWebView.title;
        _webTitle = self.wKWebView.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if (object == self.wKWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wKWebView.estimatedProgress;
        if ([keyPath isEqual: @"estimatedProgress"] && object == _wKWebView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:_wKWebView.estimatedProgress animated:YES];
            if(_wKWebView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    self.progressView.progress = 0;
                }];
            }
        }
    }else if (object == self.progressView && [keyPath isEqualToString:@"progress"]){
        
        if (_wKWebView.estimatedProgress >=1) {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress>=0.9) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                    [self.progressView setProgress:1 animated:YES];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
                
            }else if(newprogress > 0){
                [self.progressView setAlpha:1.0f];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.progressView setProgress:newprogress animated:YES];
                } completion:^(BOOL finished) {
                    
                }];
                
            }
        }
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSString *urlStr = [URL absoluteString];
    NSString *scheme = [URL scheme];
    
    // 打电话
    if ([scheme isEqualToString:@"tel"]) {
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:URL];
            }
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    // 打开appstore
//    if ([url.absoluteString containsString:@"ituns.apple.com"]) {
//        if ([app canOpenURL:url]) {
//            [app openURL:url];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//    }
    if([urlStr hasPrefix:@"javasctipt"]){
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    NSLog(@"---navigationAction : %@",navigationAction.sourceFrame);
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSURLResponse *response = navigationResponse.response;
    NSString *url = [[response URL] absoluteString];
    NSLog(@"------url : %@",url);
    if (_wKWebView.estimatedProgress ==1) {
        self.lastLoadDate = [NSDate date];
        [self.progressView setAlpha:1.0f];
        self.progressView.progress += 0.3;
    }
    [self updateNavigationItems];
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载成功
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self updateNavigationItems];
    _webUrl = webView.URL.absoluteString;
    if (![_url isEqualToString:_webUrl]) {
        _shareImageUrl = nil;
    }
    NSLog(@"---_webUrl : %@",_webUrl);
    NSString *jsToGetPSource = @"document.getElementsByTagName('p')[0].innerHTML";
    [webView evaluateJavaScript:jsToGetPSource completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
        NSLog(@"HTMLsource : %@",HTMLsource);
        _webContent = HTMLsource;
        
    }];
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
        NSLog(@"HTMLsource : %@",HTMLsource);
        _webImageUrlsArr = [NSMutableArray arrayWithArray:[self filterImage:HTMLsource]];
        if (_webImageUrlsArr.count<1) {
            [self getImageUrlByJS:webView];
        }
    }];
    [self.wKWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];


}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"error : %@",error);
}
- (void)pushViewController{
    
//    YYHitMoneyVC *hvc = [[YYHitMoneyVC alloc]init];
//    [self.navigationController pushViewController:hvc animated:YES];
    
}
#pragma mark -- WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    //message.boby就是JS里传过来的参数
    NSLog(@"body:%@",message.body);
    if ([message.name isEqualToString:@"hitMoneyForNews"]) {
//        YYHitMoneyVC *hvc = [[YYHitMoneyVC alloc] init];
//        [self.navigationController pushViewController:hvc animated:YES];
    }
}

- (NSArray *)filterImage:(NSString *)html
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                if ([src hasPrefix:@"http"]) {
                    [resultArray addObject:src];
                }
            }
        }
    }
    
    return resultArray;
}
/*
 *通过js获取htlm中图片url
 */
- (void)getImageUrlByJS:(WKWebView *)wkWebView
{
    
    NSString *js2=@"getImages()";
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSString *result=[NSString stringWithFormat:@"%@",Result];
        if([result hasPrefix:@"#"]){
            result=[result substringFromIndex:1];
        }
        _webImageUrlsArr = [NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"#"]];
        NSLog(@"array====%@",_webImageUrlsArr);
        
    }];

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [sender locationInView:self.wKWebView];
    // 获取长按位置对应的图片url的JS代码
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    // 执行对应的JS代码 获取url
    [self.wKWebView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error) {
        
        if (imgUrl){
            NSData *data = [self imageDataFromDiskCacheWithKey:imgUrl];
            if(data){
                [self checkImage:[UIImage imageWithData:data]];
            }else{
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    if (image) {
                        [self checkImage:image];
                        [[[SDWebImageManager sharedManager] imageCache] storeImage:image imageData:data forKey:imgUrl toDisk:YES completion:^{
                        }];
                    }
                }];
                
            }
            
        }
        
    }];
}
- (NSData *)imageDataFromDiskCacheWithKey:(NSString *)key {
    NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:key];
    return [NSData dataWithContentsOfFile:path];
}
/**
 * 识别图片中的二维码
 */
-(void)checkImage:(UIImage *)image
{
    CIDetector * detector = [CIDetector  detectorOfType : CIDetectorTypeQRCode  context :nil  options :@ {CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray  * features = [detector  featuresInImage :[CIImage  imageWithCGImage :image .CGImage ]];
    NSString  * scannedResult;
    for (int  index =  0 ; index <[features  count ]; index ++){
        CIQRCodeFeature  * feature = [features  objectAtIndex :index];
        scannedResult = feature .messageString;
    }
    
    UIAlertController* alertSheetController = [[UIAlertController alloc] init];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
        //        NSLog(@"取消");
    }];
    UIAlertAction* goURLAction = [UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        //        NSLog(@"识别二维码");
        if (_QRCodeURLStr) {
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_QRCodeURLStr]];
            [_wKWebView loadRequest:request];
        }
    }];
    UIAlertAction* saveImgAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        //        NSLog(@"保存图片");
        [self saveImageToPhotos:image];
    }];
    
    if (scannedResult) {
        //        NSString *contents = result.text;
        _QRCodeURLStr = scannedResult;
        
        [alertSheetController addAction:cancelAction];
        [alertSheetController addAction:goURLAction];
        [alertSheetController addAction:saveImgAction];
        
    } else {
        [alertSheetController addAction:cancelAction];
        [alertSheetController addAction:saveImgAction];
    }
    [self presentViewController:alertSheetController animated:YES completion:nil];
}
// 保存图片
- (void)saveImageToPhotos:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        NSLog(@"保存图片失败  %@",msg);
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    }else{
        NSLog(@"保存图片成功  %@",msg);
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
        
    }
}

- (void)shareWeb {
//    UIImage *yunyueLogoImage = [UIImage imageNamed:@"yunyue_logo"];
//    UIImage *logoImage = [UIImage imageNamed:@"me_community"];
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//
//    for (NSString *str in _webImageUrlsArr){
//        NSLog(@"   %@\n",str);
//    }
//    __block NSString *imageUrl = @"";
//    if (_shareImageUrl) {
//        imageUrl = _shareImageUrl;
//    }else{
//        if (_webImageUrlsArr.count) {
//            imageUrl = _webImageUrlsArr[0];
//        }
//    }
//
//    [shareParams SSDKSetupShareParamsByText:_webContent?_webContent:@"云约连接世界"
//                                     images:imageUrl.length ? @[imageUrl] :@[yunyueLogoImage]
//                                        url:[NSURL URLWithString:_webUrl]
//                                      title:_webTitle ? _webTitle:@"网页"
//                                       type:SSDKContentTypeAuto];
//    SSUIShareActionSheetItem *friendItem = [SSUIShareActionSheetItem itemWithIcon:[UIImage imageNamed:@"shareNewsYunyue_icon"] label:@"云约好友" onClick:^{
//        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
//        NSLog(@"标题：%@\n链接：%@\n图片地址：%@",_webTitle,_webUrl,_webImageUrl);
//        if (!_webTitle) {
//            _webTitle = @"网页";
//        }
//        NSString *content = [_webTitle stringByAppendingString:_webUrl];
//        if ([_webImageUrlsArr[0] hasPrefix:@"https"]) {
//            imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"https" withString:@"imgurl"];
//        }else{
//            imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"http" withString:@"imgurl"];
//        }
//        if(imageUrl){
//            listViewController.newsContent = [content stringByAppendingString:imageUrl];
//        }else{
//
//            listViewController.newsContent = content;
//        }
//
//        listViewController.type=@"YYNewsMessage";
//        [self.navigationController pushViewController:listViewController animated:YES];
//    }];
//    SSUIShareActionSheetItem *communityItem = [SSUIShareActionSheetItem itemWithIcon:logoImage label:@"云联社" onClick:^{
//        YYAddMomentsViewController *addMoments = [[YYAddMomentsViewController alloc] init];
//        addMoments.message_url = _webUrl;
//        addMoments.message_title = _webTitle;
//        addMoments.imageUrl = imageUrl;
//        [self.navigationController pushViewController:addMoments animated:YES];
//
//    }];
//    //2、分享（可以弹出我们的分享菜单和编辑界面）
//    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                             items:@[
//                                     friendItem,
//                                     communityItem,
//                                     @(SSDKPlatformSubTypeWechatSession),
//                                     @(SSDKPlatformSubTypeWechatTimeline),
//                                     @(SSDKPlatformTypeQQ)
//                                     ]
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                   switch (state) {
//                       case SSDKResponseStateSuccess:
//                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                           message:[NSString stringWithFormat:@"%@",error]
//                                                                          delegate:nil
//                                                                 cancelButtonTitle:@"OK"
//                                                                 otherButtonTitles:nil, nil];
//                           [alert show];
//                           break;
//                       }
//                       default:
//                           break;
//                   }
//               }
//     ];
//
}
- (void)dealloc{
//    [_wKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    self.wKWebView.UIDelegate = nil;
    [self.wKWebView stopLoading];
    [_wKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wKWebView removeObserver:self forKeyPath:@"title"];
    [_progressView removeObserver:self forKeyPath:@"progress"];
}
- (void)setNavigationBar
{
    self.navigationItem.leftBarButtonItem = self.backItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareWeb)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)updateNavigationItems{
    if ([self.wKWebView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
}
- (void)backNative
{
    if ([self.wKWebView canGoBack]) {
        [self.wKWebView goBack];
    } else {
        [self closeNative];
    }
}
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - init
- (WKWebView *)wKWebView{
    
    if (!_wKWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences.javaScriptEnabled = YES;
        if (@available(iOS 9.0, *)) {
            configuration.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        configuration.allowsInlineMediaPlayback = YES;
        configuration.selectionGranularity = YES;
        _userContentController = [[WKUserContentController alloc] init];
        [_userContentController addScriptMessageHandler:self name:@"hitMoneyForNews"];
        [_userContentController addUserScript:self.userScript];
        configuration.userContentController = _userContentController;
        _wKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight) configuration:configuration];
        _wKWebView.navigationDelegate = self;
        _wKWebView.UIDelegate = self;
        if (IS_IPHONE_X) {
            _wKWebView.yy_size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - kIPhoneXNavBarHeight);
        }
        _wKWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [_wKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_wKWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        _wKWebView.allowsBackForwardNavigationGestures = YES;
        [_wKWebView sizeToFit];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 0.6;
        longPress.delegate = self;
        [_wKWebView addGestureRecognizer:longPress];
    }
    return _wKWebView;
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
        
        _progressView.progressTintColor = [UIColor redColor];
        _progressView.trackTintColor = [UIColor clearColor];
        [_progressView addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _progressView;
}
- (WKUserScript *)userScript {
    if (!_userScript) {
        static  NSString * const jsGetImages =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgUrlStr='';\
        for(var i=0;i<objs.length;i++){\
        if(i==0){\
        if(objs[i]){\
        imgUrlStr=objs[i].src;\
        }\
        }else{\
        if(objs[i]){\
        imgUrlStr+='#'+objs[i].src;\
        }\
        }\
        };\
        return imgUrlStr;\
        };";
        _userScript = [[WKUserScript alloc] initWithSource:jsGetImages injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    }
    return _userScript;
}
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"ymm_back"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
    }
    return _closeItem;
}

@end
