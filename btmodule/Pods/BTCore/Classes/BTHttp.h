//
//  BTHttpRequest.h
//  framework
//
//  Created by whbt_mac on 2016/10/18.
//  Copyright © 2016年 StoneMover. All rights reserved.
//  对于AFNetworking的再次封装,避免以后网络请求库的替换操作
//  如果只需要一个对象使用share方法即可，如果需要多个对象则使用new的方式创建，库会默认使用share方法创建，如果有额外需要请使用new的方式创建

/**
 关于https自签证书的验证
 
 
 我们在使用自签名证书来实现HTTPS请求时，因为不像机构颁发的证书一样其签名根证书在系统中已经内置了，所以我们需要在App中内置自己服务器的签名根证书来验证数字证书。
 首先将服务端生成的.cer格式的根证书添加到项目中，注意在添加证书要一定要记得勾选要添加的targets。
 
 这里有个地方要注意：
 苹果的ATS要求服务端必须支持TLS1..2或以上版本；
 必须使用支持前向保密的密码；
 证书必须使用SHA-256或者更好的签名hash算法来签名
 
 如果证书无效，则会导致连接失败。由于我在生成的根证书时签名hash算法低于其要求，在配置完请求时一直报NSURLErrorServerCertificateUntrusted = -1202错误，希望大家可以注意到这一点。
 

 如果是CA认证的https证书则不需要修改任何配置
 
 AFSecurityPolicy分三种验证模式：
 1、AFSSLPinningModeNone：只验证证书是否在信任列表中
 2、AFSSLPinningModeCertificate：验证证书是否在信任列表中，然后再对比服务端证书和客户端证书是否一致
 3、 AFSSLPinningModePublicKey：只验证服务端与客户端证书的公钥是否一致
 
 选择那种模式呢?
 AFSSLPinningModeCertificate
 最安全的比对模式。但是也比较麻烦，因为证书是打包在APP中，
 如果服务器证书改变或者到期，旧版本无法使用了，我们就需要用户更新APP来使用最新的证书。
 
 AFSSLPinningModePublicKey
 
 只比对证书的Public Key，只要Public Key没有改变，证书的其他变动都不会影响使用。
 如果你不能保证你的用户总是使用你的APP的最新版本，所以我们使用AFSSLPinningModePublicKey。
 
 如果不想被抓包如此设置：

 [BTHttp.share.mananger setValue:[NSURL URLWithString:@"你的API地址"] forKey:@"baseURL"];
 AFSecurityPolicy * policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
 BTHttp.share.mananger.securityPolicy = policy;
 
 可以被抓包
 AFSecurityPolicy * policy = [AFSecurityPolicy new];
 policy.allowInvalidCertificates = YES;
 policy.validatesDomainName = NO;
 BTHttp.share.mananger.securityPolicy = policy;
 
 */

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <BTHelp/BTModel.h>
#import <BTHelp/BTConfig.h>

@class BTHttpFilter;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BTHttpDefaultErrorBlock)(NSURLSessionDataTask * _Nullable task, NSError * error);

typedef void (^BTHttpDefaultSuccessBlock)(NSURLSessionDataTask *task, id _Nullable responseObject);

typedef void(^BTHttpDefaultProgressBlock)(NSProgress * _Nullable progress);

typedef void(^BTHttpDefaultFormDataBlock)(id <AFMultipartFormData> formData);

@interface BTHttp : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager * mananger;

//是否携带cookie信息
@property (nonatomic, assign) BOOL HTTPShouldHandleCookies;

//设置超时时间
@property (nonatomic, assign) NSInteger timeInterval;

@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

/**
 网络请求过滤器以及配置
 */
@property (nonatomic, strong) BTHttpFilter * httpFilter;

+(instancetype)share;


#pragma mark GET请求
- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable BTHttpDefaultProgressBlock) downloadProgress
                               success:(nullable BTHttpDefaultSuccessBlock)success
                               failure:(nullable BTHttpDefaultErrorBlock)failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable BTHttpDefaultSuccessBlock)success
                               failure:(nullable BTHttpDefaultErrorBlock)failure;


