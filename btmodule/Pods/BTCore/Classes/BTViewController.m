//
//  BTViewController.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTViewController.h"
#import <WebKit/WebKit.h>


@implementation UIViewController (BTCategoryViewController)

- (void)bt_popToViewController:(Class)cla{
    [self bt_popToViewController:cla animated:YES];
}

- (void)bt_popToViewController:(Class)cla animated:(BOOL)animated{
    for (UIViewController * childVc in self.navigationController.viewControllers) {
        if ([childVc isKindOfClass:cla]) {
            [self.navigationController popToViewController:childVc animated:animated];
            return;
            
        }
    }
}

- (void)bt_popToArrayViewController:(NSArray<Class>*)claArray animated:(BOOL)animated{
    for (Class cla in claArray) {
        for (UIViewController * childVc in self.navigationController.viewControllers) {
            if ([childVc isKindOfClass:cla]) {
                [self.navigationController popToViewController:childVc animated:animated];
                return;
            }
        }
    }
    
}

- (void)bt_removeNowVcToNextVc:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
    [self.rt_navigationController removeViewController:self animated:NO];
}

- (void)bt_popToRootVcWithOutChildVc:(Class)childVcCla animated:(BOOL)animated{
    for (UIViewController * childVc in self.navigationController.viewControllers) {
        if ([childVc isKindOfClass:childVcCla]) {
            [self.navigationController popToViewController:childVc animated:animated];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:animated];
}

@end

@interface BTViewController()

@property (nonatomic, strong) UISwipeGestureRecognizer * swipeGestureRecognizer;

@end


@implementation BTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isTouceViewEndCloseKeyBoard=YES;
    if (BTNavConfig.share.defaultNavLineColor) {
        [self bt_setNavLineColor:BTNavConfig.share.defaultNavLineColor];
    }
    
    if (BTNavConfig.share.defaultVCBgColor) {
        self.view.backgroundColor = BTNavConfig.share.defaultVCBgColor;
    }
    
}

#pragma mark 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewWillAppearIndex++;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.viewDidAppearIndex==0) {
        [self viewDidAppearFirst];
        if (BTVcConfig.share.isDoDebugCode) {
            [self debugConfig];
        }
    }
    self.viewDidAppearIndex++;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isTouceViewEndCloseKeyBoard) {
        [self.view endEditing:YES];
    }
}

- (void)viewDidAppearFirst{
    
}

#pragma mark loading
- (void)getData{
    
}

- (void)bt_loadingReload{
    [super bt_loadingReload];
    [self getData];
}

- (void)debugConfig{
    
}

- (void)addRightSwipe{
    if (self.swipeGestureRecognizer) {
        return;
    }
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognize:)];
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.swipeGestureRecognizer];
}

-(void)swipeGestureRecognize:(UISwipeGestureRecognizer *)recognize{
    
}

- (void)dealloc{
    if (BTVcConfig.share.isLogVcDestory) {
        NSString * name = NSStringFromClass([self class]);
        NSLog(@"%@",[NSString stringWithFormat:@"%@已经释放",name]);
    }
}

@end


@implementation BTNavigationController

- (void)viewDidLoad {
    self.transferNavigationBarAttributes = true;
    self.useSystemBackBarButtonItem = false;
    [super viewDidLoad];
    self.navigationBar.translucent = false;
    self.navigationBar.tintColor=UIColor.blackColor;
    self.navigationBar.barTintColor = UIColor.whiteColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

//- (void)_layoutViewController:(NSObject*)obj{
//    //    [super layoutViewController];
//}





@end



@interface BTWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) BTProgressView * progressView;

@end

@implementation BTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    if (self.webTitle) {
        [self bt_initTitle:self.webTitle];
    }
    [self inileftBarSelf];
    [self bt_setNavLineColor:self.webNavLineColor ? self.webNavLineColor : [UIColor bt_RGBSame:238]];
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self bt_initLoading];
    }else if (self.loadingType == BTWebViewLoadingProgress) {
        [self initProgressView];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //先让loading界面加载完成，由于初始化webView很耗时间
        [self initWebView];
        
    });
}

- (void)inileftBarSelf{
    if (self.backImg == nil) {
        self.backImg = [UIImage imageNamed:@"bt_nav_back"];
    }
    
    if (!self.closeImg) {
        UIBarButtonItem * backItem = [self bt_createItemImg:self.backImg action:@selector(bt_leftBarClick)];
        UIBarButtonItem * closeItem = [self bt_createItemImg:self.closeImg action:@selector(closeClick)];
        self.navigationItem.leftBarButtonItems = @[backItem,closeItem];
        return;
    }
    
    if (self.isPresentStyle) {
        [self bt_initLeftBarImg:self.backImg];
    }
}

- (void)closeClick{
    [super bt_leftBarClick];
}

- (void)bt_leftBarClick{
    if (self.closeImg && self.webView.canGoBack) {
        [self.webView goBack];
        return;
    }
    
    if (self.isPresentStyle){
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
        return;
    }
    
    [super bt_leftBarClick];
    
}

