//
//  JMShowBigPictureCell.m
//  点击cell查看大图
//
//  Created by LiuQingying on 2017/8/1.
//  Copyright © 2017年 LiuQingying. All rights reserved.
//

#import "JMShowBigPictureCell.h"
#import "UIView+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImageDownloader.h>
#import "JMAlertController.h"
#import <FLAnimatedImageView.h>
#import <Photos/Photos.h>
#import <Foundation/Foundation.h>
#import <NSData+ImageContentType.h>
#define kanimateDurationInSeconds 0.25
@interface JMShowBigPictureCell()<CAAnimationDelegate>

@end

@implementation JMShowBigPictureCell
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        JMBigPictureView * bigPictureView = [[JMBigPictureView alloc] initWithFrame:self.bounds];
        
        [self addSubview:bigPictureView];
        _bigPictureView = bigPictureView;
        __weak typeof(self) weakSelf = self;
        [_bigPictureView setSingleTapGestureBlock:^(CGRect rect){
            if (weakSelf.singleTapGestureBlock) {
                weakSelf.singleTapGestureBlock(rect);
            }
        }];

    }
    return self;
}
- (void)recoverSubviews:(BOOL)animate{
    [self.bigPictureView recoverSubviews:animate];
}
@end

@interface JMBigPictureView()

@property (nonatomic, copy) NSString* currenPictureUrl;

@end

