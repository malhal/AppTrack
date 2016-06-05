//
//  AUKTApp+CoreDataProperties.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AUKTApp.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUKTApp (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bundleVersion;
@property (nullable, nonatomic, retain) NSString *bundleIdentifier;
@property (nullable, nonatomic, retain) NSSet<AUKTUsage *> *usages;
@property (nullable, nonatomic, retain) NSSet<AUKTLifecycle *> *lifecycles;

@end

@interface AUKTApp (CoreDataGeneratedAccessors)

- (void)addUsagesObject:(AUKTUsage *)value;
- (void)removeUsagesObject:(AUKTUsage *)value;
- (void)addUsages:(NSSet<AUKTUsage *> *)values;
- (void)removeUsages:(NSSet<AUKTUsage *> *)values;

- (void)addLifecyclesObject:(AUKTLifecycle *)value;
- (void)removeLifecyclesObject:(AUKTLifecycle *)value;
- (void)addLifecycles:(NSSet<AUKTLifecycle *> *)values;
- (void)removeLifecycles:(NSSet<AUKTLifecycle *> *)values;

@end

NS_ASSUME_NONNULL_END
