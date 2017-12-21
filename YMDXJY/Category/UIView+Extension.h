//
//  UIView+Extension.h
//  actoys
//
//  Created by LiuQingying on 16/3/28.
//  Copyright © 2016年 Actoys.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat yy_x;
@property (nonatomic, assign) CGFloat yy_y;
@property (nonatomic, assign) CGFloat yy_width;
@property (nonatomic, assign) CGFloat yy_height;
/**
 控件中心点X值
 */
@property (nonatomic, assign) CGFloat yy_centerX;
/**
 控件中心点Y值
 */
@property (nonatomic, assign) CGFloat yy_centerY;
/**
 控件最左边那根线的位置(minX的位置)
 */
@property (nonatomic, assign) CGFloat yy_left;
/**
 控件最右边那根线的位置(maxX的位置) 
 */
@property (nonatomic, assign) CGFloat yy_right;
/**
 控件最顶部那根线的位置(minY的位置)
 */
@property (nonatomic, assign) CGFloat yy_top;
/**
 控件最底部那根线的位置(maxY的位置)
 */
@property (nonatomic, assign) CGFloat yy_bottom;
/**
 控件的size
 */
@property (nonatomic, assign) CGSize  yy_size;

/**
 *  将View及subviews scrollsToTop设为NO
 */
- (void)yy_disableScrollsToTopPropertyOnMeAndAllSubviews;

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)yy_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)yy_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

@end


/******************************   添加点击手势   ***************************************/

#if NS_BLOCKS_AVAILABLE
typedef void (^XDJ_WhenTappedBlock)(void);
@interface UIView (XDJ_WhenTappedBlocks) <UIGestureRecognizerDelegate>

- (void)whenTapped:(XDJ_WhenTappedBlock)block;
- (void)whenDoubleTapped:(XDJ_WhenTappedBlock)block;
- (void)whenTwoFingerTapped:(XDJ_WhenTappedBlock)block;
- (void)whenTouchedDown:(XDJ_WhenTappedBlock)block;
- (void)whenTouchedUp:(XDJ_WhenTappedBlock)block;

@end
#endif
/******************************   添加点击手势   ***************************************/