- (void)initWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate=self;
    self.webView.UIDelegate=self;
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:@"back"];
    for (NSString * function in self.jsFunctionArray) {
        [[self.webView configuration].userContentController addScriptMessageHandler:self name:function];
    }
    self.webView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.webView atIndex:0];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    if (self.btWebInitFinish) {
        self.btWebInitFinish(self.webView);
    }
    if (![BTUtils isEmpty:self.richText]) {
        [self.webView loadHTMLString:self.richText baseURL:nil];
    }else{
        NSURL * url=[NSURL URLWithString:self.url];
        NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
        if(self.requestSetBlock){
            self.requestSetBlock(request);
        }
        [self.webView loadRequest:request];
    }
}

- (void)initProgressView{
    self.progressView = [[BTProgressView alloc] initBTViewWithSize:CGSizeMake(BTUtils.SCREEN_W, 2)];
    self.progressView.progressSize = 2;
    self.progressView.progressCorner = 1;
    self.progressView.backgroundColor = UIColor.clearColor;
    if (!self.progressViewColor) {
        self.progressViewColor = BTTheme.mainColor;
    }
    if (!self.progressViewColor) {
        self.progressViewColor = UIColor.redColor;
    }
    self.progressView.progressColor = self.progressViewColor;
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.progressView.percent = 0.05;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = NO;
        self.progressView.percent = self.webView.estimatedProgress;
        if (self.progressView.percent == 1) {
            self.progressView.hidden = YES;
        }
    }
    
    if ([keyPath isEqualToString:@"title"])
    {
        NSLog(@"%@",[object valueForKey:@"title"]);
        if (self.isTitleFollowWeb) {
            [self bt_initTitle:[object valueForKey:@"title"]];
        }
    }
}

#pragma mark WKNavigationDelegate
//页面开始加载的时候
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.loadingType == BTWebViewLoadingProgress) {
        self.progressView.hidden = NO;
    }
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self.loadingHelp dismiss];
    }else{
        self.progressView.hidden = YES;
    }
    if (self.btWebLoadSuccessBlock) {
        self.btWebLoadSuccessBlock(webView);
    }
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self.loadingHelp showError:@"加载失败"];
    }else{
        self.progressView.hidden = YES;
    }
    
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.loadingType == BTWebViewLoadingDefault) {
        [self.loadingHelp showError:@"加载失败"];
    }else{
        self.progressView.hidden = YES;
    }
    
}

#pragma mark WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    [self bt_showAlert:@"提示" msg:message btns:@[@"确定"] block:^(NSInteger index) {
        completionHandler();
    }];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    [self bt_showAlert:@"提示" msg:message btns:@[@"取消",@"确定"] block:^(NSInteger index) {
        completionHandler(index==1);
    }];
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    [self bt_showAlertEdit:@"编辑" defaultValue:@"" placeHolder:@"请输入内容" block:^(NSString * _Nullable result) {
        if (!result) {
            completionHandler(@"");
        }else{
            completionHandler(result);
        }
    }];
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //message.name  方法名
    //message.body  参数值
    if ([message.name isEqualToString:@"back"]) {
        [self bt_leftBarClick];
    }else{
        if (self.jsFunctionBlock) {
            self.jsFunctionBlock(message.name, message.body);
        }
    }
}

#pragma mark 解决https加载问题
- (void)webView:(WKWebView*)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge completionHandler:(void(^)(NSURLSessionAuthChallengeDisposition,NSURLCredential*_Nullable))completionHandler{

   if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){

       NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];

       completionHandler(NSURLSessionAuthChallengeUseCredential,card);

   }

}

#pragma mark kvo

- (void)bt_loadingReload{
    [super bt_loadingReload];
    NSURL * url=[NSURL URLWithString:self.url];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"back"];
    for (NSString * function in self.jsFunctionArray) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:function];
    }
    [self.webView removeObserver:self forKeyPath:@"title"];
    if (self.loadingType == BTWebViewLoadingProgress) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

@end



@implementation BTPageLoadViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    _pageLoadView = [[BTPageLoadView alloc] initWithFrame:self.view.bounds delegate:self];
    self.pageLoadView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pageLoadView.refreshTimeKey = NSStringFromClass([self class]);
    [self.view addSubview:self.pageLoadView];
}

//MARK: BTPageLoadViewDelegate
- (void)BTPageLoadGetData:(BTPageLoadView*)loadView{
    [self getData];
}

