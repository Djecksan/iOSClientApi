//
//  CTCAPIClient+VMPerson.m
//  CTC Mobile
//
//  Created by e.Tulenev on 12.02.15.
//  Copyright (c) 2015 MaximumSoft. All rights reserved.
//

#import "CTCAPIClient+VMPerson.h"
#import "CTCAPIClient_Private.h"
#import "CTCAPIClient+VMURL.h"

#import "CTCPerson.h"

@implementation CTCAPIClient (VMPerson)

-(void)personWithId:(NSNumber*)personId success:(CTCAPIClientSuccess)success failure:(CTCAPIClientFailure)failure {
    NSString *vmURL = [self generateUrlWithApiMethod:kVideoMoreApiProjectPersonInfo andParamters:@{@"person_id":personId}];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" URLString:vmURL parameters:nil];
    [self enqueueRequest:request resultClass:[CTCPerson class] success:success failure:failure];
}

@end
