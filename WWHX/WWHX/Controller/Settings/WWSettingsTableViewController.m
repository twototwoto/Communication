//
//  WWSettingsTableViewController.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/25.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "WWSettingsTableViewController.h"
#import "WWLoginViewController.h"

@interface WWSettingsTableViewController ()

@end

@implementation WWSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 && indexPath.row == 0) {
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            NSLog(@"退出成功");
            //回到登录界面
            UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WWLoginViewController *loginVc = [mainSB instantiateViewControllerWithIdentifier:@"WWLogin"];
            [UIApplication sharedApplication].keyWindow.rootViewController = loginVc;
            
        }
    }
    
}


@end