- (void)setLayoutFromStatusBar{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    if (@available(iOS 13.0, *)) {
        self.pageLoadView.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
}

@end


#import <BTHelp/UIImage+BTImage.h>


@interface BTLogVC()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSMutableArray * dataAllArray;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end


@implementation BTLogVC

#pragma mark 生命周期
- (void)viewDidLoad{
    [super viewDidLoad];
//    [BTLog.share save:@"进入BTLogVC"];
//    [self bt_initTitle:@"BTLog"];
//    [self bt_initLeftBarStr:@"返回"];
//    [self bt_initRightBarStr:@"更多"];
    self.pageSize = 100;
    self.pageLoadView.loadFinishDataNum = 100;

    [self.pageLoadView initTableView];
    [self.pageLoadView registerTableViewCellWithClass:[BTLogTableViewCell class]];
    self.pageLoadView.tableView.estimatedRowHeight = 60;
    [self.pageLoadView setTableViewNoMoreEmptyLine];
    self.pageLoadView.isNeedFootRefresh = YES;
//    self.pageLoadView.isNeedHeadRefresh = YES;
    
    self.dataAllArray = [NSMutableArray new];
    [BTLog.share asycnReadLogString:^(NSArray<NSString *> * _Nonnull logStr) {
        [self.dataAllArray removeAllObjects];
        [self.dataAllArray addObjectsFromArray:[[logStr reverseObjectEnumerator] allObjects]];
        [self getData];
    }];
    
    
}

- (void)getData{
    
    NSInteger start = self.pageIndex * self.pageSize;
    NSInteger end = start + self.pageSize;
    
    if (start >= self.dataAllArray.count) {
        [self.pageLoadView autoLoadSuccess:@[]];
        [BTToast show:@"数据加载完成"];
        return;
    }
    
    if (end >= self.dataAllArray.count) {
        [BTToast show:@"数据加载完成"];
        NSArray * array = [self.dataAllArray subarrayWithRange:NSMakeRange(start, self.dataAllArray.count - start)];
        [self.pageLoadView autoLoadSuccess:array];
        return;
    }
    
    NSArray * array = [self.dataAllArray subarrayWithRange:NSMakeRange(start, end)];
    [self.pageLoadView autoLoadSuccess:array];
    self.pageIndex++;
}



- (void)bt_rightBarClick{
    [self bt_showActionSheet:@"操作" msg:nil btns:@[@"复制当前数据",@"导出日志文件",@"清空日志"] block:^(NSInteger index) {
        if (index == 0) {
            NSString * newStr = [[self.pageLoadView.dataArray valueForKey:@"description"] componentsJoinedByString:@"\n\n"];
            UIPasteboard.generalPasteboard.string = newStr;
            [BTToast showSuccess:@"数据已复制到粘贴板"];
            return;
        }

        if (index == 1) {
            [self toShareVc];
            return;
        }
        
        if (index == 2) {
            [BTLog.share clearLog];
            self.pageIndex = 0;
            [self.dataAllArray removeAllObjects];
            [self.pageLoadView.dataArray removeAllObjects];
            [self.pageLoadView.tableView reloadData];
            return;
        }
        
    }];
}


- (void)toShareVc{
    if (!self.documentController) {
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:BTLog.share.logFilePath]];
        self.documentController.delegate = self;// 遵循代理
        self.documentController.UTI = @"txt"; // 哪类文件支持第三方打开，这里不证明就代表所有文件！
    }
    [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

#pragma mark UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.view.frame;
}



#pragma mark tableView data delegate
- (id<UITableViewDataSource>)BTPageLoadTableDataSource:(BTPageLoadView *)loadView{
    return self;
}

- (id<UITableViewDelegate>)BTPageLoadTableDelegate:(BTPageLoadView *)loadView{
    return self;
}

#pragma mark tableView data delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.pageLoadView.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTLogTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:self.pageLoadView.cellId];
    cell.labelTitle.text = self.pageLoadView.dataArray[indexPath.row];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * str = self.pageLoadView.dataArray[indexPath.row];
    UIPasteboard.generalPasteboard.string = str;
    [BTToast showSuccess:@"复制成功"];
}


@end


@implementation BTLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initLabel];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return self;
}



- (void)initLabel{
    self.labelTitle=[[UILabel alloc] init];
    self.labelTitle.translatesAutoresizingMaskIntoConstraints=NO;
    self.labelTitle.font=[UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    self.labelTitle.textColor=[UIColor blackColor];
    self.labelTitle.numberOfLines = 0;
    [self addSubview:self.labelTitle];
    [self.labelTitle bt_addTopToItemView:self constant:2];
    [self.labelTitle bt_addLeftToItemView:self constant:0];
    [self.labelTitle bt_addBottomToItemView:self constant:-2];
    [self.labelTitle bt_addRightToItemView:self constant:0];
}




@end



@implementation BTVcConfig

+ (nonnull instancetype)share{
    static BTVcConfig * config=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[super allocWithZone:NULL] init];
    });
    return config;
}


+ (id)allocWithZone:(struct _NSZone *)zone {
   return [BTVcConfig share] ;
}


- (id)copyWithZone:(NSZone *)zone {
    return [BTVcConfig share];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [BTVcConfig share];
}


- (instancetype)init{
    self = [super init];
    self.isLogVcDestory = YES;
    return self;
}

@end
