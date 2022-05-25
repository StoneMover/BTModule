//
//  UIViewController+BTDialog.m
//  BTHelpExample
//
//  Created by kds on 2022/4/14.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "UIViewController+BTDialog.h"
#import "BTTheme.h"

@implementation UIViewController (BTDialog)

- (NSDictionary*)bt_createBtnDict:(NSString*)title color:(UIColor*)color{
    return [self bt_createBtnDict:title color:color style:UIAlertActionStyleDefault];
}

- (NSDictionary*)bt_createBtnDict:(NSString*)title color:(UIColor*)color style:(UIAlertActionStyle)style{
    return @{@"title":title,@"color":color,@"style":[NSNumber numberWithInteger:style]};
}

- (UIAlertController*)bt_createAlert:(NSString*)title
                                 msg:(NSString*)msg
                              action:(NSArray*)action
                               style:(UIAlertControllerStyle)style{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    for (UIAlertAction * a in action) {
        [alertController addAction:a];
    }
    return alertController;
}

- (UIAlertAction*)bt_action:(NSString*)str
                      style:(UIAlertActionStyle)style
                    handler:(void (^ __nullable)(UIAlertAction *action))handler{
    return [UIAlertAction actionWithTitle:str
                                    style:style
                                  handler:handler];
}

- (UIAlertAction*_Nonnull)bt_action:(NSString*_Nullable)str
                              style:(UIAlertActionStyle)style
                              color:(UIColor*)color
                            handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler{
    UIAlertAction * action = [UIAlertAction actionWithTitle:str
                                                      style:style
                                                    handler:handler];
    [action setValue:color forKey:@"titleTextColor"];
    return action;
}


- (UIAlertController*_Nonnull)bt_showAlert:(NSString*)title
                                       msg:(NSString*)msg
                                      btns:(NSArray*)btns
                                     block:(BTDialogBlock)block{
    NSMutableArray * actions=[NSMutableArray new];
    for (int i=0; i<btns.count; i++) {
        NSString * str=btns[i];
        UIAlertAction * action =nil;
        if (btns.count==2) {
            if (i==0) {
                action=[self bt_action:str style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }else{
                action=[self bt_action:str style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }
        }else{
            if (i==btns.count-1) {
                action=[self bt_action:str style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }else{
                action=[self bt_action:str style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSInteger index=[actions indexOfObject:action];
                    block(index);
                }];
            }
            
        }
        [actions addObject:action];
    }
    UIAlertController * controller=[self bt_createAlert:title msg:msg action:actions style:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:controller animated:YES completion:nil];
    });
    return controller;
}

- (UIAlertController*_Nonnull)bt_showAlert:(NSString*_Nonnull)title
                                       msg:(NSString*_Nullable)msg
                                  btnDicts:(NSArray*_Nullable)btnDicts
                                     block:(BTDialogBlock _Nullable )block{
    NSMutableArray * actions=[NSMutableArray new];
    for (int i=0; i<btnDicts.count; i++) {
        NSDictionary * dict=btnDicts[i];
        NSString * title = dict[@"title"];
        UIColor * color = dict[@"color"];
        NSNumber * style = dict[@"style"];
        UIAlertAction * action =nil;
        action=[self bt_action:title style:style.integerValue color: color handler:^(UIAlertAction *action) {
            NSInteger index=[actions indexOfObject:action];
            block(index);
        }];
        
        [actions addObject:action];
    }
    UIAlertController * controller=[self bt_createAlert:title msg:msg action:actions style:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:controller animated:YES completion:nil];
    });
    return controller;
}



- (UIAlertController*_Nonnull)bt_showAlertDefault:(NSString*)title
                                              msg:(NSString*)msg
                                            block:(BTDialogBlock)block{
    UIAlertAction * actionCancel=[self bt_action:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        block(0);
    }];
    UIAlertAction * actionOk=[self bt_action:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        block(1);
    }];
    UIAlertController * alertController=[self bt_createAlert:title msg:msg action:@[actionCancel,actionOk] style:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}

