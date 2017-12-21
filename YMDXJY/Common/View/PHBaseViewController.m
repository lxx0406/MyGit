//
//  PHBaseViewController.m
//  yunmaimai
//
//  Created by LiuQingying on 2017/10/31.
//  Copyright © 2017年 YUNSHANGZHIJIA. All rights reserved.
//

#import "PHBaseViewController.h"

@interface PHBaseViewController ()

@end

@implementation PHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
@end
