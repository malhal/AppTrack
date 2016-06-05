//
//  AUKTApp.h
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AUKTUsage;
@class AUKTLifecycle;

NS_ASSUME_NONNULL_BEGIN

@interface AUKTApp : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "AUKTApp+CoreDataProperties.h"
