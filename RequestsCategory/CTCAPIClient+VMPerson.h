//
//  CTCAPIClient+VMPerson.h
//  CTC Mobile
//
//  Created by e.Tulenev on 12.02.15.
//  Copyright (c) 2015 MaximumSoft. All rights reserved.
//

#import "CTCAPIClient.h"

@interface CTCAPIClient (VMPerson)

-(void)personWithId:(NSNumber*)personId success:(CTCAPIClientSuccess)success failure:(CTCAPIClientFailure)failure;

@end