#pragma mark POST请求
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure;



- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure;


#pragma mark 数据上传
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(nullable BTHttpDefaultFormDataBlock)block
                      progress:(nullable BTHttpDefaultProgressBlock)uploadProgress
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(nullable BTHttpDefaultFormDataBlock)block
                       success:(nullable BTHttpDefaultSuccessBlock)success
                       failure:(nullable BTHttpDefaultErrorBlock)failure;

#pragma mark PUT
- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                    parameters:(id)parameters
                       success:(nullable BTHttpDefaultSuccessBlock)success
                      failure:(nullable BTHttpDefaultErrorBlock)failure;

#pragma mark DELETE
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                    parameters:(id)parameters
                       success:(nullable BTHttpDefaultSuccessBlock)success
                         failure:(nullable BTHttpDefaultErrorBlock)failure;

//添加头信息
-(void)addHttpHead:(NSString*)key value:(NSString*)value;

//删除头部信息
- (void)delHttpHead:(NSString*)key;

//设置接收数据类型
- (void)setResponseAcceptableContentType:(NSSet<NSString*>*)acceptableContentTypes;

@end



typedef void(^BTNetSuccessBlock)(id _Nullable obj);

typedef void(^BTNetFailBlock)(NSError * _Nullable error,NSString * _Nullable errorInfo);

typedef void(^BTNetFailFullBlock)(NSError * _Nullable error,NSInteger code,NSString * _Nullable errorInfo);


@interface BTNet : NSObject

///默认的API地址，默认为BTEnvMananger.nowModel.url，需要可以自己重写
+ (NSString*)rootUrl;

/**
 默认的模块名称，为空，需要自己重写
 然后调用getUrlFunction方法后会自动拼接url，为rootUrl + "/" + moduleName + "/" + functionName
 */
+ (NSString*)moduleName;

/**
 获取基本url,传入rootUrl,模块名称,方法名称
 为rootUrl + "/" + moduleName + "/" + functionName，如果functionName为空则不拼接

 */
+ (NSString*)getUrl:(NSString*)rootUrl
         moduleName:(NSString*)moduleName
       functionName:(NSString*_Nullable)functionName;

/**
 获取基本拼接url,传入模块名称,方法名称进行拼接，
 为rootUrl + "/" + moduleName + "/" + functionName，如果functionName为空则不拼接
 */
+ (NSString*)getUrl:(NSString*)moduleName
       functionName:(NSString*_Nullable)functionName;

/**
 传入方法名,rootUrl默认为ROOT_URL，针对只有rootUrl+moduleName情况下的接口
 */
+ (NSString*)getUrlModule:(NSString*)moduleName;

/**
 在重写了moduleName方法的情况下，直接传入方法名称即可
 为rootUrl + "/" + moduleName + "/" + functionName
 */
+ (NSString*)getUrlFunction:(NSString*)functionName;

/**
 默认使用的过滤器，默认为BTHttp.httpFilter
 根据需要可重写返回自己需要的过滤器
 */
+ (BTHttpFilter*)httpFilter;


//获取图片拼接地址的完整url，传入拼接的url，如果不需要拼接则BTEnvMananger.nowModel.imgUrlStart不设置即可
+ (NSURL*)autoFullImgUrl:(NSString*_Nullable)url;

//统一的成功、失败回调方法，成功方法中会出现自定义状态码的判断，所以不一定是成功状态，返回的结果即为对应状态
+ (BOOL)defaultSuccess:(id  _Nullable)responseObject
               success:(BTNetSuccessBlock _Nullable)success
                  fail:(BTNetFailBlock _Nullable)fail;

+ (BOOL)defaultSuccess:(id  _Nullable)responseObject
               success:(BTNetSuccessBlock _Nullable)success
              failFull:(BTNetFailFullBlock _Nullable)failFull;

