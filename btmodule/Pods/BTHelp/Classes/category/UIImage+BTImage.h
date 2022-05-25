//
//  UIImage+BTImage.h
//  moneyMaker
//
//  Created by Motion Code on 2019/1/29.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BTImage)

/// 获取纯色图片对象，默认大小宽度：55；高度：1
/// @param color 具体颜色
+ (UIImage*)bt_imageWithColor:(UIColor *)color;

/// 获取纯色图片对象
/// @param color 具体颜色
/// @param size 具体大小
+ (UIImage*)bt_imageWithColor:(UIColor *)color size:(CGSize)size;

/// 获取纯色图片对象
/// @param color 具体颜色
/// @param size 长宽相等的值
+ (UIImage*)bt_imageWithColor:(UIColor *)color equalSize:(CGFloat)size;


/// 加载图片不受系统tintColor颜色的影响显示
/// @param imgName 图片名称
+ (UIImage*)bt_imageOriWithName:(NSString*)imgName;

///加载图片根据tintcolor颜色
+ (UIImage*)bt_imageTintColor:(NSString*)imgName;


/// 压缩大小到指定的文件大小
/// @param maxLength 文件大小
- (NSData *)bt_compressQualityWithMaxLength:(NSInteger)maxLength;


/// 将图片缩放到指定的宽高大小，多出的部分将以中心为基准进行裁剪
/// @param size 图片的宽度和长度大小
- (UIImage *)bt_scaleToSize:(CGSize)size;


/// 绘制圆角
/// @param radius 需要的圆角值
- (UIImage*)bt_imageWithCornerRadius:(CGFloat)radius;


/// 将UIimage重绘成圆形,如果不是等宽,等高则绘制中心图片
- (UIImage*)bt_circleImage;

// 生成二维码
+ (UIImage *)bt_qrImage:(NSString *)inputMessage width:(CGFloat)width height:(CGFloat)height;

+ (UIImage * _Nullable)bt_animatedGIFWithData:(NSData *)data;

+ (UIImage *_Nullable)bt_animatedGIFWithData:(NSData *)data scale:(NSInteger)scale;

+ (UIImage * _Nullable)bt_animatedGIFNamed:(NSString *)name bundle:(NSBundle*)b;

- (UIImage * _Nullable)bt_animatedImageByScalingAndCroppingToSize:(CGSize)size;


/** 纠正图片的方向 */
- (UIImage *)bt_fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)bt_rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)bt_flipVertical;

/** 水平翻转 */
- (UIImage *)bt_flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)bt_imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)bt_imageRotatedByRadians:(CGFloat)radians;

@end

NS_ASSUME_NONNULL_END
