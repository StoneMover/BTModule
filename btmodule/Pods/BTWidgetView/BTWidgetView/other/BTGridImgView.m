//
//  BTGridImgView.m
//  word
//
//  Created by liao on 2019/12/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTGridImgView.h"
#import <BTHelp/UIView+BTViewTool.h>

@interface BTGridImgView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@end


@implementation BTGridImgView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSelf];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initSelf];
    return self;
}

- (void)initSelf{
    self.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.space = 10;
    self.line = 3;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.collectionView registerClass:[BTGridImgViewCell class] forCellWithReuseIdentifier:@"BTGridImgViewCellId"];
    self.collectionView.scrollEnabled = NO;
}

- (void)layoutSubviews{
    self.collectionView.frame = self.bounds;
}

#pragma mark uicollection delegate
//cell 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArray.count == self.maxNumber) {
        return  self.dataArray.count;
    }
    return self.dataArray.count+1;
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak BTGridImgView * weakSelf=self;
    BTGridImgViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BTGridImgViewCellId"
                                                                          forIndexPath:indexPath];
    if (indexPath.row == self.dataArray.count) {
        cell.imgViewContent.image = self.addImg;
        cell.deleteBtn.hidden = YES;
    }else{
        NSObject * objc = self.dataArray[indexPath.row];
        if (self.deleteBtnImg) {
            cell.deleteBtn.hidden = NO;
            cell.deleteBtnSize = self.deleteBtnSize;
            [cell.deleteBtn setImage:self.deleteBtnImg forState:UIControlStateNormal];
            cell.deleteClickBlock = ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(BTGridImgDeleteClickWithIndex:)]) {
                    [weakSelf.delegate BTGridImgDeleteClickWithIndex:indexPath.row];
                }
            };
        }else{
            cell.deleteBtn.hidden = YES;
        }
        
        if ([objc isKindOfClass:[UIImage class]]) {
            cell.imgViewContent.image  = self.dataArray[indexPath.row];
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(BTGridLoadImg:imgView:)]) {
                [self.delegate BTGridLoadImg:indexPath.row imgView:cell.imgViewContent];
            }
        }
        
    }
    cell.contentInsets = self.contentInsets;
    cell.deleteBtnLocation = self.deleteBtnLocation;
    cell.longPressBlock = ^{
        if (weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(BTGridImgLongPress:)]&&indexPath.row!=weakSelf.dataArray.count) {
            [weakSelf.delegate BTGridImgLongPress:indexPath.row];
        }
    };
    return cell;
}

//每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [self cellWidth];
    CGFloat height = width;
    return CGSizeMake(width, height);
}


//左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.space;
}

//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.space;
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        if (indexPath.row == self.dataArray.count&&[self.delegate respondsToSelector:@selector(BTGridImgAddClick)]) {
            [self.delegate BTGridImgAddClick];
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(BTGridImgViewClick:)]) {
            [self.delegate BTGridImgViewClick:indexPath.row];
        }
    }
}


- (CGFloat)contentHeight{
    if (self.dataArray.count==0) {
        return [self cellWidth];
    }
    NSInteger line = 0;
    NSInteger totalDataNum = self.dataArray.count;
    if (self.dataArray.count != self.maxNumber) {
        totalDataNum++;
    }
    if (totalDataNum % self.line ==0) {
        line = totalDataNum / self.line;
    }else{
        line = totalDataNum / self.line +1;
    }
    
    return [self cellWidth]*line + self.space*(line-1);
}

- (CGFloat)cellWidth{
    if (self.customeWidth != 0) {
        return self.customeWidth;
    }
    CGFloat width = (self.BTWidth - (self.line-1)*self.space)/self.line;
    return width;
}

- (void)setDataArray:(NSMutableArray*)dataArray{
    _dataArray = dataArray;
}

- (void)reloadData{
    [self.collectionView reloadData];
}

- (void)removeDataAtIndex:(NSInteger)index{
    [self.dataArray removeObjectAtIndex:index];
    [self reloadData];
}


@end


@implementation BTGridImgViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initSelf];
    return  self;
}


- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
    }
}

- (void)deleteClick{
    if (self.deleteClickBlock) {
        self.deleteClickBlock();
    }
}

- (void)initSelf{
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    
    self.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.imgViewContent = [UIImageView new];
    self.imgViewContent.contentMode = UIViewContentModeScaleAspectFill;
    self.imgViewContent.clipsToBounds = YES;
    [self addSubview:self.imgViewContent];
    
    self.deleteBtn = [UIButton new];
    [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
    
    
}

- (void)layoutSubviews{
    self.imgViewContent.frame = CGRectMake(self.contentInsets.left,
                                           self.contentInsets.top,
                                           self.BTWidth - self.contentInsets.left - self.contentInsets.right,
                                           self.BTHeight - self.contentInsets.top - self.contentInsets.bottom);
    if (self.deleteBtn.isHidden){
        return;
    }
    switch (self.deleteBtnLocation) {
        case 0:
        {
            self.deleteBtn.frame = CGRectMake(0,
                                              0,
                                              self.deleteBtnSize.width,
                                              self.deleteBtnSize.height);
        }
            break;
        case 1:
        {
            self.deleteBtn.frame = CGRectMake(self.BTWidth - self.deleteBtnSize.width,
                                              0,
                                              self.deleteBtnSize.width,
                                              self.deleteBtnSize.height);
        }
            break;
        case 2:
        {
            self.deleteBtn.frame = CGRectMake(0,
                                              self.BTHeight - self.deleteBtnSize.height,
                                              self.deleteBtnSize.width,
                                              self.deleteBtnSize.height);
        }
            break;
        case 3:
        {
            self.deleteBtn.frame = CGRectMake(self.BTWidth - self.deleteBtnSize.width,
                                              self.BTHeight - self.deleteBtnSize.height,
                                              self.deleteBtnSize.width,
                                              self.deleteBtnSize.height);
        }
            break;
    }
}

@end

