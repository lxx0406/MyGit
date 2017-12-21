//
//  UIImage+YYExtension.h
//  yunyue
//
//  Created by LiuQingying on 2016/12/14.
//  Copyright © 2016年 zhanlijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum
{
    NYXCropModeTopLeft,
    NYXCropModeTopCenter,
    NYXCropModeTopRight,
    NYXCropModeBottomLeft,
    NYXCropModeBottomCenter,
    NYXCropModeBottomRight,
    NYXCropModeLeftCenter,
    NYXCropModeRightCenter,
    NYXCropModeCenter
} NYXCropMode;

typedef enum
{
    NYXResizeModeScaleToFill,
    NYXResizeModeAspectFit,
    NYXResizeModeAspectFill
} NYXResizeMode;

@interface UIImage (YYExtension)
/**
 根据颜色生成一张尺寸为1*1的相同颜色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/**
 ALAsset  转为UIImage 并压缩
 */
+ (UIImage *)imageWithAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size;

/**
  亮模糊样式
 @return
 */
- (UIImage *)applyLightEffect;
/**
 高亮模糊样式
 @return
 */
- (UIImage *)applyExtraLightEffect;
/**
 暗模糊样式
 @return
 */
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

/**
 ALAset 获取image
 */
+(UIImage *)imageWithFullSizeImageForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation;

/**
 更改图片尺寸
 */
-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 转换为马赛克图片
 @param orginImage 原图
 */
- (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level;

-(UIImage*)cropToSize:(CGSize)newSize usingMode:(NYXCropMode)cropMode;


@end
