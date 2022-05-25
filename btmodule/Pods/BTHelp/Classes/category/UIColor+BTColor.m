//
//  UIColor+BTColor.m
//  BTHelpExample
//
//  Created by apple on 2020/6/28.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import "UIColor+BTColor.h"
#import "BTTheme.h"

@implementation UIColor (BTColor)

+ (UIColor*)bt_R:(CGFloat)R G:(CGFloat)G B:(CGFloat)B{
    return [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1];
}

+ (UIColor*)bt_RGBSame:(CGFloat)value{
    return [UIColor colorWithRed:(value)/255.0 green:(value)/255.0 blue:(value)/255.0 alpha:1];
}

+ (UIColor*)bt_R:(CGFloat)R G:(CGFloat)G B:(CGFloat)B A:(CGFloat)A{
    return [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A];
}

+ (UIColor*)bt_RGBASame:(CGFloat)value A:(CGFloat)A{
    return [UIColor colorWithRed:(value)/255.0 green:(value)/255.0 blue:(value)/255.0 alpha:A];
}

+ (UIColor*)bt_RANDOM_COLOR{
    return [UIColor bt_R:arc4random_uniform(256) G:arc4random_uniform(256) B:arc4random_uniform(256)];
}

+ (UIColor *)bt_colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+ (UIColor*)bt_34Color{
    return [UIColor bt_RGBSame:34];
}

+ (UIColor*)bt_51Color{
    return [UIColor bt_RGBSame:51];
}

+ (UIColor*)bt_83Color{
    return [UIColor bt_RGBSame:83];
}

+ (UIColor*)bt_96Color{
    return [UIColor bt_RGBSame:96];
}

+ (UIColor*)bt_136Color{
    return [UIColor bt_RGBSame:136];
}

+ (UIColor*)bt_153Color{
    return [UIColor bt_RGBSame:153];
}

+ (UIColor*)bt_204Color{
    return [UIColor bt_RGBSame:204];
}

+ (UIColor*)bt_229Color{
    return [UIColor bt_RGBSame:229];
}

+ (UIColor*)bt_235Color{
    return [UIColor bt_RGBSame:235];
}

+ (UIColor*)bt_245Color{
    return [UIColor bt_RGBSame:245];
}


+ (UIColor*)bt_248Color{
    return [UIColor bt_RGBSame:248];
}


+ (UIColor*)bt_main_color{
    return [BTTheme colorWithName:@"bt_main_color"];
}

+ (UIColor*)bt_bg_color{
    return [BTTheme colorWithName:@"bt_bg_color"];
}

+ (UIColor*)bt_bg_color1{
    return [BTTheme colorWithName:@"bt_bg_color1"];
}

+ (UIColor*)bt_bg_color2{
    return [BTTheme colorWithName:@"bt_bg_color2"];
}

+ (UIColor*)bt_bg_color:(NSInteger)index{
    return [BTTheme colorWithName:[NSString stringWithFormat:@"bt_main_color_%ld",(long)index]];
}

+ (UIColor*)bt_text_color{
    return [BTTheme colorWithName:@"bt_text_color"];
}

+ (UIColor*)bt_text_color1{
    return [BTTheme colorWithName:@"bt_text_color1"];
}

+ (UIColor*)bt_text_color2{
    return [BTTheme colorWithName:@"bt_text_color2"];
}

+ (UIColor*)bt_text_color:(NSInteger)index{
    return [BTTheme colorWithName:[NSString stringWithFormat:@"bt_text_color_%ld",(long)index]];
}

+ (UIColor*)bt_divider_color{
    return [BTTheme colorWithName:@"bt_divider_color"];
}

+ (UIColor*)bt_divider_color1{
    return [BTTheme colorWithName:@"bt_divider_color1"];
}

+ (UIColor*)bt_divider_color2{
    return [BTTheme colorWithName:@"bt_divider_color2"];
}

+ (UIColor*)bt_divider_color:(NSInteger)index{
    return [BTTheme colorWithName:[NSString stringWithFormat:@"bt_divider_color_%ld",(long)index]];
}

@end
