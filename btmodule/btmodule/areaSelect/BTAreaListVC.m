//
//  BTAreaListVC.m
//  btmodule
//
//  Created by kds on 2022/5/26.
//

#import "BTAreaListVC.h"
#import <BTWidgetView/BTGeneralCell.h>
#import <BTHelp/NSString+BTString.h>
#import "BTAreaSectionView.h"

@interface BTAreaListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * groupDataArray;

@property (nonatomic, strong) NSMutableArray * childDataArray;

@property (nonatomic, strong) NSMutableArray * sectionStrArray;

@end

@implementation BTAreaListVC


#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bt_initTitle:@"选择地区"];
    [self initTableView];
    [self initData];
}

#pragma mark 初始化
- (void)initTableView{
    [self.pageLoadView initTableView];
    [self.pageLoadView registerTableViewCellWithClass:[BTGeneralCell class]];
    [self.pageLoadView setTableViewNoMoreEmptyLine];
    self.pageLoadView.tableView.sectionIndexColor = UIColor.bt_text_color;
    self.pageLoadView.tableView.separatorColor = UIColor.bt_divider_color;
}

- (void)initData{
    self.childDataArray = [NSMutableArray new];
    self.groupDataArray = [NSMutableArray new];
    self.sectionStrArray = [NSMutableArray new];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSString * path = [NSBundle.mainBundle pathForResource:@"areaData.txt" ofType:nil];
        NSData * data = [[NSData alloc] initWithContentsOfFile:path];
        NSString * dataStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray * array = [dataStr bt_toArray];
        
        BTAreaGroupModel * offtenGroupModel = [BTAreaGroupModel new];
        offtenGroupModel.startStr = @"常用地区";
        offtenGroupModel.subArray = [[NSMutableArray alloc] init];
        
        BTAreaModel * chinaModel = nil;
        BTAreaModel * hongKongModel = nil;
        BTAreaModel * aoMenModel = nil;
        BTAreaModel * taiWanModel = nil;
        
        
        for (NSDictionary * dict in array) {
            BTAreaModel * model = [BTAreaModel modelWithDict:dict];
            NSMutableString * pStr = [[NSMutableString alloc] initWithString:model.countryCh];
            CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformMandarinLatin,NO);
            //再转换为不带声调的拼音
            CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformStripDiacritics,NO);
            
            //转化为大写拼音
            NSString * pPinYin = [pStr capitalizedString];
            model.pinYinStr = pPinYin;
            if (pPinYin.length > 0) {
                model.startStr = [pPinYin substringToIndex:1];
            }
            
            [self autoAddToGroup:model];
            [self.childDataArray addObject:model];
            
            if ([model.countryCh isEqualToString:@"中国大陆"] ) {
                chinaModel = model;
            }
            
            if ([model.countryCh isEqualToString:@"中国香港"] ) {
                hongKongModel = model;
            }
            
            if ([model.countryCh isEqualToString:@"中国澳门"] ) {
                aoMenModel = model;
            }
            
            if ([model.countryCh isEqualToString:@"中国台湾"] ) {
                taiWanModel = model;
            }
            
            
        }
        
        if (chinaModel) {
            [offtenGroupModel.subArray addObject:chinaModel];
        }
        
        if (hongKongModel) {
            [offtenGroupModel.subArray addObject:hongKongModel];
        }
        
        if (aoMenModel) {
            [offtenGroupModel.subArray addObject:aoMenModel];
        }
        
        if (taiWanModel) {
            [offtenGroupModel.subArray addObject:taiWanModel];
        }
        
        
        NSArray * sortArray = [self.groupDataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            BTAreaGroupModel * first = (BTAreaGroupModel*)obj1;
            BTAreaGroupModel * second = (BTAreaGroupModel*)obj2;
            return [first.startStr compare:second.startStr options:NSLiteralSearch];
        }];
        
        for (BTAreaGroupModel * groupModel in sortArray) {
            NSArray * childSortArray = [groupModel.subArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                BTAreaModel * first = (BTAreaModel*)obj1;
                BTAreaModel * second = (BTAreaModel*)obj2;
                return [first.pinYinStr compare:second.pinYinStr options:NSLiteralSearch];
            }];
            groupModel.subArray = [[NSMutableArray alloc] initWithArray:childSortArray];
            [self.sectionStrArray addObject:groupModel.startStr];
        }
        
        [self.sectionStrArray insertObject:@"#" atIndex:0];
        
        [self.groupDataArray removeAllObjects];
        [self.groupDataArray addObjectsFromArray:sortArray];
        [self.groupDataArray insertObject:offtenGroupModel atIndex:0];
        
        
        [self.pageLoadView.dataArray addObjectsFromArray:self.groupDataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pageLoadView.tableView reloadData];
        });
    });
}

#pragma mark 点击事件

#pragma mark 相关方法
- (void)autoAddToGroup:(BTAreaModel*)model{
    for (BTAreaGroupModel * groupModel in self.groupDataArray) {
        if ([groupModel.startStr isEqualToString:model.startStr]) {
            [groupModel.subArray addObject:model];
            return;
        }
    }
    
    BTAreaGroupModel * groupModel = [BTAreaGroupModel new];
    groupModel.startStr = model.startStr;
    groupModel.pinYinStr = model.pinYinStr;
    groupModel.subArray = [NSMutableArray new];
    [groupModel.subArray addObject:model];
    [self.groupDataArray addObject:groupModel];
}




#pragma mark 网络请求

#pragma mark tableView data delegate
- (id<UITableViewDelegate>)BTPageLoadTableDelegate:(BTPageLoadView *)loadView{
    return self;
}

- (id<UITableViewDataSource>)BTPageLoadTableDataSource:(BTPageLoadView *)loadView{
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    return index;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionStrArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.pageLoadView.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BTAreaGroupModel * model = self.pageLoadView.dataArray[section];
    BTAreaSectionView * sectionView = [BTAreaSectionView new];
    sectionView.titleLabel.text = model.startStr;
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BTAreaGroupModel * model = self.pageLoadView.dataArray[section];
    return model.subArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTAreaGroupModel * groupModel = self.pageLoadView.dataArray[indexPath.section];
    BTAreaModel * model = groupModel.subArray[indexPath.row];
    BTGeneralCell * cell = [tableView dequeueReusableCellWithIdentifier:self.pageLoadView.cellId];
    if (!cell.generalView.isHadInit) {
        cell.generalView.titleLabelBlock = ^(BTGeneralCellConfig * _Nonnull config) {
            config.leftPadding = 15;
            config.font = [UIFont BTAutoFontWithSize:16];
            config.textColor = UIColor.bt_text_color;
        };
        [cell.generalView initWidget:BTGeneralCellStyleJustTitle];
    }
    cell.generalView.titleLabel.text = [NSString localizedStringWithFormat:@"%@ +%zd",model.countryCh,model.countryNum];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BTAreaGroupModel * groupModel = self.pageLoadView.dataArray[indexPath.section];
    BTAreaModel * model = groupModel.subArray[indexPath.row];
    if (self.block) {
        self.block(model);
    }
    [self bt_leftBarClick];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


@end
