//
//  ATSBLifecycle+CoreDataProperties.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ATSBLifecycle.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATSBLifecycle (CoreDataProperties)

//@property (nullable, nonatomic, retain) NSNumber *changeType;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) ATSBApp *app;

@end

NS_ASSUME_NONNULL_END
