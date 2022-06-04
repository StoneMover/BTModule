//
//  EmojHelp.m
//  mingZhong
//
//  Created by apple on 2021/3/29.
//

#import "EmojHelp.h"
#import "BTUtils.h"
#import "EmojTextAttachment.h"

static EmojHelp * help = nil;

@interface EmojHelp()


@end


@implementation EmojHelp

+ (instancetype)share{
    if (help == nil) {
        help = [EmojHelp new];
    }
    
    return help;
}

- (instancetype)init{
    self = [super init];
    [self initDict];
    return self;
}

- (void)initDict{
    _emojNames = @[
        @"呵呵",
        @"嘻嘻",
        @"哈哈",
        @"机智",
        @"失智",
        @"抠鼻",
        @"吃惊",
        @"晕",
        @"泪",
        @"抓狂",
        @"哼",
        @"可爱",
        @"怒",
        @"汗",
        @"害羞",
        @"睡觉",
        @"偷笑",
        @"酷",
        @"闭嘴",
        @"鄙视",
        @"花⼼",
        @"⿎掌",
        @"悲伤",
        @"亲亲",
        @"怒骂",
        @"懒得理你",
        @"右哼哼",
        @"嘘",
        @"委屈",
        @"吐",
        @"可怜",
        @"打哈⽓",
        @"挤眼",
        @"失望",
        @"疑问",
        @"困",
        @"拜拜",
        @"阴险",
        @"傻眼",
        @"顶",
        @"玫瑰",
        @"剪⼑⼿",
        @"拜拳",
        @"ok",
        @"勾引",
        @"拥抱",
        @"拳头",
        @"凋谢",
        @"藐视",
        @"握⼿",
        @"爱⼼",
        @"亲吻",
        @"⼼碎",
        @"⻄⽠",
        @"地雷",
        @"猪头",
        @"月亮",
        @"幽灵",
        @"旅行",
        @"强壮",
        @"啤酒",
        @"礼物",
        @"开心",
        @"咖啡",
        @"红包",
        @"福到",
        @"发抖",
        @"捂脸",
        @"耶",
        @"惊讶",
        @"嘿哈",
        @"蛋糕",
        @"大叫",
        @"发",
        @"大便",
        @"彩桶",
        @"菜刀",
        @"拜托",
        @"太阳",
        @"起舞"
    ];
    
    _imgNames = @[
        @"hehe",
        @"xixi",
        @"haha",
        @"jizhi",
        @"shizhi",
        @"wabishi",
        @"chijing",
        @"yun",
        @"lei",
        @"zhuakuang",
        @"heng",
        @"keai",
        @"nu",
        @"han",
        @"haixiu",
        @"shuijiao",
        @"touxiao",
        @"ku",
        @"bizui",
        @"bishi",
        @"huaxin",
        @"guzhang",
        @"beishang",
        @"qinqin",
        @"numa",
        @"landelini",
        @"youhengheng",
        @"xu",
        @"weiqu",
        @"tu",
        @"kelian",
        @"dahaqi",
        @"jiyan",
        @"shiwang",
        @"yiwen",
        @"kun",
        @"baibai",
        @"yinxian",
        @"shayan",
        @"ding",
        @"meigui",
        @"jiandaoshou",
        @"baiquan",
        @"ok",
        @"gouyin",
        @"baobao",
        @"dingding",
        @"diaoxie",
        @"xiading",
        @"woshou",
        @"hongxin",
        @"qinwen",
        @"xinsui",
        @"xigua",
        @"dilei",
        @"zhutou",
        @"yueliang",
        @"youling",
        @"travel",
        @"qiangzhuang",
        @"pijiu",
        @"liwu",
        @"kaixin",
        @"kafei",
        @"hongbao",
        @"fudao",
        @"fadou",
        @"wulian",
        @"emoji_ye",
        @"emoji_jingya",
        @"emoji_heiha",
        @"dangao",
        @"dajiao",
        @"dafa",
        @"dabian",
        @"caitong",
        @"caidao",
        @"baituo",
        @"taiyang",
        @"qiwu"
    ];
    
    
    
    
    
    
    _column = 8;
    _row = 4;
}

- (NSString*)getImgName:(NSString*)emoj{
    emoj = [emoj stringByReplacingOccurrencesOfString:@"[" withString:@""];
    emoj = [emoj stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSInteger index = [self.emojNames indexOfObject:emoj];
    return [NSString stringWithFormat:@"d_%@",self.imgNames[index]];
}

- (BOOL)isEmojStr:(NSString*)emojStr{
    emojStr = [emojStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
    emojStr = [emojStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
    if ([self.emojNames containsObject:emojStr]) {
        return YES;
    }
    
    return NO;
}

+ (NSMutableAttributedString*)emojData:(NSString*)str{
    if (![str containsString:@"["] && ![str containsString:@"]"]) {
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:str];
        return attributed;
    }
    NSMutableArray * dataArray = [NSMutableArray new];
    NSInteger j = 0;
    while (j < str.length) {
        NSInteger startIndex = -1;
        NSInteger endIndex = -1;
        for (NSInteger i=j; i<str.length; i++) {
            NSString * oneStr = [str substringWithRange:NSMakeRange(i, 1)];
            
            if (startIndex == -1 && [oneStr isEqualToString:@"["]) {
                startIndex = i;
            }
            
            if (endIndex == -1 && startIndex != -1 && [oneStr isEqualToString:@"]"]) {
                endIndex = i;
            }
            
            if (startIndex != -1 && endIndex != -1) {
                NSRange range = NSMakeRange(startIndex, endIndex - startIndex + 1);
                NSString * emoj = [str substringWithRange:range];
                if ([EmojHelp.share isEmojStr:emoj]) {
//                    NSLog(@"表情:%@",emoj);
                    str = [str stringByReplacingCharactersInRange:range withString:@""];
                    EmojModel * model = [EmojModel new];
                    model.location = startIndex + dataArray.count;
                    model.emojName = emoj;
                    model.imgName = [EmojHelp.share getImgName:emoj];
                    [dataArray addObject:model];
                    j = startIndex - 1;
                }else{
//                    NSLog(@"冒充表情:%@",emoj);
                    j = endIndex;
                }
                break;
            }
        }
        
        j++;
    }
    
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:str];
    for (EmojModel * emojModel in dataArray) {
        EmojTextAttachment *attach = [[EmojTextAttachment alloc] init];
        UIImage * eomjImg = [UIImage imageNamed:emojModel.imgName];
        attach.emojName = emojModel.emojName;
        attach.image = eomjImg;//设置图片
//        attach.image = [UIImage bt_imageWithColor:UIColor.redColor equalSize:48];
        UIFont * font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        CGFloat height = font.lineHeight + 4;
        CGFloat width = height / eomjImg.size.height * eomjImg.size.width;
        attach.bounds = CGRectMake(0, font.descender - 2, width, height); //设置图片大小、位置
        NSAttributedString * imgAttributedString = [NSAttributedString attributedStringWithAttachment:attach];
        [attributed insertAttributedString:imgAttributedString atIndex:emojModel.location];
    }
    
    
    return attributed;
}

@end


@implementation EmojModel



@end



