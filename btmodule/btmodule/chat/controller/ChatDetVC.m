//
//  ChatDetVC.m
//  word
//
//  Created by liao on 2022/5/18.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatDetVC.h"
#import "LiveChatEmojInputView.h"
#import "EmojTextAttachment.h"
#import "ChatDetTextCell.h"
#import "ChatDetRefreshHeadView.h"
#import "ChatModel.h"
#import "ChatHeadView.h"
#import "ChatDetTimeCell.h"
#import "BlockUI.h"

typedef NS_ENUM(NSInteger,EditStatus) {
    EditStatusDefalt = 0,
    EditStatusEmoj,
    EditStatusText
};

@interface ChatDetVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) LiveChatEmojInputView * inputView;

@property (nonatomic, assign) EditStatus editStatus;

@property (nonatomic, assign) CGFloat keyboardH;

@property (nonatomic, assign) BOOL isCancelEndAnim;

@property (nonatomic, strong) ChatHeadView * headView;

@property (nonatomic, assign) BOOL isLoadingData;

@property (nonatomic, assign) BOOL isLoadFinish;

@property (nonatomic, strong) NSDate * lastCompareDate;

@end

@implementation ChatDetVC

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initInputView];
    [self initPageloadView];
    self.editStatus = EditStatusDefalt;
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapClick)];
    [self.pageLoadView.tableView addGestureRecognizer:tap];
    [self bt_initTitle:self.friendModel.user.user_name];
    [self getData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppearFirst{
    [super viewDidAppearFirst];
    [self.inputView initEmojView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
    
    
}



#pragma mark 初始化
- (void)initPageloadView{
//    [self.pageLoadView initTableView:@[@"ChatDetTextCell"] isRegisgerNib:NO];
    [self.pageLoadView initTableView:@[@"ChatDetTextCell",@"ChatDetTextCell",@"ChatDetTimeCell"]
                         cellIdArray:@[@"ChatDetTextCellLeft",@"ChatDetTextCellRight",@"ChatDetTimeCell"]
                       isRegisgerNib:NO
                               style:UITableViewStylePlain];
    self.pageLoadView.isAfterReloadLayout = YES;
    self.pageLoadView.frame = CGRectMake(0, 0, BTUtils.SCREEN_W, BTUtils.SCREEN_H - BTUtils.NAV_HEIGHT + 5);
//    self.pageLoadView.isNeedHeadRefresh = YES;
    [self.pageLoadView setTableViewNoMoreEmptyLine];
    self.pageLoadView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headView = [[ChatHeadView alloc] initWithFrame:CGRectMake(0, 0, BTUtils.SCREEN_W, 50)];
    self.pageLoadView.tableView.tableHeaderView = self.headView;
}

- (void)initInputView{
    
    __weak ChatDetVC * weakSelf=self;
    CGFloat height = toolViewHeight + BTUtils.HOME_INDICATOR_HEIGHT + emojViewHeight;
    CGFloat y = BTUtils.SCREEN_H - BTUtils.NAV_HEIGHT - toolViewHeight - BTUtils.HOME_INDICATOR_HEIGHT;
    self.inputView = [[LiveChatEmojInputView alloc] initWithFrame:CGRectMake(0,y,BTUtils.SCREEN_W,height)];
    self.inputView.backgroundColor = [UIColor bt_RGBSame:249];
    [self.view addSubview:self.inputView];
    [self.inputView.emojBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        if (weakSelf.editStatus == EditStatusEmoj) {
            [weakSelf hideInputViewAnim];
            return;
        }
        
        if (weakSelf.editStatus == EditStatusText) {
            weakSelf.isCancelEndAnim = YES;
            [weakSelf.inputView.textView endEditing:YES];
            [weakSelf showEmojAnim];
            return;
        }
        
        [weakSelf showEmojAnim];
    }];
    
    
    
    [self.inputView.sendBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [weakSelf sendClick];
    }];
    
    
    self.inputView.heightChangeBlock = ^(CGFloat height) {
        if (weakSelf.editStatus == EditStatusDefalt) {
            return;
        }
        
        if (weakSelf.editStatus == EditStatusText) {
            weakSelf.inputView.BTBottom = weakSelf.view.BTHeight - weakSelf.keyboardH + emojViewHeight + BTUtils.HOME_INDICATOR_HEIGHT;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.pageLoadView.BTBottom = weakSelf.inputView.BTTop;
            }];
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.pageLoadView.BTBottom = weakSelf.inputView.BTTop;
        }];
        weakSelf.inputView.BTBottom = weakSelf.view.BTHeight;
    };
}

