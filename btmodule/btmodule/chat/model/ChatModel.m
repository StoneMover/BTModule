//
//  ChatModel.m
//  word
//
//  Created by liao on 2022/5/21.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatModel.h"
#import "ChatDetTextCell.h"
#import <BTHelp/BTHelp.h>

@implementation ChatModel

+ (NSArray *)defaultArray{
    NSMutableArray * dataArray = [NSMutableArray new];
    NSArray * strArray = @[
        @"此处会显示出",
        @"此处可以输入发送内容，点法发送后，即可发送对应内容给到好友",
        @"点击头像可以进入到好友主页",
        @"支持发送表情包，点击展示所有表情（参考微信）",
        @"点赞类型消息中新增一个通知场景发布在单词广场的课程，收到用户点赞时，需要对应推送对应的样式同之前点赞模板，内容为：xxx赞了你发布在单词广场的课程《xx》点击跳转至单词广场对应课程详情页",
        @"当有玩家正在等到匹配时，有此标识和文字提醒",
        @"学习模式下，如果是单词广场课程，新增课程点赞&课程评价功能（同单词广场课程详情的点赞&评价功能）此处显示课程点赞总数，可以直接点赞，点击评价则直接跳转至单词广场对应课程的评价页面。",
        @"点击例句",
        @"此处会显示出",
        @"此处可以输入发送内容，点法发送后，即可发送对应内容给到好友",
        @"点击头像可以进入到好友主页",
        @"支持发送表情包，点击展示所有表情（参考微信）",
        @"点赞类型消息中新增一个通知场景发布在单词广场的课程，收到用户点赞时，需要对应推送对应的样式同之前点赞模板，内容为：xxx赞了你发布在单词广场的课程《xx》点击跳转至单词广场对应课程详情页",
        @"当有玩家正在等到匹配时，有此标识和文字提醒",
        @"学习模式下，如果是单词广场课程，新增课程点赞&课程评价功能（同单词广场课程详情的点赞&评价功能）此处显示课程点赞总数，可以直接点赞，点击评价则直接跳转至单词广场对应课程的评价页面。",
        @"点击例句"
    ];
    
    NSInteger index = 0;
    for (NSString * str in strArray) {
        ChatModel * model = [ChatModel new];
        model.message = str;
//        [ChatDetTextCell calculateModelCell:model];
        [dataArray addObject:model];
        if (index % 3 == 0) {
            model.from_user_id = @"123456";
        }
        index ++;
    }
    
    
    return dataArray;
}


- (CGFloat)messageViewW{
    if (_messageViewW == 0) {
        return [ChatDetTextCell messageViewWidth];
    }
    return _messageViewW;
}

- (void)initSelf{
    self.aliasDict = @{@"message":@"content"};
}

- (instancetype)initTimeTypeWithDate:(NSDate*)date{
    self = [super init];
    self.cellType = 1;
    NSDate * dateNow = [NSDate bt_initLocalDate];
    if ([date bt_isSameDayToDate:dateNow]) {
        self.displayTimeStr = [date bt_dateStr:@"HH:mm"];
    }else if ([date bt_isSameMonthToDate:dateNow]){
        self.displayTimeStr = [date bt_dateStr:@"MM-dd"];
    }else{
        self.displayTimeStr = [date bt_dateStr:@"yyyy-MM-dd"];
    }
    self.cellHeight = 35;
    return self;
}

@end
