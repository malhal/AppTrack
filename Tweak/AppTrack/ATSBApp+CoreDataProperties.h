//
//  ATSBApp+CoreDataProperties.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ATSBApp.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATSBApp (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bundleVersion;
@property (nullable, nonatomic, retain) NSString *bundleIdentifier;
@property (nullable, nonatomic, retain) NSSet<ATSBUsage *> *usages;
@property (nullable, nonatomic, retain) NSSet<ATSBLifecycle *> *lifecycles;

@end

@interface ATSBApp (CoreDataGeneratedAccessors)

- (void)addUsagesObject:(ATSBUsage *)value;
- (void)removeUsagesObject:(ATSBUsage *)value;
- (void)addUsages:(NSSet<ATSBUsage *> *)values;
- (void)removeUsages:(NSSet<ATSBUsage *> *)values;

- (void)addLifecyclesObject:(ATSBLifecycle *)value;
- (void)removeLifecyclesObject:(ATSBLifecycle *)value;
- (void)addLifecycles:(NSSet<ATSBLifecycle *> *)values;
- (void)removeLifecycles:(NSSet<ATSBLifecycle *> *)values;

@end

NS_ASSUME_NONNULL_END
