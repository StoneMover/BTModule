//
//  ChatListVC.m
//  word
//
//  Created by liao on 2022/5/16.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatListVC.h"
#import "ChatListCell.h"
#import "ChatDetVC.h"
#import "ChatDetRefreshHeadView.h"


@interface ChatListVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChatListVC

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bt_initTitle:@"消息"];
    [self.pageLoadView initTableView:@[@"ChatListCell"]];
    [self.pageLoadView setTableViewNoMoreEmptyLine];
    self.pageLoadView.isNeedHeadRefresh = YES;
    self.pageLoadView.isToastWhenDataEmpty = NO;
    [self loadFromCache];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getData) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark 初始化

#pragma mark 点击事件

#pragma mark 相关方法
- (void)loadFromCache{
    NSArray * array = [NSUserDefaults.standardUserDefaults arrayForKey:@"ChatListVCCache"];
    [self.pageLoadView.dataArray removeAllObjects];
    [self.pageLoadView autoLoadSuccess:[ChatFriendModel modelWithArray:array]];
}

#pragma mark 网络请求
- (void)getData{
    [super getData];
    
    ChatFriendModel * friendModel = [ChatFriendModel new];
    friendModel.friend_id = @"1";
    friendModel.last_msg_dt = @"2022-01-01 10:00:00";
    friendModel.last_msg = @"测试消息";
    
    UserInfoModel * userModel = [UserInfoModel new];
    userModel.identify = @"1";
    userModel.user_name = @"测试名称";
    friendModel.user = userModel;
    [self.pageLoadView.dataArray removeAllObjects];
    [self.pageLoadView autoLoadSuccess:@[friendModel]];
    
//    [ChatNet messageFriendList:^(id  _Nullable obj) {
//        NSDictionary * data = [obj objectForKey:@"data"];
//        NSArray * dataArray = [data objectForKey:@"list"];
//        [NSUserDefaults.standardUserDefaults setObject:dataArray forKey:@"ChatListVCCache"];
//        [NSUserDefaults.standardUserDefaults synchronize];
//        [self loadFromCache];
//    } fail:^(NSError * _Nullable error, NSString * _Nullable errorInfo) {
//        [self.pageLoadView autoLoadError:error errorInfo:errorInfo];
//    }];
}


#pragma mark tableView data delegate
- (MJRefreshHeader *)BTPageLoadRefreshHeader:(BTPageLoadView *)loadView{
    return [ChatDetRefreshHeadView new];
}

- (void)BTPageLoadEmptyDataToast{
    
}

- (id<UITableViewDelegate>)BTPageLoadTableDelegate:(BTPageLoadView *)loadView{
    return self;
}

- (id<UITableViewDataSource>)BTPageLoadTableDataSource:(BTPageLoadView *)loadView{
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pageLoadView.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListCell * cell=[tableView dequeueReusableCellWithIdentifier:self.pageLoadView.cellId];
    ChatFriendModel * model = self.pageLoadView.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatFriendModel * model = self.pageLoadView.dataArray[indexPath.row];
    ChatDetVC * vc=[ChatDetVC new];
    vc.friendModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

@end
