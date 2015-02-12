//
//  CTCAPIClient_Private.h
//  CTC Mobile
//
//  Created by e.Tulenev on 03.02.15.
//  Copyright (c) 2015 MaximumSoft. All rights reserved.
//

#import "CTCAPIClient.h"

static NSString *const VIDEOMORE_URL     = @"http://videomore.ru/api/";
static NSString *const CMS_URL           = @"http://mobilecms.ctc.ru/";

@interface CTCAPIClient ()

- (void)enqueueRequest:(NSURLRequest *)request
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

/**
 *  Добавляет запрос в очередь.
 *
 *  @param request     Выполняемый запрос. Должен быть не nil.
 *  @param resultClass Класс в котором должны возвращаться приходящие с сервера данные. Если nil, то возвращается NSDictionary c JSON ответом сервера.
 *  @param success     Блок содержит массив объектов или объект, в который маппится JSON.
 */

- (void)enqueueRequest:(NSURLRequest *)request
           resultClass:(Class)resultClass
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

- (void)enqueueRequest:(NSURLRequest *)request
           resultClass:(Class)resultClass
               rootKey:(NSString *)keyPath
               success:(void (^)(id resultObject))success
               failure:(void (^)(NSError *))failure;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters;

- (NSMutableURLRequest *)requestMultipartFormWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

@end

