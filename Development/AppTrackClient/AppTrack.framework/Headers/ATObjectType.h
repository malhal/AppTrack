//
//  ATObjectType.h
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ATObjectTypeIdentifierApp;
extern NSString * const ATObjectTypeIdentifierUsage;
extern NSString * const ATObjectTypeIdentifierLifecycle;

@interface ATObjectType : NSObject

/*!
 @property      identifier
 @abstract      A unique string identifying a type of object.
 */
@property (readonly, strong) NSString *identifier;

- (instancetype)init NS_UNAVAILABLE;

+ (nullable ATObjectType *)objectTypeForIdentifier:(NSString *)identifier;

@end

@interface ATAppType : ATObjectType

@end

@interface ATUsageType : ATObjectType

@end

@interface ATLifecycleType : ATObjectType

@end

NS_ASSUME_NONNULL_END