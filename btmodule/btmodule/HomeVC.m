//
//  HomeVC.m
//  btmodule
//
//  Created by kds on 2022/5/25.
//

#import "HomeVC.h"
#import <BTWidgetView/BTGeneralCell.h>
#import "BTAreaListVC.h"
#import "chat/controller/ChatListVC.h"

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation HomeVC


#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bt_initTitle:@"BTModule"];
    [self.pageLoadView initTableView];
    [self.pageLoadView registerTableViewCellWithClass:[BTGeneralCell class]];
    [self.pageLoadView setTableViewNoMoreEmptyLine];
    [self.pageLoadView.dataArray addObjectsFromArray:@[@"地区选择",@"即时通讯聊天"]];
}


#pragma mark 初始化

#pragma mark 点击事件

#pragma mark 相关方法

#pragma mark 网络请求

#pragma mark tableView data delegate
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
    BTGeneralCell * cell=[tableView dequeueReusableCellWithIdentifier:self.pageLoadView.cellId];
    if (!cell.generalView.isHadInit) {
        cell.generalView.titleLabelBlock = ^(BTGeneralCellConfig * _Nonnull config) {
            config.leftPadding = 20;
            config.textColor = UIColor.bt_text_color;
        };
        
        [cell.generalView initWidget:BTGeneralCellStyleJustTitle];
    }
    cell.generalView.titleLabel.text = self.pageLoadView.dataArray[indexPath.row];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        BTAreaListVC * vc=[BTAreaListVC new];
        vc.block = ^(NSObject * _Nullable obj) {
            BTAreaModel * model = (BTAreaModel*)obj;
            [BTToast showSuccess:[@"选择了:" stringByAppendingString:model.countryCh]];
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == 1) {
        ChatListVC * vc=[ChatListVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


@end
