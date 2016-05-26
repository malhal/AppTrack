//
//  ATDefines.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define AT_EXTERN   extern __attribute__((visibility("default")))

AT_EXTERN NSString * const AppTrackErrorDomain;

typedef enum : int16_t{
    ATSBLifecycleChangeTypeAdded = 1,   // The app was installed. e.g. from the App Store
    ATSBLifecycleChangeTypeModified,    // The app was replaced, e.g. by Xcode deploy.
    ATSBLifecycleChangeTypeRemoved      // The app was uninstalled. e.g. by holding the app icon and tapping the x.
} ATSBLifecycleChangeType;

NS_ASSUME_NONNULL_END