//
//  PHLogInViewController.m
//  VI
//
//  Created by 祥翔李 on 2017/7/5.
//  Copyright © 2017年 祥翔李. All rights reserved.
//

#import "PHLogInViewController.h"
#import "PHHomeViewController.h"

#define KMARGIN_SPACE 10

@interface PHLogInViewController ()

/**
 用户名
 */
@property (nonatomic, strong) UITextField *userTextField;

/**
 密码
 */
@property (nonatomic, strong) UITextField *passwordTextField;

/**
 登录按钮
 */
@property (nonatomic, strong) UIButton *logInBtn;

@end

@implementation PHLogInViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self loadSubViews];
}

- (void)loadSubViews{
    
    self.view.backgroundColor = YYBackGroundColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    WS(weakSelf);
    //输入框背景
    UIView *textFieldBgView = [[UIView alloc] init];
    textFieldBgView.clipsToBounds = YES;
    textFieldBgView.layer.cornerRadius = 3;
    textFieldBgView.layer.borderColor = YYLineColor.CGColor;
    textFieldBgView.layer.borderWidth = 1;
    [self.view addSubview:textFieldBgView];
    [textFieldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.centerY.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(88);
    }];
    
    //手机号
    [textFieldBgView addSubview:self.userTextField];
    //密码
    [textFieldBgView addSubview:self.passwordTextField];
    // 登录按钮
    [self.view addSubview:self.logInBtn];
    
    [self.userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.equalTo(textFieldBgView).offset(-KMARGIN_SPACE);
        make.top.equalTo(textFieldBgView);
        make.height.equalTo(textFieldBgView).dividedBy(2);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.equalTo(textFieldBgView).offset(-KMARGIN_SPACE);
        make.bottom.equalTo(textFieldBgView);
        make.height.equalTo(textFieldBgView).dividedBy(2);
    }];
    
    [self.logInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(20);
        make.right.equalTo(weakSelf.view).offset(-20);
        make.centerX.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(textFieldBgView.mas_bottom).offset(20);
    }];
    
    
}

#pragma mark =========================== Method ===========================

/**
 取消键盘的第一响应者
 */
- (void)cancelKeyboard{
    
    [self.view endEditing:YES];
}

/**
 登录按钮的点击
 */
- (void)logInClicked{
    
    if (!_userTextField.text.length) {
        [SVProgressHUD showErrorTips:@"请输入用户名" times:1];
        return;
    }
    if (!_passwordTextField.text.length) {
        [SVProgressHUD showErrorTips:@"请输入密码" times:1];
        return;
    }
    
//    username=admin&password=c3d4fc2291f3f2b8979266c8185635b088bc71be2cf614bc77e886ed
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.userTextField.text forKey:@"username"];
    [parameters setObject:[[NSString md5Encryption:self.passwordTextField.text] lowercaseString] forKey:@"password"];
    NSLog(@"parameters : %@", parameters);
    [YYRequestUtility get:kRequestURL(@"/api/users") parameters:parameters progress:nil success:^(NSDictionary *responseDict) {

        NSLog(@"responseDict : %@", responseDict);
        if ([responseDict[app_id] length]) {
            NSMutableDictionary *logInDict = [NSMutableDictionary dictionary];
            [logInDict setObject:responseDict[app_user_type] forKey:app_user_type];
            [logInDict setObject:responseDict[app_cid] forKey:app_cid];
            [logInDict setObject:responseDict[app_login_name] forKey:app_login_name];
        }else{
            [SVProgressHUD showErrorTips:@"" times:1];
        }
       
        
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error.localizedDescription);
    }];
}

#pragma mark =========================== 懒加载 ===========================
- (UITextField *)userTextField{
    
    if (!_userTextField) {
        _userTextField = [[UITextField alloc] init];
        _userTextField.font = [UIFont systemFontOfSize:14];
        _userTextField.placeholder = @"请输入用户名";
        _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_userTextField setLeftTitle:@"用户名：" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor]];
    }
    return _userTextField;
}

- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_passwordTextField setLeftTitle:@"密   码：" font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor]];
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIButton *)logInBtn{
    
    if (!_logInBtn) {
        _logInBtn = [[UIButton alloc] init];
        _logInBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _logInBtn.clipsToBounds = YES;
        _logInBtn.layer.cornerRadius = 3;
        _logInBtn.layer.borderColor = YYLineColor.CGColor;
        _logInBtn.layer.borderWidth = 1;
        [_logInBtn setBackgroundColor:YYNavBarColor];
        [_logInBtn setTitle:@"登   录" forState:UIControlStateNormal];
        [_logInBtn addTarget:self action:@selector(logInClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logInBtn;
}

@end
