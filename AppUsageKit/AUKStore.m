//
//  AUKStore.m
//  AppUsageKit
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "AUKStore.h"
#import "CPDistributedMessagingCenter.h"
#define ROCKETBOOTSTRAP_LOAD_DYNAMIC 1
#import "rocketbootstrap.h"
#import "AUKQuery+Private.h"
#import "AUKObjectType+Private.h"
#import "NSDictionary+MHF.h"

@interface AUKStore()

@property NSOperationQueue* operationQueue;

@end

@implementation AUKStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)executeQuery:(AUKQuery *)query{
    NSBlockOperation* op = [NSBlockOperation blockOperationWithBlock:^{
        CPDistributedMessagingCenter *dmc = [CPDistributedMessagingCenter centerNamed:AppUsageKitMessagingCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(dmc);
        
        //    // Two-way (wait for reply)
        NSDictionary *reply = [dmc sendMessageAndReceiveReplyName:@"query" userInfo:query.dictionary/* optional dictionary */];
        
        NSData* errorData = reply[@"errorData"];
        if(errorData){
            NSError* error2 = [NSKeyedUnarchiver unarchiveObjectWithData:errorData];
            query.resultsHandler(query, nil, error2);
        }
        
        NSArray* results = reply[@"results"];
        NSMutableArray* objects = [NSMutableArray array];
        for(NSDictionary* resultTypeDictionary in results){ // keys are all flat paths like @"app.bundleIdentifier".
            NSDictionary* treeDict = [resultTypeDictionary mhf_unflattenDictionary];
            AUKObject* usage = [[query.objectType.objectClass alloc] initWithDictionary:treeDict];
            [objects addObject:usage];
        }
        query.resultsHandler(query, objects, nil);

    }];
    [self.operationQueue addOperation:op];
}
@end
