//
//  WWUserInfoTableViewController.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/27.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "WWUserInfoTableViewController.h"
#import "WWChatViewController.h"

@interface WWUserInfoTableViewController ()<IEMChatManager>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation WWUserInfoTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.userNameLabel.text = self.userName;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //把联系人的环信账号发送给chatVC
    WWChatViewController *chatVC = segue.destinationViewController;
    chatVC.userName = self.userName;

}

@end
