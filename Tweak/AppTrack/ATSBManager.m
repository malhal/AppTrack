//
//  ATSBManager.m
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//
//

#import "ATSBManager.h"
#import "CPDistributedMessagingCenter.h"
#define ROCKETBOOTSTRAP_LOAD_DYNAMIC 1
#import "rocketbootstrap.h"
#import <MHData/NSManagedObjectContext+MH.h>
#import "ATDefines.h"

@implementation ATSBManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"ATSBManager init");
        [[NSFileManager defaultManager] createDirectoryAtPath:@"/var/mobile/Library/Preferences/AppTrack" withIntermediateDirectories:NO attributes:nil error:nil];
        self.storeURL = [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/AppTrack/AppTrack.sqlite"];
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:@"/Library/AppTrack/AppTrack.momd"]];
        // receive server messages in a background thread
        [self performSelectorInBackground:@selector(background) withObject:nil];
    }
    return self;
}

-(void)background{
    CPDistributedMessagingCenter* dmc = [CPDistributedMessagingCenter centerNamed:@"com.malhal.apptrack.messaging.center"];
    rocketbootstrap_distributedmessagingcenter_apply(dmc);
    [dmc registerForMessageName:@"query" target:self selector:@selector(queryMessageReceived:userInfo:)];
    [dmc runServerOnCurrentThread];
    CFRunLoopRun(); // runs forever
}

-(NSDictionary*)errorReplyWithError:(NSError*)error{
    NSData* errorData = [NSKeyedArchiver archivedDataWithRootObject:error];
    return @{@"errorData" : errorData};
}

-(NSError*)errorWithMessage:(NSString*)message{
    return [NSError errorWithDomain:AppTrackErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : message}];
}

-(NSDictionary*)errorReplyWithMessage:(NSString*)message{
    NSError* error = [self errorWithMessage:message];
    return [self errorReplyWithError:error];
}

-(NSDictionary*)queryMessageReceived:(NSString*)message userInfo:(NSDictionary*)userInfo{
    
    NSLog(@"queryMessageReceived %@", userInfo);
    
    NSString* entityName = userInfo[@"entityName"];
    if(!entityName){
        return [self errorReplyWithMessage:@"entityName missing from userInfo."];
    }
    
    __block NSError* error;
    NSManagedObjectContext* context = [self.mainContext mh_createPrivateQueueContextWithError:&error];
    if(!context){
        NSLog(@"error creating private context %@", error);
        return [self errorReplyWithError:error];
    }
    
    __block NSDictionary* reply;
    [context performBlockAndWait:^{
        @try{
            NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
            //fetchRequest.resultType = [userInfo[@"resultType"] unsignedIntegerValue];
            fetchRequest.resultType = NSDictionaryResultType;
            
            NSString* predicateDescription = userInfo[@"predicateDescription"];
            if(predicateDescription){
                fetchRequest.predicate = [NSPredicate predicateWithFormat:predicateDescription];
            }
            fetchRequest.propertiesToFetch = userInfo[@"propertiesToFetch"];
            NSNumber* fetchLimit = userInfo[@"fetchLimit"];
            if(fetchLimit){
                fetchRequest.fetchLimit = fetchLimit.unsignedIntegerValue;
            }
            //fetchRequest.propertiesToGroupBy = userInfo[@"propertiesToGroupBy"];
            NSArray* sortDescriptorDicts = userInfo[@"sortDescriptorDicts"];
            if(sortDescriptorDicts.count){
                NSMutableArray* sortDescriptors = [NSMutableArray array];
                for(NSDictionary* d in sortDescriptorDicts){
                    NSSortDescriptor* sd = [NSSortDescriptor sortDescriptorWithKey:d[@"key"] ascending:[d[@"ascending"] boolValue]];
                    [sortDescriptors addObject:sd];
                }
                fetchRequest.sortDescriptors = sortDescriptors;
            }
            NSArray* results = [context executeFetchRequest:fetchRequest error:&error];

            if(!results){
                NSLog(@"error %@", error);
                reply = [self errorReplyWithError:error];
                return;
            }
            reply = @{@"results" : results};
        }
        @catch(NSException* exception){
            reply = [self errorReplyWithMessage:exception.reason];
        }
    }];
    return reply;
}

@end
