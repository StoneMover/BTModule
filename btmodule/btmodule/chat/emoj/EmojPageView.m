//
//  EmojPageView.m
//  mingZhong
//
//  Created by apple on 2021/3/29.
//

#import "EmojPageView.h"
#import "BTPageView.h"
#import "UIView+BTViewTool.h"
#import "UIView+BTConstraint.h"
#import "UIColor+BTColor.h"


@interface EmojPageView()<BTPageViewDelegate,BTPageViewDataSource>

@property (nonatomic, strong) BTPageView * pageView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIPageControl * pageControll;

@end


@implementation EmojPageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    [self initPageView];
    [self initDataArray];
    return self;
}

- (void)initPageView{
    self.pageView = [[BTPageView alloc] initWithFrame:self.bounds];
    self.pageView.delegate = self;
    self.pageView.dataSource = self;
    [self addSubview:self.pageView];
}

- (void)initDataArray{
    self.dataArray = [NSMutableArray new];
    NSInteger totalNum = EmojHelp.share.row * EmojHelp.share.column;
    
    NSInteger pageNumber = EmojHelp.share.emojNames.count / totalNum;
    if (EmojHelp.share.emojNames.count % totalNum != 0) {
        pageNumber++;
    }
    
    for (int i=0; i<pageNumber; i++) {
        NSMutableArray * childArray = [NSMutableArray new];
        for (int j=0; i * totalNum + j<EmojHelp.share.emojNames.count; j++) {
            EmojModel * model = [EmojModel new];
            model.emojName = [NSString stringWithFormat:@"[%@]",EmojHelp.share.emojNames[i * totalNum + j]];
            model.imgName = [NSString stringWithFormat:@"d_%@",EmojHelp.share.imgNames[i * totalNum + j]];
            [childArray addObject:model];
            if (childArray.count == totalNum) {
                break;
            }
        }
        [self.dataArray addObject:childArray];
    }
    
    self.pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.BTHeight - 20, 300, 15)];
    [self addSubview:self.pageControll];
    [self.pageControll setBTCenterParentX];
    
    self.pageControll.numberOfPages = pageNumber;
    self.pageControll.pageIndicatorTintColor = UIColor.lightGrayColor;
    self.pageControll.currentPageIndicatorTintColor = BTTheme.mainColor;
//    self.pageControll.backgroundColor = UIColor.redColor;
    self.pageControll.currentPage = 0;
    self.pageControll.userInteractionEnabled = NO;
    
    
}

- (void)reloadData{
    [self.pageView reloadData];
}

#pragma mark BTPageViewDataSource
- (NSInteger)pageNumOfView:(BTPageView*)pageView{
    return self.dataArray.count;
}

- (UIView*)pageView:(BTPageView*)pageView contentViewForIndex:(NSInteger)index{
    EmojListView * listView = [[EmojListView alloc] initWithFrame:CGRectMake(0, 0, self.BTWidth, self.BTHeight - 10)];
    listView.dataArray = self.dataArray[index];
    listView.clickBlock = self.clickBlock;
    return listView;
}

//为空则不显示headView
- (BTPageHeadView*)pageViewHeadView:(BTPageView*)pageView{
    return nil;
}

- (void)pageView:(BTPageView *)pageView didShow:(NSInteger)index{
    self.pageControll.currentPage = index;
}

@end


@interface EmojListView()


@property (nonatomic, assign) CGSize cellSize;



@end



@implementation EmojListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.cellSize = CGSizeMake((self.BTWidth - 10) / EmojHelp.share.column, (self.BTHeight - 10) / EmojHelp.share.row);
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor bt_RGBSame:249];
    [self.collectionView registerClass:[EmojCell class] forCellWithReuseIdentifier:@"EmojCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [self addSubview:self.collectionView];
    
    return self;
}

#pragma mark uicollection delegate
//cell 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EmojCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"EmojCell"
                                                                          forIndexPath:indexPath];
    EmojModel * model = self.dataArray[indexPath.row];
    cell.emojImgView.image = [UIImage imageNamed:model.imgName];
    return cell;
}

//每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellSize;
}


//左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EmojModel * model = self.dataArray[indexPath.row];
    if (self.clickBlock) {
        self.clickBlock(model);
    }
}


@end

@implementation EmojCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.emojImgView = [UIImageView new];
    self.emojImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.emojImgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.emojImgView];
    [self.emojImgView bt_addToParentWithPadding:BTPaddingMake(5, -5, 5, -5)];
    return self;
}

@end
