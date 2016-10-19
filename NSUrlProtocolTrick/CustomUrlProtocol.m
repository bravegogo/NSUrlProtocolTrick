//
//  CustomSessionUrlProtocol.m
//  NSUrlProtocolTrick
//
//  Created by yxhe on 16/10/19.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "CustomUrlProtocol.h"

#define kProtocolKey @"SessionProtocolKey"

@interface CustomUrlProtocol ()<NSURLSessionDelegate>
{
    NSURLConnection *_connection;
    NSURLSession *_session;
}
@end

@implementation CustomUrlProtocol

#pragma mark - Protocol相关方法

// 是否拦截处理task
//+ (BOOL)canInitWithTask:(NSURLSessionTask *)task
//{
//    
//    
//    return YES;
//}

// 是否拦截处理request
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:kProtocolKey inRequest:request])
    {
        return NO;
    }
    
    
    // 这里可以设置拦截过滤
//    NSString * url = request.URL.absoluteString;
//    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"])
//    {
//        return YES;
//    }
    
    return YES;
}

// 重定向
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    return [self redirectRequest:mutableRequest];
}

- (void)startLoading
{
    // 表示该请求已经被处理，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:kProtocolKey inRequest:(NSMutableURLRequest *)self.request];

    
    // 普通方式,可以读取本地文件，图片路径，json等
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSData *redirectData = [NSData dataWithContentsOfFile:filePath];
    NSURLResponse *redirectResponse = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                                MIMEType:@"application/json"
                                                   expectedContentLength:redirectData.length
                                                        textEncodingName:nil];
    
    [self.client URLProtocol:self
          didReceiveResponse:redirectResponse
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:redirectData];
    [self.client URLProtocolDidFinishLoading:self];
    
    
    // connection代理方式
//    _connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
    
    // session代理方式
//    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    _session = [NSURLSession sessionWithConfiguration:config
//                                             delegate:self
//                                        delegateQueue:[[NSOperationQueue alloc] init]];
//    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:self.request];
//    
//    
//    
//    [dataTask resume];
    
    
}

- (void)stopLoading
{
    [_connection cancel];
    _connection = nil;
    
//    [_session invalidateAndCancel];
//    _session = nil;
}

#pragma mark - 自定义方法
+ (NSMutableURLRequest *)redirectRequest:(NSMutableURLRequest *)srcRequest
{
    // 在这里对原理啊的request作各种修改，改url加头部都可以
    if (srcRequest.URL.absoluteString.length == 0)
    {
        return srcRequest;
    }
    
    srcRequest.URL = [NSURL URLWithString:@"http://www.baidu.com"];
//    NSMutableArray *httpHeader = [srcRequest.allHTTPHeaderFields mutableCopy];
//    [httpHeader setObject:@"11111" atIndexedSubscript:@"newFiled"];
    
    return srcRequest;
}

#pragma mark - NSUrLConnectionDataDelgate
// connection的走这里
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLSessionDataDelegate，如果原来的请求是用代理形式做的，在这里处理
// session的走这里
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error)
    {
        [self.client URLProtocol:self didFailWithError:error];
    } else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    completionHandler(proposedResponse);
}



@end
