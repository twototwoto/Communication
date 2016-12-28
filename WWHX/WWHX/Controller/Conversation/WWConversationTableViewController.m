//
//  WWConversationTableViewController.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/27.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "WWConversationTableViewController.h"

@interface WWConversationTableViewController ()

@property (nonatomic,strong) NSArray *conversationArr;


@end

@implementation WWConversationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readConversationsFromDB];
    //监听收到新消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readConversationsFromDB) name:@"WWHXDidReceiveMessageNote" object:nil];
    //监听发送消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readConversationsFromDB) name:@"WWHXDidSendMessageNote" object:nil];
    self.tableView.allowsSelection = NO;
   
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (void)readConversationsFromDB{
//    //获取所有会话
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    //获取所有会话
    NSArray <EMConversation *>*conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSArray <EMConversation *>*sortedResultArr = [conversations sortedArrayUsingComparator:^NSComparisonResult(EMConversation*  _Nonnull conversation1, EMConversation *  _Nonnull conversation2) {
    
            long long time1 = conversation1.latestMessage.localTime;
            long long time2 = conversation2.latestMessage.localTime;
            //如果返回NSOrderAscending，表示这两个元素的顺序正确(位置不换),如果返回NSOrderedAscending,会将这两个元素进行调换
            if (time1 > time2 ) {
                return NSOrderedAscending;
                
            }else{
                return NSOrderedDescending;
            }
            
        }];

    self.conversationArr = sortedResultArr;
    
    [self.tableView reloadData];

    

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.conversationArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationCell" forIndexPath:indexPath];
    //WWAnnotation:这里遇到一个问题就是，当时把tag值设置冲突了，所以呢导致了一个比较严重的问题是给图片设置文本的属性，最后发现了，设置了正确的tag值就好了。。。。。
    UIImageView *avatarImgV = [cell viewWithTag:1001];
    UILabel *conversationLabel = [cell viewWithTag:1002];
    UILabel *contentLabel = [cell viewWithTag:1003];
    
    EMConversation *conversation = self.conversationArr[indexPath.row];
    
    //注意这个地方的话是需要有一个处理就是需要进行一个判断的操作的
    conversationLabel.text = conversation.conversationId;
    
    EMTextMessageBody *textBody = conversation.latestMessage.body;
    contentLabel.text = textBody.text;
    if(contentLabel.text != nil)
    {
        return cell;

    }else{
        conversationLabel.text = nil;
        avatarImgV.image = nil;
        return cell;
    }
    
    
    }


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
