//
//  BTTextInputView.m
//  word
//
//  Created by stonemover on 2019/3/17.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTTextInputView.h"
#import <BTHelp/UIView+BTViewTool.h>
#import <BTHelp/BTUtils.h>
#import "BTWidgetView.h"
#import "UIView+BTEasyDialog.h"
#import <BTHelp/UIColor+BTColor.h>
#import <BTHelp/UIFont+BTFont.h>

@interface BTTextInputView()

@property (nonatomic, assign) CGFloat basicHeight;

@property (nonatomic, assign) CGFloat keyboardH;

@end

@implementation BTTextInputView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self initSelf];
    return self;
}

- (void)initSelf{
    self.basicHeight=56;
    [self addKeyBoardNofication];
    self.toolView=[[BTTextInputToolView alloc] initWithFrame:CGRectMake(0, self.BTHeight-self.basicHeight, self.BTWidth, self.basicHeight) type:BTTextInputViewTypeSimple];
    self.toolView.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.toolView];
    
    __weak BTTextInputView * weakSelf=self;
    self.toolView.textView.blockHeightChange = ^(CGFloat height) {
        CGFloat h=height+20;
        if (h<weakSelf.basicHeight) {
            h=weakSelf.basicHeight;
        }
        if (h>120) {
            h=120;
            //保持内容显示在最底部
            [weakSelf.toolView.textView setContentOffset:CGPointMake(0, weakSelf.toolView.textView.contentSize.height - weakSelf.toolView.textView.BTHeight) animated:YES];
        }
        weakSelf.toolView.BTHeight=h;
        [weakSelf.toolView layoutSubviews];
        weakSelf.toolView.BTBottom=[UIScreen mainScreen].bounds.size.height-weakSelf.keyboardH;
    };
    
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.toolView.textView endEditing:YES];
}

- (void)show:(UIView*)view{
    if ([self superview]) {
        [self removeFromSuperview];
    }
    
    [view addSubview:self];
    [self.toolView.textView becomeFirstResponder];
}




#pragma mark 键盘广播
//添加键盘监听通知
-(void)addKeyBoardNofication{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


//当键盘消失的时候调用
- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView animateWithDuration:.2 animations:^{
        self.toolView.BTBottom=[UIScreen mainScreen].bounds.size.height+self.toolView.BTHeight;
        //        self.rootView.alpha=0;
    } completion:^(BOOL finished) {
        self.toolView.hidden=YES;
        self.toolView.alpha=1;
        [self removeFromSuperview];
    }];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.keyboardH= keyboardRect.size.height;
    
    self.toolView.hidden=NO;
    [UIView animateWithDuration:.25 animations:^{
        self.toolView.BTBottom=[UIScreen mainScreen].bounds.size.height-self.keyboardH;
    } completion:^(BOOL finished) {
    }];
}



@end



@interface BTTextInputToolView()

@property (nonatomic, assign) CGFloat basicHeight;

@property (nonatomic, assign) BTTextInputToolType type;

//0:文字，1:语音
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) CGFloat startY;

@property (nonatomic, assign) BOOL isCancel;

//上次的内容高度
@property (nonatomic, assign) CGFloat lastHeight;

//按住说话按钮
@property (nonatomic, strong) UIButton * btnPressVoice;

@end



@implementation BTTextInputToolView

- (instancetype)initWithFrame:(CGRect)frame type:(BTTextInputToolType)type{
    self = [super initWithFrame:frame];
    self.type = type;
    self.basicHeight = frame.size.height;
    [self initSelf];
    self.lastHeight = self.basicHeight;
    return self;
}




