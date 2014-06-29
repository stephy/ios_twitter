//
//  TwitterClient.h
//  Twitter
//
//  Created by Stephani Alves on 6/28/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

#pragma mark Initialization
+ (TwitterClient *)instance;
- (void)login;
- (AFHTTPRequestOperation *)homeTimelineWithSuccess: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end