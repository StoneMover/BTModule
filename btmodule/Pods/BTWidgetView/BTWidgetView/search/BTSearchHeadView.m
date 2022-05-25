//
//  BTSearchHeadView.m
//  BTWidgetViewExample
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 stone. All rights reserved.
//

#import "BTSearchHeadView.h"
#import <BTHelp/UIView+BTViewTool.h>
#import "BTWidgetView.h"
#import <BTHelp/UIColor+BTColor.h>
#import <BTHelp/BTUtils.h>
#import <BTHelp/UIFont+BTFont.h>

@interface BTSearchHeadView()<UITextFieldDelegate>

@end


@implementation BTSearchHeadView

- (instancetype)initNavHead{
    self = [super initWithFrame:CGRectMake(0, 0, BTUtils.SCREEN_W, BTUtils.NAV_HEIGHT)];
    [self initSelf];
    return self;
}

- (instancetype)initDefaultHead{
    self = [super initWithFrame:CGRectMake(0, 0, BTUtils.SCREEN_W, 44)];
    [self initSelf];
    return self;
}

- (void)initSelf{
    self.backgroundColor = UIColor.whiteColor;
    self.iconImgLeftPadding = 8;
    self.textFieldSearchRightPadding = 2;
    self.textFieldSearchLeftPadding = 2;
    
    self.btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(self.BTWidth - 60, 0, 60, self.BTHeight)];
    [self.btnCancel setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    self.btnCancel.titleLabel.font = [UIFont BTAutoFontWithSize:14 weight:UIFontWeightMedium];
    [self.btnCancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewBgColor = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 0, 32)];
    self.viewBgColor.backgroundColor = [UIColor bt_R:239 G:239 B:241];
    
    self.imgSearchIcon = [[UIImageView alloc] initBTViewWithEqualSize:28];
    self.imgSearchIcon.BTLeft = self.viewBgColor.BTLeft + 8;
    self.imgSearchIcon.image = [BTWidgetView imageBundleName:@"bt_search_icon"];
//    self.imgSearchIcon.contentMode = UIViewContentModeCenter;
    
    self.viewLine = [[BTLineView alloc] initBTViewWithSize:CGSizeMake(self.BTWidth, 1)];
    self.viewLine.lineWidth = .5;
    self.viewLine.aligntMent = BTLineViewAlignmentBottom;
    self.viewLine.color = UIColor.lightGrayColor;
    
    
    self.textFieldSearch = [[BTTextField alloc] init];
    self.textFieldSearch.returnKeyType = UIReturnKeySearch;
    self.textFieldSearch.placeholder = @"请输入搜索内容";
    self.textFieldSearch.delegate = self;
    self.textFieldSearch.font = [UIFont BTAutoFontWithSize:14 weight:UIFontWeightMedium];
    self.textFieldSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textFieldSearch.maxContent = 20;
    [self.textFieldSearch addDoneView];
    
    [self bt_addSubViewArray:@[self.btnCancel,self.viewBgColor,self.imgSearchIcon,self.viewLine,self.textFieldSearch]];
}



- (void)layoutSubviews{
    if (self.layoutBlock) {
        self.layoutBlock(self);
        return;
    }
    
    self.viewLine.frame = CGRectMake(0, self.BTHeight - 1, self.BTWidth, 1);
    
    self.btnCancel.BTRight = self.BTWidth;
    [self.btnCancel setBTCenterParentY];
    
    self.viewBgColor.BTCorner = self.viewBgColor.BTHeight / 2.0;
    if (self.btnCancel.isHidden) {
        [self.viewBgColor setBTWidth:self.BTWidth - self.viewBgColor.BTLeft];
    }else{
        [self.viewBgColor setBTWidth:self.btnCancel.BTLeft - self.viewBgColor.BTLeft];
    }
    [self.viewBgColor setBTCenterParentY];
    
    
    [self.imgSearchIcon sizeToFit];
    self.imgSearchIcon.BTLeft = self.viewBgColor.BTLeft + self.iconImgLeftPadding;
    self.imgSearchIcon.BTCenterY = self.viewBgColor.BTCenterY;
    
    self.textFieldSearch.frame = CGRectMake(self.imgSearchIcon.BTRight + self.textFieldSearchLeftPadding,
                                            self.viewBgColor.BTTop,
                                            self.viewBgColor.BTRight - self.imgSearchIcon.BTRight - self.textFieldSearchLeftPadding - self.textFieldSearchRightPadding,
                                            self.viewBgColor.BTHeight);

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.searchClick) {
        self.searchClick(self.textFieldSearch.text);
    }
    if (self.isSearchClickEmptyTextField) {
        self.textFieldSearch.text=@"";
    }
    return YES;
}


- (void)cancelClick{
    if (self.cancelClickBlock) {
        self.cancelClickBlock();
    }
}

@end