@implementation JMBigPictureView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[FLAnimatedImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
        [self configProgressView];
    }
    return self;
}
- (void)configProgressView {
    self.indicateImageView = [[UIImageView alloc] init];
    _indicateImageView.image = [UIImage imageNamed:@"loadBigPictureIndicate"];
    _indicateImageView.hidden = YES;
    static CGFloat progressWH = 30;
    CGFloat progressX = (self.yy_width - progressWH) / 2;
    CGFloat progressY = (self.yy_height - progressWH) / 2;
    _indicateImageView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    [self addSubview:_indicateImageView];
    
}
- (void)startAnimate{
    _indicateImageView.hidden = NO;
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 1;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.indicateImageView.layer addAnimation:animation forKey:nil];

}
- (void)stopAnimate{
    self.indicateImageView.hidden = YES;
    [self.indicateImageView.layer removeAllAnimations];
}
- (void)resizeSubviewsAnimate:(BOOL)animate {
    
    _imageContainerView.frame = self.currentRect;
    _imageView.frame = _imageContainerView.bounds;
    UIImage *image = _imageView.image;
//    NSLog(@"----imageSize----%@",NSStringFromCGSize(image.size));
    if (image.size.height / image.size.width > self.yy_height / self.scrollView.yy_width) {

        if(animate){
        
            [UIView animateWithDuration:kanimateDurationInSeconds animations:^{
                
                _imageContainerView.yy_height = floor(image.size.height / (image.size.width / self.scrollView.yy_width));
                NSLog(@"yy_height--%f",_imageContainerView.yy_height);
                _imageContainerView.yy_x = 0;
                _imageContainerView.yy_width = self.scrollView.yy_width;
                _imageContainerView.yy_centerY = MAX(_imageContainerView.yy_height, self.yy_height) *0.5;
            } completion:nil];
        }else{
            _imageContainerView.yy_height = floor(image.size.height / (image.size.width / self.scrollView.yy_width));
            _imageContainerView.yy_x = 0;
            _imageContainerView.yy_width = self.scrollView.yy_width;
            _imageContainerView.yy_centerY = MAX(_imageContainerView.yy_height, self.yy_height) *0.5;
        }
        
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.yy_width;
        if (height < 1 || isnan(height)) height = self.yy_height;
        height = floor(height);
        if (animate) {
            [UIView animateWithDuration:kanimateDurationInSeconds animations:^{
                _imageContainerView.yy_height = height;
                _imageContainerView.yy_x = 0;
                _imageContainerView.yy_width = self.scrollView.yy_width;
                _imageContainerView.yy_centerY = MAX(_imageContainerView.yy_height, self.yy_height) *0.5;;
            } completion:nil];
    
        }else{
            _imageContainerView.yy_height = height;
            _imageContainerView.yy_x = 0;
            _imageContainerView.yy_width = self.scrollView.yy_width;
            _imageContainerView.yy_centerY = MAX(_imageContainerView.yy_height, self.yy_height) *0.5;
        }
    
    }
    if (_imageContainerView.yy_height > self.yy_height && _imageContainerView.yy_height - self.yy_height <= 1) {
        if (animate) {
            [UIView animateWithDuration:kanimateDurationInSeconds animations:^{
                _imageContainerView.yy_height = self.yy_height;
            } completion:nil];
        
        }else{
            _imageContainerView.yy_height = self.yy_height;
        }
        
        
    }
    CGFloat contentSizeH = MAX(_imageContainerView.yy_height, self.yy_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.yy_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.yy_height <= self.yy_height ? NO : YES;
    if (animate) {
        [UIView animateWithDuration:kanimateDurationInSeconds animations:^{
            _imageView.frame = _imageContainerView.bounds;
        } completion:nil];
    }else{
        _imageView.frame = _imageContainerView.bounds;
    
    }
    
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
        
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    
    if (self.singleTapGestureBlock) {
        if (_scrollView.zoomScale > 1.0) {
            _scrollView.contentInset = UIEdgeInsetsZero;
            [_scrollView setZoomScale:1.0 animated:YES];
            [self performSelector:@selector(singleTap:) withObject:nil afterDelay:0.38];
        }else{
            self.singleTapGestureBlock(self.currentRect);
        }
        
    }
}
- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    if (self.is_pay) {
        
        return;
    }
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        JMAlertController *alertController = [JMAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([_currenPictureUrl hasPrefix:@".png"] || [_currenPictureUrl hasPrefix:@".jpg"] || [_currenPictureUrl hasPrefix:@".gif"]) {
                NSURL *fileURL = [NSURL fileURLWithPath:[[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:_currenPictureUrl]];
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    PHAssetChangeRequest *newAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileURL];
                    newAssetRequest.creationDate = [NSDate date];
                    
                } completionHandler:^(BOOL success, NSError *error) {
                    if(success){
                        [SVProgressHUD showSuccessWithStatus:@"已保存到手机相册"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"保存失败"];
                    }
                }];

            }else{
                ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
                NSData *imageData = [self imageDataFromDiskCacheWithKey:_currenPictureUrl];
                [lib writeImageDataToSavedPhotosAlbum:imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                    if(!error){
                        [SVProgressHUD showSuccessWithStatus:@"已保存到手机相册"];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"保存失败"];
                    }
                }];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:determineAction];
        [alertController addAction:cancelAction];
        [alertController showAnimated:YES];

    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self refreshImageContainerViewCenter];
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.frame.size.width > _scrollView.contentSize.width) ? ((_scrollView.frame.size.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.frame.size.height > _scrollView.contentSize.height) ? ((_scrollView.frame.size.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)recoverSubviews:(BOOL)animate{
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviewsAnimate:animate];
}
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder{
    
//    NSString *newURLStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//    NSURL *newURL = [NSURL URLWithString:newURLStr];
    self.currenPictureUrl = url;
//    NSLog(@"----+++%@",[NSThread currentThread]);
    
    NSData *data = [self imageDataFromDiskCacheWithKey:url];
    
    if(data) {
        SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
        if (imageFormat == SDImageFormatGIF) {
            _imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
        }else{
            _imageView.image = [UIImage imageWithData:data];
            
        }
        
    } else {
        _imageView.image = placeholder;
        _indicateImageView.hidden = NO;
        [self startAnimate];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
    
            [self stopAnimate];
            if (image) {
                
                SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
                if (imageFormat == SDImageFormatGIF) {
                    _imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                }else{
                    _imageView.image = image;
                }
                
                [[[SDWebImageManager sharedManager] imageCache] storeImage:image imageData:data forKey:url toDisk:YES completion:^{
                }];
                _indicateImageView.hidden = YES;
                [self resizeSubviewsAnimate:NO];
            }
        }];
    }
}
- (NSData *)imageDataFromDiskCacheWithKey:(NSString *)key {
    NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:key];
    return [NSData dataWithContentsOfFile:path];
}
- (void)setImageWithName:(NSString *)name{
    self.imageView.image = [UIImage imageNamed:name];
}
-(void)dealloc{
    
}
@end