#pragma mark 点击事件
- (void)tableViewTapClick{
    [self endEditNow];
}

- (void)iconClick:(ChatModel*)model isSelf:(BOOL)isSelf{
    if (isSelf) {
        [self endEditNow];
        return;
    }
    
    if (self.editStatus != EditStatusDefalt) {
        [self endEditNow];
        return;
    }
    
    NSLog(@"跳转到详情");
}

#pragma mark 相关方法
- (void)setIsLoadFinish:(BOOL)isLoadFinish{
    _isLoadFinish = isLoadFinish;
    [self.headView setLoadFinish];
}

- (void)scrollTableViewToBottom:(BOOL)isAnim{
    UITableView * tableView = self.pageLoadView.tableView;
    if (tableView.contentSize.height + tableView.contentInset.bottom > tableView.BTHeight) {
        [tableView setContentOffset:CGPointMake(0, tableView.contentSize.height - tableView.BTHeight + tableView.contentInset.bottom) animated:isAnim];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardH = 0;
    if (self.isCancelEndAnim) {
        self.isCancelEndAnim = NO;
        return;
    }
    [self hideInputViewAnim];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.keyboardH = keyboardRect.size.height;
    [self showEditAnim];
}

- (void)setEditStatus:(EditStatus)editStatus{
    _editStatus = editStatus;
    if (editStatus == EditStatusEmoj) {
        self.inputView.emojView.hidden = NO;
    }else{
        self.inputView.emojView.hidden = YES;
    }
}

- (BOOL)endEditNow{
    if (self.editStatus == EditStatusText) {
        [self.view endEditing:YES];
        return YES;
    }
    
    if (self.editStatus == EditStatusEmoj) {
        [self hideInputViewAnim];
        return YES;
    }
    
    self.editStatus = EditStatusDefalt;
    return NO;
}

- (void)showEditAnim{
    self.editStatus = EditStatusText;
    self.pageLoadView.tableView.contentInset = UIEdgeInsetsMake(self.keyboardH - BTUtils.HOME_INDICATOR_HEIGHT, 0, 0, 0);
    [self scrollTableViewToBottom:YES];
    [UIView animateWithDuration:.25 animations:^{
        self.inputView.BTBottom = self.view.BTHeight - self.keyboardH + emojViewHeight + BTUtils.HOME_INDICATOR_HEIGHT;
        self.pageLoadView.BTTop = -self.pageLoadView.tableView.contentInset.top;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)showEmojAnim{
    self.editStatus = EditStatusEmoj;
    self.pageLoadView.tableView.contentInset = UIEdgeInsetsMake(self.inputView.BTHeight - toolViewHeight- BTUtils.HOME_INDICATOR_HEIGHT, 0, 0, 0);
    [self scrollTableViewToBottom:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.inputView.BTBottom = self.view.BTHeight;
        self.pageLoadView.BTTop = -self.pageLoadView.tableView.contentInset.top;
    }];
    
    
}

- (void)hideInputViewAnim{
    self.editStatus = EditStatusDefalt;
    self.pageLoadView.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView animateWithDuration:.25 animations:^{
        self.inputView.BTBottom = self.view.BTHeight + emojViewHeight;
        self.pageLoadView.BTTop = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sendClick{
    __block NSString * resultStr = @"";
    __weak ChatDetVC * weakSelf=self;
    [self.inputView.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.inputView.textView.attributedText.length)
                                                               options:NSAttributedStringEnumerationReverse
                                                            usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//        NSLog(@"%@,%ld,%ld",attrs,range.location,range.length);
        NSAttributedString * attributed = [self.self.inputView.textView.attributedText attributedSubstringFromRange:range];
        if ([attrs.allKeys containsObject:@"NSAttachment"]) {
            EmojTextAttachment * attachment = [attrs objectForKey:@"NSAttachment"];
            resultStr = [NSString stringWithFormat:@"%@%@",attachment.emojName,resultStr];
//            NSLog(@"%@",resultStr);
        }else{
            resultStr = [NSString stringWithFormat:@"%@%@",attributed.string,resultStr];
//            NSLog(@"%@",resultStr);
        }
        
        if (range.location == 0) {
            weakSelf.inputView.textView.text = @"";
            [weakSelf.inputView resetTextViewLastRang];
            NSLog(@"富文本最后结果:%@",resultStr);
//            [weakSelf endEditNow];
            
            [self sendMessage:resultStr];
            
        }
        
    }];
    
        
}

- (NSString*)lastId{
    if (self.pageLoadView.dataArray.count == 0) {
        return nil;
    }
    
    for (ChatModel * model in self.pageLoadView.dataArray) {
        if (model.cellType == 0) {
            
            return model.msg_id;
        }
    }
    
    return nil;
}

#pragma mark 网络请求
- (void)sendMessage:(NSString*)message{
    ChatModel * model = [ChatModel modelWithDict:@{}];
    model.message = message;
    [ChatDetTextCell calculateModelCell:model];
    model.from_user_id = @"123456";
    model.create_dt = [[NSDate bt_initLocalDate] bt_dateStr:@"yyyy-MM-dd HH:mm:ss"];
    [self.pageLoadView.dataArray addObject:model];
    [self.pageLoadView.tableView reloadData];
    [self.pageLoadView.tableView layoutIfNeeded];
    [self scrollTableViewToBottom:YES];
}

- (void)getData{
    if (self.isLoadFinish) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        self.isLoadingData = NO;
        
        NSArray * listArray = ChatModel.defaultArray;
        if (![listArray isKindOfClass:[NSArray class]]) {
            self.isLoadFinish = YES;
            return;
        }
        
        //第一次请求的时候
        if (listArray.count == 0 && self.pageLoadView.dataArray.count == 0) {
            self.isLoadFinish = YES;
            return;
        }
        
        if (listArray.count < BTHttp.share.httpFilter.pageLoadSizePage) {
            self.isLoadFinish = YES;
        }
        
        BOOL isNeedScrollToBottom = self.pageLoadView.dataArray.count == 0;
        
        NSMutableArray * dataArray = [NSMutableArray new];
        
        
        CGFloat locationOffset = 0;
        NSInteger index = 0;
        for (ChatModel * chatModel in listArray) {
            
            [ChatDetTextCell calculateModelCell:chatModel];
            
//            NSDate * date = [NSDate bt_dateYMDHMS:chatModel.create_dt];
//            if (self.lastCompareDate && ![date bt_isSameDayToDate:self.lastCompareDate]) {
//                ChatModel * timeModel = [[ChatModel alloc] initTimeTypeWithDate:date];
//                [dataArray addObject:timeModel];
//                locationOffset += chatModel.cellHeight;
//                self.lastCompareDate =
//            }
            
            [dataArray addObject:chatModel];
            locationOffset += chatModel.cellHeight;
            index++;
        }
        
        
        [dataArray addObjectsFromArray:self.pageLoadView.dataArray];
        [self.pageLoadView.dataArray removeAllObjects];
        [self.pageLoadView autoLoadSuccess:dataArray];
        
        
        if (isNeedScrollToBottom) {
            [self scrollTableViewToBottom:NO];
        }else{
            if (locationOffset != 0) {
                [self.pageLoadView.tableView setContentOffset:CGPointMake(0, locationOffset)];
                
            }
        }
        
        
    });
//    if (self.isLoadFinish) {
//        return;
//    }
//    [ChatNet listWithUid:self.friendModel.user.user_id lastId:[self  lastId] success:^(id  _Nullable obj) {
//        self.isLoadingData = NO;
//        NSDictionary * data = [obj objectForKey:@"data"];
//        NSArray * listArray = [data objectForKey:@"list"];
//        if (![listArray isKindOfClass:[NSArray class]]) {
//            self.isLoadFinish = YES;
//            return;
//        }
//        
//        //第一次请求的时候
//        if (listArray.count == 0 && self.pageLoadView.dataArray.count == 0) {
//            self.isLoadFinish = YES;
//            return;
//        }
//        
//        if (listArray.count < BTCoreConfig.share.pageLoadSizePage) {
//            self.isLoadFinish = YES;
//        }
//        
//        BOOL isNeedScrollToBottom = self.pageLoadView.dataArray.count == 0;
//        
//        NSMutableArray * dataArray = [NSMutableArray new];
//        
//        
//        CGFloat locationOffset = 0;
//        NSInteger index = 0;
//        for (NSDictionary * dict in listArray) {
//            ChatModel * chatModel = [ChatModel modelWithDict:dict];
//            [ChatDetTextCell calculateModelCell:chatModel];
//            
////            NSDate * date = [NSDate bt_dateYMDHMS:chatModel.create_dt];
////            if (self.lastCompareDate && ![date bt_isSameDayToDate:self.lastCompareDate]) {
////                ChatModel * timeModel = [[ChatModel alloc] initTimeTypeWithDate:date];
////                [dataArray addObject:timeModel];
////                locationOffset += chatModel.cellHeight;
////                self.lastCompareDate = 
////            }
//            
//            [dataArray addObject:chatModel];
//            locationOffset += chatModel.cellHeight;
//            index++;
//        }
//        
//        
//        [dataArray addObjectsFromArray:self.pageLoadView.dataArray];
//        [self.pageLoadView.dataArray removeAllObjects];
//        [self.pageLoadView autoLoadSuccess:dataArray];
//        
//        
//        if (isNeedScrollToBottom) {
//            [self scrollTableViewToBottom:NO];
//        }else{
//            if (locationOffset != 0) {
//                [self.pageLoadView.tableView setContentOffset:CGPointMake(0, locationOffset)];
//                
//            }
//        }
//        
//    } fail:^(NSError * _Nullable error, NSString * _Nullable errorInfo) {
//        self.isLoadingData = NO;
//        [BTToast showErrorObj:error errorInfo:errorInfo];
//        [self.pageLoadView endHeadRefresh];
//    }];
//    
}

