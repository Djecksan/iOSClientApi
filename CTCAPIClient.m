//
//  CTCAPIClient.m
//  CTC Mobile
//
//  Created by e.Tulenev on 03.02.15.
//  Copyright (c) 2015 MaximumSoft. All rights reserved.
//

#import "CTCAPIClient_Private.h"
#import <Mantle.h>
#import "PopupsManager.h"

@implementation CTCAPIClient

+ (instancetype)clientVM {
    static CTCAPIClient * _clientVM = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _clientVM = [[CTCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:VIDEOMORE_URL]];
    });
    return _clientVM;
}

+ (instancetype)clientCMS {
    static CTCAPIClient * _clientCMS = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _clientCMS = [[CTCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:CMS_URL]];
    });
    return _clientCMS;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            // TODO: Показ попапа с надписью "Интернет не доступен"
            [[PopupsManager sharedInstance] showNoInternetConnectionPopup];
        }
    }];
    
    return self;
}

- (void)enqueueRequest:(NSURLRequest *)request
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    [self enqueueRequest:request resultClass:nil success:success failure:failure];
}

- (void)enqueueRequest:(NSURLRequest *)request
           resultClass:(Class)resultClass
               success:(void (^)(id resultObject))success
               failure:(void (^)(NSError *))failure {
    [self enqueueRequest:request resultClass:resultClass rootKey:nil success:success failure:failure];
}

- (void)enqueueRequest:(NSURLRequest *)request
           resultClass:(Class)resultClass
               rootKey:(NSString *)keyPath
               success:(void (^)(id resultObject))success
               failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DEBUG
        NSLog(@"#network Operation: %@ Response: %@", operation, responseObject);
#endif
        
        if(operation.response.statusCode == 204) {
            if(success)
                success([NSNull null]);
            return;
        }
        
        id objectToParse = keyPath ? [responseObject valueForKeyPath:keyPath] : responseObject;
        if (success && objectToParse && ![objectToParse isEqual:[NSNull null]]) {
            
            if (resultClass) {
                if ([objectToParse isKindOfClass:[NSArray class]]) {
                    success([MTLJSONAdapter modelsOfClass:resultClass fromJSONArray:objectToParse error:nil]);
                } else if ([objectToParse isKindOfClass:[NSDictionary class]]) {
                    success([MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:objectToParse error:nil]);
                }
                
            } else {
                success(objectToParse);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    [self.operationQueue addOperation:operation];
}

#pragma mark - Private Methods

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
}

- (NSMutableURLRequest *)requestMultipartFormWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block{
    
    return [self.requestSerializer multipartFormRequestWithMethod:method
                                                        URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters
                                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                            block(formData);
                                        } error:nil];
}

@end