- (void)initSelf{
    UIView * viewLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.BTWidth, .5)];
    viewLine.backgroundColor=[UIColor bt_RGBSame:235];
    [self addSubview:viewLine];
    
    //语音按钮
    _btnVoice = [[UIButton alloc] initBTViewWithSize:CGSizeMake(55, 55)];
    [self addSubview:self.btnVoice];
    [self.btnVoice addTarget:self action:@selector(statusClick) forControlEvents:UIControlEventTouchUpInside];
    
    //发送按钮
    _btnCommit=[[UIButton alloc] initBTViewWithSize:CGSizeMake(55, 55)];
    [self.btnCommit addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCommit setTitle:@"发布" forState:UIControlStateNormal];
    [self.btnCommit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btnCommit.titleLabel.font=[UIFont BTAutoFontWithSize:16 weight:UIFontWeightSemibold];
    [self addSubview:self.btnCommit];
    
    //输入框
    _textView=[[BTTextView alloc] initBTViewWithSize:CGSizeMake(100, self.basicHeight-20)];
    [self.textView setTextContainerInset:UIEdgeInsetsMake(8, 5, 8, 5)];
    self.textView.font=[UIFont BTAutoFontWithSize:16];
    self.textView.textColor=[UIColor bt_R:74 G:76 B:95];
    self.textView.BTCorner=5;
    self.textView.BTBorderColor=[UIColor bt_RGBSame:234];
    self.textView.BTBorderWidth=.5;
    self.textView.placeHolderColor=[UIColor bt_RGBSame:198];
    self.textView.placeHolder=@"请输入评论";
    self.textView.maxStrNum=140;
    self.textView.blockMax = ^{
        
    };
    __weak BTTextInputToolView * weakSelf=self;
    self.textView.blockContentChange = ^{
        if (weakSelf.textView.text.length==0||![weakSelf.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
            [weakSelf.btnCommit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            [weakSelf.btnCommit setTitleColor:weakSelf.commitColor?weakSelf.commitColor:UIColor.redColor forState:UIControlStateNormal];
        }
    };
    
    //按下说话按钮
    self.btnPressVoice = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnPressVoice.frame = self.textView.frame;
    self.btnPressVoice.BTBorderWidth = 0.5;
    self.btnPressVoice.BTBorderColor = [UIColor lightGrayColor];
    self.btnPressVoice.BTCorner = 5;
    [self.btnPressVoice setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.btnPressVoice setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    self.btnPressVoice.titleLabel.font = [UIFont BTAutoFontWithSize:14 weight:UIFontWeightMedium];
    self.btnPressVoice.enabled = NO;
    self.btnPressVoice.hidden = YES;
    
    [self addSubview:self.textView];
    [self addSubview:self.btnPressVoice];
    
    //表情按钮
    _btnEmoj = [[UIButton alloc] initBTViewWithSize:CGSizeMake(55, 55)];
    [self.btnEmoj setTitle:@"表情" forState:UIControlStateNormal];
    [self.btnEmoj setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btnEmoj.titleLabel.font=[UIFont BTAutoFontWithSize:16 weight:UIFontWeightSemibold];
    [self addSubview:self.btnEmoj];
    
    //更多按钮
    _btnMore = [[UIButton alloc] initBTViewWithSize:CGSizeMake(55, 55)];
    [self.btnMore setTitle:@"更多" forState:UIControlStateNormal];
    [self.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.btnMore.titleLabel.font=[UIFont BTAutoFontWithSize:16 weight:UIFontWeightSemibold];
    [self addSubview:self.btnMore];
    
    switch (self.type) {
        case BTTextInputViewTypeSimple:
        {
            self.btnVoice.hidden = YES;
            self.btnMore.hidden = YES;
            self.btnEmoj.hidden = YES;
        }
            break;
        case BTTextInputViewTypeVoice:
        {
            self.btnMore.hidden = YES;
            self.btnEmoj.hidden = YES;
            break;
        }
        case BTTextInputViewTypeAll:
        {
            
            break;
        }
    }
}

//布局顺序为微信输入框顺序，语音按钮-输入框-表情-更多-发送，如果控件为隐藏则从中间移除
- (void)layoutSubviews{
    CGFloat x = 0;
    CGFloat textViewW = self.BTWidth - 15;
    if (!self.btnVoice.isHidden) {
        textViewW -= self.btnVoice.BTWidth;
    }
    
    if (!self.btnEmoj.isHidden) {
        textViewW -= self.btnEmoj.BTWidth;
    }
    
    if (!self.btnMore.isHidden) {
        textViewW -= self.btnMore.BTWidth;
    }
    
    if (!self.btnCommit.isHidden) {
        textViewW -= self.btnCommit.BTWidth;
    }
    
    
    if (!self.btnVoice.isHidden) {
        self.btnVoice.BTLeft = x;
        x = self.btnVoice.BTRight;
    }
    if (x == 0) {
        x = 15;
    }else{
        textViewW += 15;
    }
    self.textView.frame=CGRectMake(x, 10, textViewW, self.BTHeight-20);
    x = self.textView.BTRight;
    
    if (!self.btnEmoj.isHidden) {
        self.btnEmoj.BTLeft = x;
        x = self.btnEmoj.BTRight;
    }
    
    if (!self.btnMore.isHidden) {
        self.btnMore.BTLeft = x;
        x = self.btnMore.BTRight;
    }
    
    if (!self.btnCommit.isHidden) {
        self.btnCommit.BTLeft = x;
        x = self.btnCommit.BTRight;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.status == 0) {
        return;
    }
    [self.btnPressVoice setTitle:@"上滑取消" forState:UIControlStateNormal];
    self.isCancel = NO;
    self.startY=0;
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.startY = point.y;
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTTextInputToolViewStart:)]) {
        [self.delegate BTTextInputToolViewStart:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.status == 0) {
        return;
    }
    
    UITouch * touch=[touches anyObject];
    CGPoint point = [touch  locationInView:self];
    BOOL isCancel = NO;
    if (self.startY - point.y > 100) {
        isCancel = YES;
    }
    
    if (self.isCancel != isCancel) {
        self.isCancel = isCancel;
        if (self.isCancel) {
            [self.btnPressVoice setTitle:@"松开取消" forState:UIControlStateNormal];
        }else{
            [self.btnPressVoice setTitle:@"上滑取消" forState:UIControlStateNormal];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(BTTextInputToolViewStatus:isCancel:)]) {
            [self.delegate BTTextInputToolViewStatus:self isCancel:isCancel];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.btnPressVoice setTitle:@"按住说话" forState:UIControlStateNormal];
    if (self.status == 1 && self.delegate && [self.delegate respondsToSelector:@selector(BTTextInputToolViewEnd:)]) {
        [self.delegate BTTextInputToolViewEnd:self];
    }
    
}

- (void)statusClick{
    if (self.status == 0) {
        self.status = 1;
    }else{
        self.status = 0;
    }
    self.btnPressVoice.frame = self.textView.frame;
    if (self.status == 0) {
        [self.btnVoice setImage:self.voiceImg forState:UIControlStateNormal];
        self.btnPressVoice.hidden = YES;
        self.textView.hidden = NO;
        self.BTHeight = self.lastHeight;
        if (self.delegate && [self.delegate respondsToSelector:@selector(BTTextInputToolViewChangeToText:)]) {
            [self.delegate BTTextInputToolViewChangeToText:self];
        }
    }else{
        self.lastHeight = self.BTHeight;
        self.BTHeight = self.basicHeight;
        [self.btnVoice setImage:self.keyboardImg forState:UIControlStateNormal];
        self.btnPressVoice.hidden = NO;
        self.textView.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(BTTextInputToolViewChangeToVoice:)]) {
            [self.delegate BTTextInputToolViewChangeToVoice:self];
        }
    }
}


- (void)saveClick{
    if (self.textView.text.length==0) {
        return;
    }
    
    
    //全部为空格
    if(![self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        return;
    }
    
    
    if (self.sendClickBlock) {
        self.sendClickBlock();
    }
}


- (void)setDefaultStatus{
    self.status = 1;
    [self statusClick];
}

@end
