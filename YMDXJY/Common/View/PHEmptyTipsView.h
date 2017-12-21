//
//  PHEmptyTipsView.h
//  yunmaimai
//
//  Created by LiuQingying on 2017/12/1.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,PHEmptyTipsViewStyle ) {
    PHEmptyTipsViewStyleNoData,  // 无数据
    PHEmptyTipsViewStyleNoOrder // 无订单
};

@interface PHEmptyTipsView : UIView
/**
 提示类型
 */
@property (nonatomic, assign) PHEmptyTipsViewStyle style;
@end
