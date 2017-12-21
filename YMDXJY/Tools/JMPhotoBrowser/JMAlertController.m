//
//  JMAlertController.m
//  点击cell查看大图
//
//  Created by LiuQingying on 2017/8/3.
//  Copyright © 2017年 LiuQingying. All rights reserved.
//

#import "JMAlertController.h"

@interface JMAlertController ()

@end

@implementation JMAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showAnimated:(BOOL)animated {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setBackgroundColor:[UIColor clearColor]];
    UIViewController*rootViewController = [[UIViewController alloc] init];
    [[rootViewController view] setBackgroundColor:[UIColor clearColor]];
    // set window level
    [window setWindowLevel:UIWindowLevelAlert + 1];
    [window makeKeyAndVisible];
//    [self setAlertWindow:window];
    [window setRootViewController:rootViewController];
    
    [rootViewController presentViewController:self animated:animated completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
