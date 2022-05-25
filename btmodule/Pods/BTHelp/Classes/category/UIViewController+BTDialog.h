//
//  UIViewController+BTDialog.h
//  BTHelpExample
//
//  Created by kds on 2022/4/14.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BTDialogBlock)(NSInteger index);


@interface UIViewController (BTDialog)

//快速创建btnDict字典类型,@{"title":"要显示的内容","color":颜色对象,"font":字体对象,"style":展示的样式}
- (NSDictionary*)bt_createBtnDict:(NSString*)title color:(UIColor*)color;

- (NSDictionary*)bt_createBtnDict:(NSString*)title color:(UIColor*)color style:(UIAlertActionStyle)style;

//创建一个alertController
- (UIAlertController*_Nonnull)bt_createAlert:(NSString*_Nullable)title
                                         msg:(NSString*_Nullable)msg
                                      action:(NSArray*_Nullable)action
                                       style:(UIAlertControllerStyle)style;

//创建action
- (UIAlertAction*_Nonnull)bt_action:(NSString*_Nullable)str
                              style:(UIAlertActionStyle)style
                            handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

- (UIAlertAction*_Nonnull)bt_action:(NSString*_Nullable)str
                              style:(UIAlertActionStyle)style
                              color:(UIColor*)color
                            handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

//显示对话框,如果是两个选项,第一个使用取消类型,第二个使用默认类型,如果大于两个选项最后一个会被默认为取消类型
- (UIAlertController*_Nonnull)bt_showAlert:(NSString*_Nonnull)title
                                       msg:(NSString*_Nullable)msg
                                      btns:(NSArray*_Nullable)btns
                                     block:(BTDialogBlock _Nullable )block;

//传入自己的配置项,btnDicts字典类型数组，使用bt_createBtnDict创建
- (UIAlertController*_Nonnull)bt_showAlert:(NSString*_Nonnull)title
                                       msg:(NSString*_Nullable)msg
                                  btnDicts:(NSArray*_Nullable)btnDicts
                                     block:(BTDialogBlock _Nullable )block;




//显示确定取消类型
- (UIAlertController*_Nonnull)bt_showAlertDefault:(NSString*_Nullable)title
                                              msg:(NSString*_Nullable)msg
                                            block:(BTDialogBlock _Nullable)block;

//显示底部弹框,最后一个为取消类型
- (UIAlertController*_Nonnull)bt_showActionSheet:(NSString*_Nullable)title
                                             msg:(NSString*_Nullable)msg
                                            btns:(NSArray*_Nullable)btns
                                           block:(BTDialogBlock _Nullable )block;

//传入自己的配置项,btnDicts字典类型数组，使用bt_createBtnDict创建
- (UIAlertController*_Nonnull)bt_showActionSheet:(NSString*_Nullable)title
                                             msg:(NSString*_Nullable)msg
                                        btnDicts:(NSArray*_Nullable)btnDicts
                                           block:(BTDialogBlock _Nullable )block;



//显示编辑框类型
- (UIAlertController*_Nonnull)bt_showAlertEdit:(NSString*_Nullable)title
                                  defaultValue:(NSString*_Nullable)value
                                   placeHolder:(NSString*_Nullable)placeHolder
                                         block:(void(^_Nullable)(NSString * _Nullable result))block;

//显示编辑框类型,btnDicts为取消、确定的配置，btnDicts中可以为字符串或者字典，会根据类型自动判断
- (UIAlertController*_Nonnull)bt_showAlertEdit:(NSString*_Nullable)title
                                  defaultValue:(NSString*_Nullable)value
                                   placeHolder:(NSString*_Nullable)placeHolder
                                      btnDicts:(NSArray*_Nullable)btnDicts
                                         block:(void(^_Nullable)(NSString * _Nullable result))block;


@end

NS_ASSUME_NONNULL_END
