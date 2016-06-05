//
//  AUKObjectType.h
//  AppUsageKit
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const AUKObjectTypeIdentifierApp;
extern NSString * const AUKObjectTypeIdentifierUsage;
extern NSString * const AUKObjectTypeIdentifierLifecycle;

@interface AUKObjectType : NSObject

/*!
 @property      identifier
 @abstract      A unique string identifying a type of object.
 */
@property (readonly, strong) NSString *identifier;

- (instancetype)init NS_UNAVAILABLE;

+ (nullable AUKObjectType *)objectTypeForIdentifier:(NSString *)identifier;

@end

@interface AUKAppType : AUKObjectType

@end

@interface AUKUsageType : AUKObjectType

@end

@interface AUKLifecycleType : AUKObjectType

@end

NS_ASSUME_NONNULL_END