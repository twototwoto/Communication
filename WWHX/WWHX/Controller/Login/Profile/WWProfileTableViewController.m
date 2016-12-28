//
//  WWProfileTableViewController.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/25.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "WWProfileTableViewController.h"

@interface WWProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation WWProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameLabel.text = [EMClient sharedClient].currentUsername;
}
@end
