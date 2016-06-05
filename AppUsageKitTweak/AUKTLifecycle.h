//
//  AUKTLifecycle.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppUsageKitDefines.h"

@class AUKTApp;

NS_ASSUME_NONNULL_BEGIN

@interface AUKTLifecycle : NSManagedObject

@property (nonatomic, assign) AUKLifecycleChangeType changeType;
// Insert code here to declare functionality of your managed object subclass
+(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "AUKTLifecycle+CoreDataProperties.h"
