//
//  UITextField+PaddingLeft.m
//  CQArchitecture
//
//  Created by KevinCao on 2016/12/1.
//  Copyright © 2016年 caoqun. All rights reserved.
//

#import "UITextField+Additions.h"

@implementation UITextField (Additions)

- (void)paddingLeft:(CGFloat)padding
{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, 1)];
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setLeftTitle:(NSString *)leftTitle font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = font?:[UIFont systemFontOfSize:14];
    titleLabel.textColor = textColor?:[UIColor blackColor];
    titleLabel.text = leftTitle;
    CGSize size = [leftTitle sizeWithAttributes:@{NSFontAttributeName: font?:[UIFont systemFontOfSize:14]}];
    titleLabel.frame = CGRectMake(0, 0, size.width, size.height);
    self.leftView = titleLabel;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addBottomLine
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YYLineColor;
    WS(weakSelf);
    [weakSelf addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
}

@end
