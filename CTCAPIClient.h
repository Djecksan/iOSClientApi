//
//  CTCAPIClient.h
//  CTC Mobile
//
//  Created by e.Tulenev on 03.02.15.
//  Copyright (c) 2015 MaximumSoft. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void(^CTCAPIClientSuccess)(id result);
typedef void(^CTCAPIClientFailure)(NSError *error);

@interface CTCAPIClient : AFHTTPRequestOperationManager

+ (instancetype)clientVM;
+ (instancetype)clientCMS;

@end