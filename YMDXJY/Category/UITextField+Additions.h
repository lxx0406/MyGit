//
//  UITextField+PaddingLeft.h
//  CQArchitecture
//
//  Created by KevinCao on 2016/12/1.
//  Copyright © 2016年 caoqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Additions)

- (void)paddingLeft:(CGFloat)padding;

- (void)setLeftTitle:(NSString *)leftTitle font:(UIFont *)font textColor:(UIColor *)textColor;

- (void)addBottomLine;

@end
