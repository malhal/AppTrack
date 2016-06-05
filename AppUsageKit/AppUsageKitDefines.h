//
//  AppUsageKitDefines.h
//  AppUsageKit
//
//  Created by Malcolm Hall on 26/01/2016.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define AUK_EXTERN   extern __attribute__((visibility("default")))

AUK_EXTERN NSString * const AppUsageKitErrorDomain;

AUK_EXTERN NSString * const AppUsageKitMessagingCenterName;

typedef enum : int16_t{
    AUKLifecycleChangeTypeAdded = 1,   // The app was installed. e.g. from the App Store
    AUKLifecycleChangeTypeModified,    // The app was replaced, e.g. by Xcode deploy.
    AUKLifecycleChangeTypeRemoved      // The app was uninstalled. e.g. by holding the app icon and tapping the x.
} AUKLifecycleChangeType;

NS_ASSUME_NONNULL_END