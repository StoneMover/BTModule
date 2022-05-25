//
//  BaseModel.m
//  freeuse
//
//  Created by whbt_mac on 16/4/25.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BTModel.h"
#import <objc/runtime.h>

static NSMutableDictionary * propertyCacheDict;

@implementation BTModel

+(void)load{
    propertyCacheDict = [NSMutableDictionary new];
}

+(instancetype)modelWithDict:(NSDictionary * _Nullable)dict{
    return [[self alloc]initWithDict:dict];
}

+(NSMutableArray*)modelWithArray:(NSArray * _Nullable)array{
    if (![array isKindOfClass:[NSArray class]]) {
        NSLog(@"BaseModelAnalisys modelWithArray parameter is not array : %@-%@",self,array);
        return [NSMutableArray new];
    }
    NSMutableArray * dataArray =[NSMutableArray new];
    for (NSDictionary * dict in array) {
        [dataArray addObject:[self modelWithDict:dict]];
    }
    
    return dataArray;
}

-(instancetype)init{
    self=[super init];
    [self initSelf];
    return self;
}

-(instancetype)initWithDict:(NSDictionary * _Nullable)dict{
    self = [super init];
    [self initSelf];
    [self analisys:dict];
    return self;
}



-(void)initSelf{
    
}

-(void)analisys:(NSDictionary * _Nullable)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    BTModelAnalisys * analysis=[[BTModelAnalisys alloc]init];
    [analysis analysisDict:dict withModel:self];
}


-(NSDictionary*)autoDataToDictionary{
    BTModelAnalisys * analysis=[[BTModelAnalisys alloc]init];
    return [analysis autoDataToDictionary:self];
}

@end


@implementation BTModelProperty


-(void)autoType:(NSString*)typeStr{
    if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"Tq"]) {
        self.type=BTModelTypeInt;
    }else if ([typeStr hasPrefix:@"Tf"]){
        self.type=BTModelTypeFloat;
    }else if ([typeStr hasPrefix:@"Td"]){
        self.type=BTModelTypeDouble;
    }else if ([typeStr hasPrefix:@"TB"]){
        self.type=BTModelTypeBool;
    }else if ([typeStr hasPrefix:@"T@\"NSMutableArray\""]){
        self.type=BTModelTypeMutableArray;
    }else if ([typeStr hasPrefix:@"T@\"NSString\""]){
        self.type=BTModelTypeString;
    }else if ([typeStr hasPrefix:@"T@\"NSArray\""]){
        self.type=BTModelTypeArray;
    }else if ([typeStr hasPrefix:@"T@\"NSDictionary\""]){
        self.type=BTModelTypeDict;
    }else if ([typeStr hasPrefix:@"T@\"NSMutableDictionary\""]){
        self.type=BTModelTypeMutableDict;
    }else{
        self.type=BTModelTypeBase;
    }
}

@end



@implementation BTModelAnalisys

