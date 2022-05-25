//
//  BTGridImgView.h
//  word
//
//  Created by liao on 2019/12/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTGridImgViewDelegate <NSObject>

@optional

- (void)BTGridImgViewClick:(NSInteger)index;

- (void)BTGridImgAddClick;

- (void)BTGridImgLongPress:(NSInteger)index;

- (void)BTGridLoadImg:(NSInteger)index imgView:(UIImageView*)imgView;

- (void)BTGridImgDeleteClickWithIndex:(NSInteger)index;

@end

@interface BTGridImgView : UIView

//数据可以为UIimage对象，也可以为任意类型，如果不是UIimage对象则需要实现BTGridLoadImg代理自己进行赋值
@property (nonatomic, strong) NSMutableArray * dataArray;

//有多少列
@property (nonatomic, assign) NSInteger line;

//上下左右的间距
@property (nonatomic, assign) CGFloat space;

//允许显示的最大图片数量
@property (nonatomic, assign) NSInteger maxNumber;

//加号图片
@property (nonatomic, strong) UIImage * addImg;

//容器的高度，实时计算
@property (nonatomic, assign,readonly) CGFloat contentHeight;

///0:左上角，1：右上角、2左下角，3右下角
@property (nonatomic, assign) NSInteger deleteBtnLocation;

///删除按钮大小
@property (nonatomic, assign) CGSize deleteBtnSize;

///内容的距离父view的间距是多少，默认为0
@property (nonatomic, assign) UIEdgeInsets contentInsets;

///删除按钮的内容
@property (nonatomic, strong) UIImage * deleteBtnImg;

@property (nonatomic, weak) id<BTGridImgViewDelegate> delegate;

///自定义的cell的宽度，如果只需要单行显示可设置该值，设置后宽度将以此值为基础
@property (nonatomic, assign) CGFloat customeWidth;


- (void)reloadData;

- (void)removeDataAtIndex:(NSInteger)index;

@end



@interface BTGridImgViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imgViewContent;

@property (nonatomic, strong) UIButton * deleteBtn;

///0:左上角，1：右上角、2左下角，3右下角
@property (nonatomic, assign) NSInteger deleteBtnLocation;

///删除按钮大小
@property (nonatomic, assign) CGSize deleteBtnSize;

///内容的距离父view的间距是多少，默认为0
@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, copy) void(^longPressBlock) (void);

@property (nonatomic, copy) void(^deleteClickBlock) (void);

@end