+ (void)defaultNetError:(NSError * _Nonnull)error fail:(BTNetFailBlock _Nullable)fail;
+ (void)defaultNetError:(NSError * _Nonnull)error failFull:(BTNetFailFullBlock _Nullable)failFull;

@end


@interface BTGray : NSObject

+ (instancetype)share;

@end


@interface BTGrayModel : BTModel

@property (nonatomic, strong) NSString * identify;

@property (nonatomic, assign) NSInteger requestType;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSDictionary * dict;

@property (nonatomic, strong) NSString * url;


@end





@interface BTHttpFilter : NSObject

///分页加载的起始页，默认的是1
@property (nonatomic, assign) NSInteger pageLoadStartPage;

///分页加载的默认每页数据，默认的是每页20条数据
@property (nonatomic, assign) NSInteger pageLoadSizePage;


///分页数量大小参数名称，默认pageSize
@property (nonatomic, strong) NSString * pageLoadSizeName;

///分页下标参数名称，默认pageNumber
@property (nonatomic, strong) NSString * pageLoadIndexName;


//是否在BTHttp中打印请求参数值以及返回值，默认NO
@property (nonatomic, assign) BOOL isLogHttpParameters;

//是否将BTHttp打印的请求日志保存在BTLog本地的日志中，如果需要则将BTLog中的日志文件最大值设置到10M左右，默认NO
@property (nonatomic, assign) BOOL  isLogSaveToBTLog;

/*
 请求返回内容的过滤器，可以做一些请求状态的全局逻辑处理，success和fail回调都会用此接口，比如账号冻结，
 如果想继续往下执行则返回YES，否则返回NO
 
 */
- (BOOL)netFilter:(NSURLRequest * _Nullable)request obj:(NSObject * _Nullable)obj;

/*
 处理NSError对象的错误信息获取
 这里特指http状态码code不为200的时候，后面可能还有后端返回的json信息，实现此方法通过error对象获取字典返回需要显示的错误信息
 */
- (NSString *)netErrorInfoFilter:(NSURLRequest * _Nullable)request error:(NSError * _Nullable)error;

/*
 获取请求结果的状态码，网络请求成功后返回的http 状态为200
 这里特指已经返回200的情况后，获取字典中的类似status或者success的字段进行相关逻辑
 */
- (NSInteger)netCodeFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict;


/*
 网络请求状态是否成功，网络请求成功后返回的http 状态为200
 这里特指已经返回200的情况后,通过字典中的类似status或者success的字段进行业务逻辑判断的成功与否
 */
- (BOOL)netSuccessFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict;

/**
 网络请求状态是否成功，网络请求成功后返回的http 状态为200
 这里特指已经返回200的情况后,通过字典中的类似status或者success的字段进行业务逻辑判断的成功与否
 */
- (NSString *)netInfoFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict;

/**
 获取请求后返回的字典内容中的数据，一般为data字段，为防止字段不同可自行实现进行获取
 */
- (NSDictionary *)netDataFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict;

/**
 获取请求内容中的数组结构体
 专门针对数据列表返回的数据的特定字段获取，如果字段统一则实现该方法统一返回数组数据
 */
- (NSArray *)netDataArrayFilter:(NSURLRequest * _Nullable)request response:(NSDictionary * _Nullable)dict;

/**
 默认的请求参数
 当你的请求需要携带默认参数的时候实现该方法
 */
- (NSMutableDictionary *)netDefaultDict;

- (NSMutableDictionary *)netDefaultDictWithOther:(NSDictionary*)dictOther;

/**
 默认的分页请求参数，基于netDefaultDict添加分页参数下表页字段、以及分页大小字段
 */
- (NSMutableDictionary *)netDefaultPageDict:(NSInteger)page;

/**
 默认的http请求头部信息
 */
- (NSMutableDictionary *)netDefaultHeadDict;

@end





NS_ASSUME_NONNULL_END