-(void)analysisDict:(NSDictionary*)dict withModel:(BTModel*)model{
    
    NSArray * attributes=[self propertyKeys:model isAnalisys:YES];
    
    for (BTModelProperty * key in attributes) {
        NSString * dictKey = key.aliasName;
        NSObject * resultObj = [dict valueForKey:dictKey];
//        if (resultObj == nil || [resultObj class] == [NSNull class]) {
//            if (key.type == BTModelTypeString) {
//                [model setValue:@"" forKey:key.propertyName];
//            }else if(key.type == BTModelTypeArray){
//                [model setValue:[NSArray new] forKey:key.propertyName];
//            }else if(key.type == BTModelTypeMutableArray){
//                [model setValue:[NSMutableArray new] forKey:key.propertyName];
//            }
//
//
//            break;
//        }
        //当字典中存在该key的时候
        switch (key.type) {
            case BTModelTypeString:
            {
                if (resultObj == nil || [resultObj class] == [NSNull class]) {
                    [model setValue:@"" forKey:key.propertyName];
                    break;
                }
                id result = [NSString stringWithFormat:@"%@",resultObj];
                if ([result isEqualToString:@"<null>"]){
                    [model setValue:@"" forKey:key.propertyName];
                    break;
                }
                [model setValue:result forKey:key.propertyName];
            }
                break;
            case BTModelTypeInt:
            case BTModelTypeFloat:
            case BTModelTypeDouble:
            case BTModelTypeBool:
            {
                if (resultObj == nil || [resultObj class] == [NSNull class]) {
                    break;
                }
                
                [model setValue:resultObj forKey:key.propertyName];
                break;
            }
            case BTModelTypeDict:
            case BTModelTypeMutableDict:
            {
                if (![resultObj isKindOfClass:[NSDictionary class]]) {
                    [model setValue:[NSMutableDictionary new] forKey:key.aliasName];
                    break;
                }
                [model setValue:[[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)resultObj] forKey:key.aliasName];
                break;
            }
                
            case BTModelTypeArray:
            case BTModelTypeMutableArray:
            {
                //获取到的数据不是数组类型
                if (![resultObj isKindOfClass:[NSArray class]]) {
                    [model setValue:[NSMutableArray new] forKey:key.propertyName];
                    break;
                }
                //判断数组是否为0
                NSArray * dictArray = (NSArray*)resultObj;
                if (dictArray.count==0) {
                    //这里为空数据生成空数组
                    [model setValue:[NSMutableArray new] forKey:key.propertyName];
                    break;
                }
                
                //这里判断修改为判断该字段是否在classDict中设置过对应的Class，如果未设置则当做普通数组处理
                //不会去解析数组中的每一项内容，比如数组中放的是NSString类型等
                Class  className = [model.classDict objectForKey:dictKey];
                if (!className || ![dictArray.firstObject isKindOfClass:[NSDictionary class]]) {
                    NSMutableArray * array = [NSMutableArray new];
                    for (int i=0; i<dictArray.count; i++) {
                        NSObject * obj = dictArray[i];
                        if ([obj isKindOfClass:[NSNull class]]) {
                            [array addObject:@""];
                        }else{
                            [array addObject:obj];
                        }
                    }
                    [model setValue:array forKey:key.propertyName];
                    break;
                }
                
                NSMutableArray * mutableArray=[[NSMutableArray alloc]init];
                for (NSDictionary * dictChild in dictArray) {
                    Class child=className;
                    BTModel * modelChild=[[child alloc]init];
                    [modelChild analisys:dictChild];
                    [mutableArray addObject:modelChild];
                }
                
                if (key.type==BTModelTypeArray) {
                    NSArray * array=[NSArray arrayWithArray:mutableArray];
                    [model setValue:array forKey:key.propertyName];
                }else{
                    [model setValue:mutableArray forKey:key.propertyName];
                }
                break;
            }
                
            case BTModelTypeBase:{
                
                if (![resultObj isKindOfClass:[NSDictionary class]]) {
//                        [self LogError:[NSString stringWithFormat:@"return data type error,there is need dictionary,but get other:%@-%@-%@",NSStringFromClass(model.class),dictKey,dictChild]];
                    break;
                }
                NSDictionary * dictChild = (NSDictionary*)resultObj;
                Class className=[model.classDict objectForKey:dictKey];
                if (!className) {
//                        [self LogError:[NSString stringWithFormat:@"empty class name error!:%@-%@",NSStringFromClass(model.class),dictKey]];
                    break;
                }
                
                Class child=className;
                BTModel * modelChild=[[child alloc]init];
                [modelChild analisys:dictChild];
                [model setValue:modelChild forKey:key.propertyName];
                break;
            }
                
            default:
                break;
        }
    }
}

