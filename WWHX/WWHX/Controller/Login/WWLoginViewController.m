//
//  WWLoginViewController.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/25.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "WWLoginViewController.h"

@interface WWLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation WWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)registerBtnClick:(id)sender {
    
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:self.userNameTextField.text password:self.passwordTextField.text];
    if (error==nil) {
        NSLog(@"注册成功");
    }
    
}

- (IBAction)loginBtnClick:(id)sender {
    
    EMError *error = [[EMClient sharedClient] loginWithUsername:self.userNameTextField.text password:self.passwordTextField.text];
    if (!error) {
        NSLog(@"登录成功");
         [[EMClient sharedClient].options setIsAutoLogin:YES];
        
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarController = [mainSB instantiateViewControllerWithIdentifier:@"WWTabBar"];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    }
    

}






@end
