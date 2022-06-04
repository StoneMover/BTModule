//
//  LiveChatEmojInputView.m
//  mingZhong
//
//  Created by apple on 2021/3/29.
//

#import "LiveChatEmojInputView.h"
//#import <BTHelp/UIView+BTViewTool.h>
//#import <BTHelp/BTUtils.h>
//#import <BTHelp/UIColor+BTColor.h>
#import "BlockUI.h"
#import "EmojTextAttachment.h"

@interface LiveChatEmojInputView ()<UITextViewDelegate>

@property (nonatomic, assign) NSRange textViewLastRang;

@property (nonatomic, strong) NSDictionary * typingAttributes;

@property (nonatomic, assign) CGFloat textViewHgight;

@end


@implementation LiveChatEmojInputView

+ (instancetype)share{
    static LiveChatEmojInputView * inputView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inputView = [LiveChatEmojInputView new];
    });
    return inputView;
}

#pragma mark 生命周期
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.whiteColor;
    [self initBtns];
    [self initTextView];
    return self;
}

- (void)layoutSubviews{
    self.textView.BTLeft = self.emojBtn.BTRight;
    self.textView.BTTop = 9.5;
    
    self.emojBtn.BTBottom = self.textView.BTBottom + 7.5;
    
    
    self.sendBtn.BTLeft = self.textView.BTRight + 15;
    self.sendBtn.BTBottom = self.textView.BTBottom - 2;
    
    self.emojView.BTTop = self.textView.BTBottom + 9.5;
}


#pragma mark 初始化
- (void)initBtns{
    self.emojBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, toolViewHeight)];
    [self.emojBtn setImage:[UIImage imageNamed:@"live_chat_emoj"] forState:UIControlStateNormal];
    
    
    self.sendBtn= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 33)];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.sendBtn.BTCorner = 4;
    [self.sendBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = BTTheme.mainColor;
    
    [self bt_addSubViewArray:@[self.emojBtn,self.sendBtn]];
}

- (void)initTextView{
    __weak LiveChatEmojInputView * weakSelf=self;
    self.textViewHgight = 19 + [UIFont systemFontOfSize:17].lineHeight;
    CGFloat width = self.BTWidth - self.emojBtn.BTWidth - self.sendBtn.BTWidth - 30;
    self.textView = [[BTTextView alloc] initWithFrame:CGRectMake(0, 0, width, self.textViewHgight)];
//    self.textView.BTBorderWidth = 0.5;
    self.textView.BTCorner = 3;
    self.textView.cursorSize = CGSizeMake(2, 22);
//    self.textView.BTBorderColor= [UIColor bt_RGBSame:227];
    self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.placeHolderColor = [UIColor bt_RGBSame:102];
//    self.textView.placeHolder = @"我要评论...";
    self.textView.allowsEditingTextAttributes = YES;
    self.typingAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17]
                                  ,NSForegroundColorAttributeName:[UIColor bt_RGBSame:51]};
    self.textView.typingAttributes = self.typingAttributes;
    self.textView.textContainerInset=UIEdgeInsetsMake(8.5, 4, 8.5, 4);
    self.textView.blockEndEdit = ^{
        weakSelf.textViewLastRang = weakSelf.textView.selectedRange;
        NSLog(@"结束位置:%ld",weakSelf.textViewLastRang.location);
    };
    self.textView.delegate = self;
    self.textView.blockHeightChange = ^(CGFloat height) {
        
        if (height < 38) {
            height = 38;
        }
        
        if (height > 66) {
            height = 70;
//            NSRange range = weakSelf.textView.selectedRange;
//            NSInteger length = weakSelf.textView.text.length;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"执行对齐");
                [weakSelf.textView setContentOffset:CGPointMake(0, weakSelf.textView.contentSize.height - weakSelf.textView.BTHeight) animated:NO];
            });
            
            
        }
        NSLog(@"输入框高度:%f",height);
        if (weakSelf.textView.BTHeight == height) {
            NSLog(@"输入框高度与上次相同");
            return;
        }
        weakSelf.textView.BTHeight = height;
        weakSelf.BTHeight = height + 19 + emojViewHeight + BTUtils.HOME_INDICATOR_HEIGHT;
        
        if (weakSelf.heightChangeBlock) {
            weakSelf.heightChangeBlock(weakSelf.BTHeight);
        }
    };
    [self addSubview:self.textView];
}

- (void)initEmojView{
    if (self.emojView) {
        return;
    }
    __weak LiveChatEmojInputView * weakSelf=self;
    self.emojView = [[EmojPageView alloc] initWithFrame:CGRectMake(0, 0, BTUtils.SCREEN_W, 240)];
    self.emojView.hidden = YES;
    self.emojView.clickBlock = ^(EmojModel * _Nonnull model) {
        [weakSelf addEmojData:model];
    };
    [self.emojView reloadData];
    [self addSubview:self.emojView];
}


#pragma mark 点击事件

#pragma mark 相关方法
- (void)resetTextViewLastRang{
    self.textViewLastRang = self.textView.selectedRange;
}

- (void)addEmojData:(EmojModel*)model{
    [self.textView hidePlaceholder];
    NSLog(@"输入表情:%@",model.emojName);
    EmojTextAttachment *attach = [[EmojTextAttachment alloc] init];
    UIImage * eomjImg = [UIImage imageNamed:model.imgName];
    attach.emojName = model.emojName;
    attach.image = eomjImg;//设置图片
    CGFloat height = [UIFont systemFontOfSize:17].lineHeight;
    CGFloat width = height / eomjImg.size.height * eomjImg.size.width;
    attach.bounds = CGRectMake(0, -4, width, height); //设置图片大小、位置
    
    NSAttributedString * imgAttributedString = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedString insertAttributedString:imgAttributedString atIndex:self.textViewLastRang.location];
    self.textView.attributedText = attributedString;
    self.textViewLastRang = NSMakeRange(self.textViewLastRang.location + 1, 0);
    
    [self.textView scrollRangeToVisible:self.textViewLastRang];
}





#pragma mark 网络请求

#pragma mark TextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    textView.typingAttributes = self.typingAttributes;
    return YES;
}

@end
