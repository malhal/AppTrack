//
//  AUKTLifecycle+CoreDataProperties.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AUKTLifecycle.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUKTLifecycle (CoreDataProperties)

//@property (nullable, nonatomic, retain) NSNumber *changeType;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) AUKTApp *app;

@end

NS_ASSUME_NONNULL_END
