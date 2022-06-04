//
//  LiveChatEmojInputView.h
//  mingZhong
//
//  Created by apple on 2021/3/29.
//

#import <UIKit/UIKit.h>
#import "BTTextView.h"
#import "EmojPageView.h"

NS_ASSUME_NONNULL_BEGIN

@class LiveChatEmojInputView;

static const CGFloat toolViewHeight = 53;

static const CGFloat emojViewHeight = 240;

@interface LiveChatEmojInputView : UIView

+ (instancetype)share;

@property (nonatomic, strong) UIButton * emojBtn;

@property (nonatomic, strong) BTTextView * textView;


@property (nonatomic, strong) UIButton * sendBtn;

@property (nonatomic, copy) void(^heightChangeBlock)(CGFloat height);

@property (nonatomic, strong) EmojPageView * emojView;

- (void)initEmojView;

- (void)resetTextViewLastRang;

@end

NS_ASSUME_NONNULL_END