- (UIAlertController*_Nonnull)bt_showActionSheet:(NSString*)title
                                             msg:(NSString*)msg
                                            btns:(NSArray*)btns
                                           block:(BTDialogBlock)block{
    NSMutableArray * dataArray=[NSMutableArray new];
    for (NSString * btn in btns) {
        UIAlertAction * action=[self bt_action:btn style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            block([dataArray indexOfObject:action]);
        }];
        if (BTTheme.mainActionColor) {
            [action setValue:BTTheme.mainActionColor forKey:@"titleTextColor"];
        }
        
        [dataArray addObject:action];
    }
    
    UIAlertAction * action=[self bt_action:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        block(dataArray.count-1);
    }];
    
    if (BTTheme.mainActionColor) {
        [action setValue:BTTheme.mainActionColor forKey:@"titleTextColor"];
    }
    
    [dataArray addObject:action];
    UIAlertController * alertController=[self bt_createAlert:title msg:msg action:dataArray style:UIAlertControllerStyleActionSheet];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}

- (UIAlertController*_Nonnull)bt_showActionSheet:(NSString*_Nullable)title
                                             msg:(NSString*_Nullable)msg
                                        btnDicts:(NSArray*_Nullable)btnDicts
                                           block:(BTDialogBlock _Nullable )block{
    NSMutableArray * dataArray=[NSMutableArray new];
    for (NSDictionary * dict in btnDicts) {
        NSString * title = dict[@"title"];
        UIColor * color = dict[@"color"];
        NSNumber * style = dict[@"style"];
        UIAlertAction * action=[self bt_action:title style:style.integerValue color:color handler:^(UIAlertAction *action) {
            block([dataArray indexOfObject:action]);
        }];
        [dataArray addObject:action];
    }
    
    UIAlertController * alertController=[self bt_createAlert:title msg:msg action:dataArray style:UIAlertControllerStyleActionSheet];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}

- (UIAlertController*_Nonnull)bt_showAlertEdit:(NSString*)title
                                  defaultValue:(NSString*)value
                                   placeHolder:(NSString*)placeHolder
                                         block:(void(^)(NSString * result))block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:@""
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder =placeHolder;
        textField.returnKeyType=UIReturnKeyDone;
        textField.text=value;
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    //    [cancelAction setValue:BT_MAIN_COLOR forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //获得文本框
        UITextField * field = alertController.textFields.firstObject;
        NSString * text=field.text;
        block(text);
    }];
    //    [okAction setValue:BT_MAIN_COLOR forKey:@"_titleTextColor"];
    [alertController addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}


- (UIAlertController*_Nonnull)bt_showAlertEdit:(NSString*_Nullable)title
                                  defaultValue:(NSString*_Nullable)value
                                   placeHolder:(NSString*_Nullable)placeHolder
                                      btnDicts:(NSArray*_Nullable)btnDicts
                                         block:(void(^_Nullable)(NSString * _Nullable result))block{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:@""
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder =placeHolder;
        textField.returnKeyType=UIReturnKeyDone;
        textField.text=value;
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }];
    
    if ([btnDicts.firstObject isKindOfClass:[NSString class]]) {
        UIAlertAction *cancelAction = [self bt_action:btnDicts.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            
        }];
        [alertController addAction:cancelAction];
    }else{
        NSDictionary * dict = btnDicts.firstObject;
        NSString * title = dict[@"title"];
        UIColor * color = dict[@"color"];
        NSNumber * style = dict[@"style"];
        UIAlertAction *cancelAction = [self bt_action:title style:style.integerValue color:color handler:^(UIAlertAction *action) {
            
        }];

        [alertController addAction:cancelAction];
    }
    
    if ([btnDicts.lastObject isKindOfClass:[NSString class]]) {
        UIAlertAction *okAction = [self bt_action:btnDicts.lastObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
            //获得文本框
            UITextField * field = alertController.textFields.firstObject;
            NSString * text=field.text;
            block(text);
        }];
        [alertController addAction:okAction];
    }else{
        NSDictionary * dict = btnDicts.lastObject;
        NSString * title = dict[@"title"];
        UIColor * color = dict[@"color"];
        NSNumber * style = dict[@"style"];
        UIAlertAction *okAction = [self bt_action:title style:style.integerValue color:color handler:^(UIAlertAction *action) {
            //获得文本框
            UITextField * field = alertController.textFields.firstObject;
            NSString * text=field.text;
            block(text);
        }];

        [alertController addAction:okAction];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return alertController;
}

@end
