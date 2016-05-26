//
//  ATSBUsage+CoreDataProperties.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ATSBUsage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATSBUsage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) ATSBApp *app;

@end

NS_ASSUME_NONNULL_END
