//
//  WWChatViewController.m
//  WWHX
//
//  Created by 王永旺永旺 on 2016/12/27.
//  Copyright © 2016年 ITCoderW. All rights reserved.
//

#import "WWChatViewController.h"

@interface WWChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,EMChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray <EMMessage *>*messagesArr;

@end

@implementation WWChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置自定义行高
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readFromDB) name:@"WWHXDidReceiveMessageNote" object:nil];
    //进入聊天界面刷新数据
    [self readFromDB];
    
    
}



#pragma mark - 从本地数据库中读取数据
- (void)readFromDB{
    //获取会话
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.userName type:EMConversationTypeChat createIfNotExist:YES];
    
//    /*!
//     *  从数据库获取指定类型的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果 aLimit 是负数，则获取所有符合条件的消息
//     *
//     *  @param aType        消息类型
//     *  @param aTimestamp   参考时间戳
//     *  @param aLimit       获取的条数
//     *  @param aSender      消息发送方，如果为空则忽略
//     *  @param aDirection   消息搜索方向
//     *
//     *  @result 消息列表<EMMessage>
//     */
//    - (NSArray *)loadMoreMessagesWithType:(EMMessageBodyType)aType
//    before:(long long)aTimestamp
//    limit:(int)aLimit
//    from:(NSString*)aSender
//    direction:(EMMessageSearchDirection)aDirection;
    
    //WWAnnotation:使用的这个方法是自行敲出来的，文档里边没有给出来

//    [conversation loadMessagesStartFromId:nil count:20 searchDirection:EMMessageSearchDirectionDown completion:nil];
    [conversation loadMessagesStartFromId:nil count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        self.messagesArr = aMessages;
        [self.tableView reloadData];
        
        
        
    }];
    
    
}


- (void)sendMessage{
    
    //构造消息
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:self.messageTextField.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:nil from:from to:self.userName body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    
    
    //发送消息
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            NSLog(@"消息发送成功");
            //消息发送成功，刷新数据
            [self readFromDB];
            //监听发送消息
            //            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readConversationsFromDB) name:@"WWHXDidSendMessageNote" object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readFromDB) name:@"WWHXDidSendMessageNote" object:nil];
        }
    }];
    //清空消息
    self.messageTextField.text = nil;


}


- (IBAction)sendClick:(id)sender {
    [self sendMessage];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self sendMessage];
    return YES;
}

#pragma mark - 记得移除监听
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMMessage *message = self.messagesArr[indexPath.row];
    UITableViewCell *cell;
    //判断消息发起方
    switch (message.direction) {
            //收消息
        case EMMessageDirectionSend:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
        }
            
            break;
            //发消息
        case EMMessageDirectionReceive:
             cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell" forIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    
//    for (EMMessage *message in self.messagesArr) {
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                UILabel *msgLbl = [cell viewWithTag:1002];
                msgLbl.text = txt;
                
                NSLog(@"收到的文字是 txt -- %@",txt);
            }
                break;
            case EMMessageBodyTypeImage:
            {
                // 得到一个图片消息body
                EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
                NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"大图的secret -- %@"    ,body.secretKey);
                NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
                NSLog(@"大图的下载状态 -- %lu",body.downloadStatus);
                
                
                // 缩略图sdk会自动下载
                NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
                NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
                NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
                NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
                NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                NSLog(@"纬度-- %f",body.latitude);
                NSLog(@"经度-- %f",body.longitude);
                NSLog(@"地址-- %@",body.address);
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
                NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
                NSLog(@"音频的secret -- %@"        ,body.secretKey);
                NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"音频文件的下载状态 -- %lu"   ,body.downloadStatus);
                NSLog(@"音频的时间长度 -- %lu"      ,body.duration);
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                
                NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"视频的secret -- %@"        ,body.secretKey);
                NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"视频文件的下载状态 -- %lu"   ,body.downloadStatus);
                NSLog(@"视频的时间长度 -- %lu"      ,body.duration);
                NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
                
                // 缩略图sdk会自动下载
                NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
                NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
                NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
                NSLog(@"缩略图的下载状态 -- %lu"      ,body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
                NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
                NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"文件的secret -- %@"        ,body.secretKey);
                NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"文件文件的下载状态 -- %lu"   ,body.downloadStatus);
            }
                break;
                
            default:
                break;
        }
//    }
    
    return cell;
}

















@end
