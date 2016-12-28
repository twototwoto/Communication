//
//  WWAddContactViewController.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/26.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "WWAddContactViewController.h"

@interface WWAddContactViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addFriendsTextField;

@end

@implementation WWAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    
}

#pragma mark - 监听回车键的点击
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    //添加好友
//    EMError *error = [[EMClient sharedClient].contactManager addContact:@"6001" message:@"我想加您为好友"];
//    if (!error) {
//        NSLog(@"添加成功");
//    }
    
    [[EMClient sharedClient].contactManager addContact:self.addFriendsTextField.text
                                               message:@"我想加您为好友"
                                            completion:^(NSString *aUsername, EMError *aError) {
                                                
                                                if (!aError) {
                                                    NSLog(@"邀请发送成功");
                                                }
                                                
                                            }];
    return YES;
}
@end
