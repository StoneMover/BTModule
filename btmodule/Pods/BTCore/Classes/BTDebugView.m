//
//  BTDebugView.m
//  BTCoreExample
//
//  Created by kds on 2022/4/18.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "BTDebugView.h"
#import <BTHelp/BTConfig.h>
#import <BTHelp/BTUtils.h>
#import <BTHelp/UIView+BTViewTool.h>
#import <BTHelp/UIColor+BTColor.h>


@interface BTDebugView()

@property (nonatomic, strong) UILabel * label;

@end


@implementation BTDebugView

+ (void)show{
    BTDebugView * view = [BTDebugView new];
    view.BTLeft = 20;
    view.BTCenterY = BTUtils.SCREEN_H / 2;
    view.BTCorner = 5;
    [BTUtils.APP_WINDOW addSubview:view];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeEnv) name:@"BT_ENV_CHANGE" object:nil];
    self.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.4];
    self.label = [UILabel new];
    self.label.numberOfLines = 0;
    self.label.textColor = UIColor.whiteColor;
    self.label.text = [[NSString alloc] initWithFormat:@" BTDebug:\n %@",BTEnvMananger.nowModel.identify];
    
    [self.label sizeToFit];
    self.label.BTTop = 5;
    
    self.BTWidth = self.label.BTWidth + 10;
    self.BTHeight = self.label.BTHeight + 10;
    [self addSubview:self.label];
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tapGesture];
    
    return self;
}

- (void)tapClick{
    [BTUtils.getCurrentVc.navigationController pushViewController:[BTDebugPageVC new] animated:YES];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint transP = [pan translationInView:self.superview];
    self.transform = CGAffineTransformTranslate(self.transform, transP.x, transP.y);
    [pan setTranslation:CGPointZero inView:self.superview];
}

- (void)changeEnv{
    self.label.text = [[NSString alloc] initWithFormat:@" BTDebug:\n %@",BTEnvMananger.nowModel.identify];
}

@end


@implementation BTApiCell



@end


@interface BTApiVC()<UITableViewDelegate,UITableViewDataSource>




@end

@implementation BTApiVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.pageLoadView initTableView];
    [self.pageLoadView registerTableViewCellWithClass:[BTApiCell class]];
    [self.pageLoadView.dataArray addObjectsFromArray:[BTEnvMananger.share allEnv]];
    self.pageLoadView.tableView.estimatedRowHeight = 80;
}

- (NSString*)displayStr:(BTEnvModel*)model{
    NSString * content = model.identify;
    if (model.isSelect) {
        content = [content stringByAppendingString:@" - 当前环境\n\n"];
    }else{
        content = [content stringByAppendingString:@"\n\n"];
    }
    
    content = [content stringByAppendingFormat:@"URL : %@\n\n",model.url];
    content = [content stringByAppendingFormat:@"IMGURL : %@\n\n",[BTUtils isEmpty:model.imgUrlStart] ? @"暂无" : model.imgUrlStart];
    NSString * otherStr = [BTUtils convertDictToJsonStr:model.otherDict];
    if ([otherStr isEqualToString:@"{}"] || [BTUtils isEmpty:otherStr]) {
        otherStr = @"暂无";
    }
    content = [content stringByAppendingFormat:@"其它参数 : %@",otherStr];
    return content;
}



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
    BTApiCell * cell=[tableView dequeueReusableCellWithIdentifier:self.pageLoadView.cellId];
    BTEnvModel * model = self.pageLoadView.dataArray[indexPath.row];
    cell.textLabel.text = [self displayStr:model];
    cell.textLabel.numberOfLines = 0;
    if (model.isSelect) {
        cell.textLabel.textColor = UIColor.bt_main_color;
    }else{
        cell.textLabel.textColor = UIColor.blackColor;
    }
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BTEnvModel * model = self.pageLoadView.dataArray[indexPath.row];
    [self bt_showActionSheet:@"操作" msg:nil btns:@[@"复制",@"设置为当前环境"] block:^(NSInteger index) {
        if (index == 0) {
            UIPasteboard.generalPasteboard.string = [self displayStr:model];
            [BTToast showSuccess:@"复制成功"];
            return;
        }
        
        if (index == 1) {
            [BTEnvMananger.share selectWithId:model.identify];
            [BTToast showSuccess:@"设置成功，请重启APP以重新加载数据"];
//            [self.pageLoadView.dataArray removeAllObjects];
            [self.pageLoadView.tableView reloadData];
            return;
        }
        
    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return -1;
//}



@end


@interface BTDebugPageVC()<BTPageViewControllerDataSource,BTPageViewControllerDelegate>

@property (nonatomic, strong) BTPageHeadLabelView * headView;

@property (nonatomic, strong) BTLogVC * logVc;

@property (nonatomic, strong) BTApiVC * apiVc;

@end


@implementation BTDebugPageVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self bt_initTitle:@"BTDebug"];
    self.view.backgroundColor = UIColor.bt_bg_color;
    self.delegate = self;
    self.dataSource = self;
    
    self.logVc = [BTLogVC new];
    self.apiVc = [BTApiVC new];
    
    self.headView = [[BTPageHeadLabelView alloc] initWithFrame:CGRectMake(0, 0, BTUtils.SCREEN_W, 40) titles:@[@"本地日志",@"环境配置"] style:BTPageHeadViewStyleAverage];
    self.headView.selectColor = UIColor.bt_main_color;
    [self.headView initViewIndicator:CGSizeMake(80, 1) corner:0 bgColor:self.headView.selectColor];
    [self reloadData];
}
- (void)bt_rightBarClick{
    if ([[self rootView] pageNowIndex] == 0) {
        [self.logVc bt_rightBarClick];
        return;
    }
}


#pragma mark BTPageViewControllerDataSource,BTPageViewControllerDelegate
- (NSInteger)pageNumOfVc:(BTPageViewController*)pageView{
    return 2;
}

- (UIViewController*)pageVc:(BTPageViewController*)pageVc vcForIndex:(NSInteger)index{
    if (index == 0) {
        return self.logVc;
    }
    
    return self.apiVc;
}

//为空则不显示headView
- (nullable BTPageHeadView*)pageVcHeadView:(BTPageViewController*)pageVc{
    return self.headView;
}

- (CGPoint)pageVcHeadOrigin:(BTPageViewController*)pageVc{
    return CGPointZero;
}

- (CGRect)pageVcContentFrame:(BTPageViewController*)pageVc{
    return CGRectMake(0, self.headView.BTHeight, BTUtils.SCREEN_W, BTUtils.SCREEN_H - BTUtils.NAV_HEIGHT - self.headView.BTHeight);
}

- (CGRect)pageViewFrame{
    return CGRectMake(0, 0, BTUtils.SCREEN_W, BTUtils.SCREEN_H - BTUtils.NAV_HEIGHT);
}

- (void)pageVc:(BTPageViewController*)pageView didShow:(NSInteger)index{
    if (index == 0) {
        [self bt_initRightBarStr:@"更多"];
        return;
    }
    
    [self bt_initRightBarStr:@""];
}

- (void)pageVc:(BTPageViewController *)pageView didDismiss:(NSInteger)index{
    
}


@end



