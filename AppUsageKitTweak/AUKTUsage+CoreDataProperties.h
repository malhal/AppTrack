//
//  AUKTUsage+CoreDataProperties.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AUKTUsage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUKTUsage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) AUKTApp *app;

@end

NS_ASSUME_NONNULL_END