#pragma mark tableView data delegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditNow];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= 0 && !self.isLoadingData) {
        self.isLoadingData = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getData];
        });
        
    }
}

- (MJRefreshHeader*)BTPageLoadRefreshHeader:(BTPageLoadView*)loadView{
    return [ChatDetRefreshHeadView new];
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
    ChatModel * model = self.pageLoadView.dataArray[indexPath.row];
    __weak ChatDetVC * weakSelf=self;
    if (model.cellType == 1) {
        ChatDetTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:self.pageLoadView.dataArrayCellId[2]];
        cell.timeLabel.text = model.displayTimeStr;
        return cell;
    }
    
    if (![model.from_user_id isEqualToString:@"123456"]) {
        ChatDetTextCell * cell = [tableView dequeueReusableCellWithIdentifier:self.pageLoadView.dataArrayCellId[0]];
        [cell initSubView:ChatDetLocalTypeLeft];
        cell.model = model;
        [cell.iconBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [weakSelf iconClick:model isSelf:NO];
        }];
//        [cell.iconImgView sd_setImageWithURL:[BTNet getImgResultUrl:self.friendModel.user.user_icon] placeholderImage:PLACEHOLDER];
        return cell;
    }
    ChatDetTextCell * cell = [tableView dequeueReusableCellWithIdentifier:self.pageLoadView.dataArrayCellId[1]];
    [cell initSubView:ChatDetLocalTypeRight];
    cell.model = model;
    [cell.iconBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [weakSelf iconClick:model isSelf:YES];
    }];
//    [cell.iconImgView sd_setImageWithURL:[BTNet getImgResultUrl:AppHelp.share.userModel.userIconUrl] placeholderImage:PLACEHOLDER];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel * model = self.pageLoadView.dataArray[indexPath.row];
    return model.cellHeight;
}

#pragma mark SocketCenterDelegate
- (void)socketReceiveChatMeg:(ChatModel *)model{
    [ChatDetTextCell calculateModelCell:model];
    [self.pageLoadView.dataArray addObject:model];
    [self.pageLoadView.tableView reloadData];
    [self.pageLoadView.tableView layoutIfNeeded];
    [self scrollTableViewToBottom:YES];
}

@end
