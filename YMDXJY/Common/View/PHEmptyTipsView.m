//
//  PHEmptyTipsView.m
//  yunmaimai
//
//  Created by LiuQingying on 2017/12/1.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import "PHEmptyTipsView.h"

@interface PHEmptyTipsView()
@property (weak, nonatomic) UIImageView *tipsImageView;
@property (weak, nonatomic) UILabel *tipsLabel;
@end

@implementation PHEmptyTipsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        self.backgroundColor = Color(241, 242, 244);
    }
    return self;
}
- (void)setupSubViews{
    UIImageView *tipsImageVeiw = [[UIImageView alloc] init];
    tipsImageVeiw.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:tipsImageVeiw];
    self.tipsImageView = tipsImageVeiw;
    [tipsImageVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(126);
        make.height.mas_equalTo(140);
        make.top.mas_equalTo(120);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = Color(120, 120, 120);
    tipsLabel.font = PHFont(15);
    self.tipsLabel = tipsLabel;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(tipsImageVeiw.mas_bottom).offset(20);
    }];
    _tipsImageView.image = [UIImage imageNamed:@"PH_empty_data"];
    _tipsLabel.text = @"暂时没有内容呦~";
}
- (void)setStyle:(PHEmptyTipsViewStyle)style{
    _style = style;
    switch (_style) {
        case PHEmptyTipsViewStyleNoData:{
            _tipsImageView.image = [UIImage imageNamed:@"PH_empty_data"];
            _tipsLabel.text = @"暂时没有内容呦~";
            break;
        }case PHEmptyTipsViewStyleNoOrder:{
            _tipsImageView.image = [UIImage imageNamed:@"PH_empty_order"];
            _tipsLabel.text = @"还没有相关的订单呐~";
            [_tipsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(110);
            }];
            break;
        }
            
        default:
            break;
    }
}
@end
