//
//  ATSBLifecycle.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ATDefines.h"

@class ATSBApp;

NS_ASSUME_NONNULL_BEGIN

@interface ATSBLifecycle : NSManagedObject

@property (nonatomic, assign) ATSBLifecycleChangeType changeType;
// Insert code here to declare functionality of your managed object subclass
+(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END

#import "ATSBLifecycle+CoreDataProperties.h"