-(NSDictionary*)autoDataToDictionary:(BTModel*)model{
    NSDictionary * dict=[[NSMutableDictionary alloc]init];
    NSArray * attributes=[self propertyKeys:model isAnalisys:NO];
    for (BTModelProperty * property in attributes) {
        switch (property.type) {
            case BTModelTypeString:
            case BTModelTypeInt:
            case BTModelTypeFloat:
            case BTModelTypeDouble:
            case BTModelTypeBool:
            {
                id value=[model valueForKey:property.propertyName];
                [dict setValue:value forKey:property.aliasName];
                break;
            }
            case BTModelTypeDict:
            case BTModelTypeMutableDict:
            {
                id value=[model valueForKey:property.propertyName];
                if (![value isKindOfClass:[NSDictionary class]]) {
                    break;
                }
                [dict setValue:[[NSMutableDictionary alloc]initWithDictionary:value] forKey:property.aliasName];
                break;
            }
                
                
            case BTModelTypeArray:
            case BTModelTypeMutableArray:
            {
                NSMutableArray * array=[[NSMutableArray alloc]init];
                NSArray * arrayData=[model valueForKey:property.propertyName];
                for (BTModel * childModel in arrayData) {
                    if ([childModel isKindOfClass:[BTModel class]]) {
                        NSDictionary * dictChild=[self autoDataToDictionary:childModel];
                        [array addObject:dictChild];
                    }else{
                        [array addObject:childModel];
                    }
                    
                }
                
                [dict setValue:array forKey:property.aliasName];
                
                break;
            }
                
            case BTModelTypeBase:{
                BTModel * childModel=[model valueForKey:property.propertyName];
                NSDictionary * dictValue=[self autoDataToDictionary:childModel];
                [dict setValue:dictValue forKey:property.aliasName];
                break;
            }
                
            default:
                break;
        }
        
    }
    return dict;
}

- (NSArray*)propertyKeys:(BTModel*)baseModel isAnalisys:(BOOL)isAnalisys
{
    if (![baseModel isKindOfClass:[BTModel class]]) {
//        [self LogError:@"data is not kind of BaseModel"];
        return @[];
    }
    
    NSArray * cacheArray = [propertyCacheDict valueForKey:NSStringFromClass([baseModel class])];
    if (cacheArray != nil) {
        return cacheArray;
    }
    
    NSMutableArray * array =[NSMutableArray new];
    [array addObjectsFromArray:[self propertyKey:[baseModel class] aliasDict:baseModel.aliasDict ignoreAnalisysField:baseModel.ignoreAnalisysField ignoreUnAnalisysField:baseModel.ignoreUnAnalisysField isAnalisys:isAnalisys]];
    
    Class claSuper =[baseModel superclass];
    while (claSuper !=[BTModel class]) {
        [array addObjectsFromArray:[self propertyKey:claSuper aliasDict:baseModel.aliasDict ignoreAnalisysField:baseModel.ignoreAnalisysField ignoreUnAnalisysField:baseModel.ignoreUnAnalisysField isAnalisys:isAnalisys]];
        claSuper=[claSuper superclass];
    }
    [propertyCacheDict setValue:array forKey:NSStringFromClass([baseModel class])];
    return array;
}

- (NSArray*)propertyKey:(Class)cla
              aliasDict:(NSDictionary*)aliasDict
    ignoreAnalisysField:(NSSet*)ignoreAnalisysField
  ignoreUnAnalisysField:(NSSet*)ignoreUnAnalisysField
             isAnalisys:(BOOL)isAnalisys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cla, &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    NSSet * aliasKeys=[[NSSet alloc]initWithArray:aliasDict.allKeys];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //如果有配置别名信息,则取出别名赋值
        NSString * aliasName=propertyName;
        if ([aliasKeys containsObject:propertyName]) {
            aliasName=[aliasDict objectForKey:propertyName];
        }
        
        //如果不是被忽略的解析字段则加入解析数组中
        if (isAnalisys) {
            if (![ignoreAnalisysField containsObject:propertyName]) {
                NSString * propertyType=[[NSString alloc]initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
                BTModelProperty * model=[[BTModelProperty alloc]init];
                model.propertyName=propertyName;
                model.aliasName=aliasName;
                [model autoType:propertyType];
                [keys addObject:model];
            }
        }else{
            if (![ignoreUnAnalisysField containsObject:propertyName]) {
                NSString * propertyType=[[NSString alloc]initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
                BTModelProperty * model=[[BTModelProperty alloc]init];
                model.propertyName=propertyName;
                model.aliasName=aliasName;
                [model autoType:propertyType];
                [keys addObject:model];
            }
        }
        
    }
    free(properties);
    return keys;
}



//-(void)LogError:(NSString*)errorInfo{
//    NSLog(@"BaseModelAnalisys %@",errorInfo);
//}

@end
