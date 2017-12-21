//
//  PHBaseTableView.m
//  yunmaimai
//
//  Created by LiuQingying on 2017/10/27.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import "PHBaseTableView.h"

@implementation PHBaseTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if ([super initWithFrame:frame style:style]) {
        self.backgroundColor = YYBackGroundColor;
        [self setTableViewFrame:NO];
    }
    if (@available(iOS 11.0, *)) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    return self;
}
- (void)setShowTabBar:(BOOL)showTabBar{
    if(showTabBar){
        [self setTableViewFrame:showTabBar];

    }
}
- (void)setTableViewFrame:(BOOL)showTabbar{
    
    self.yy_width = SCREEN_WIDTH;
    
    if (IS_IPHONE_X) {
        
        if(showTabbar){
            self.yy_height = SCREEN_HEIGHT - kIPhoneXNavBarHeight-kIPhoneXTabBarHeight;
            
        }else{
            self.yy_height = SCREEN_HEIGHT - kIPhoneXNavBarHeight;
        }
    }else{
        if(showTabbar){
            self.yy_height = SCREEN_HEIGHT - kNavBarHeight-kTabBarHeight;
        }else{
            self.yy_height = SCREEN_HEIGHT - kNavBarHeight;
            
        }
    }
}
@end
