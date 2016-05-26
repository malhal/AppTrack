//
//  ATSBApp.h
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ATSBUsage;
@class ATSBLifecycle;

NS_ASSUME_NONNULL_BEGIN

@interface ATSBApp : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "ATSBApp+CoreDataProperties.h"
