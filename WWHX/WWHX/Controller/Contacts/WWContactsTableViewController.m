//
//  WWContactsTableViewController.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/26.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "WWContactsTableViewController.h"
#import "WWUserInfoTableViewController.h"

@interface WWContactsTableViewController ()

@end

static NSString *cellId = @"contactCell";
@implementation WWContactsTableViewController{
    NSArray <NSString *>*_contactsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self getUserFromServer];
    
}

#pragma mark - 获取联系人的数据
- (void)getUserFromServer{
    
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        ///        NSLog(@"获取成功 -- %@",buddyList);
        
        //赋值给数据源
        _contactsArr = userlist;
        //刷新数据
        [self.tableView reloadData];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"contactsDetail"]) {
        
        WWUserInfoTableViewController *userTVC = segue.destinationViewController;
//        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        //将选中的联系人传递给User控制器
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        userTVC.userName = _contactsArr[indexPath.row];
        
        
//        userTVC.userName = self.tableView.indexPathForSelectedRow;
        
        
        
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contactsArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = _contactsArr[indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // 删除好友
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:_contactsArr[indexPath.row]];
        
        if (!error) {
            NSLog(@"删除成功");
            //删除好友之后需要刷新列表
            [self getUserFromServer];
        }
    }
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
