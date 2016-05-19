//
//  ATLifecycle.h
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <AppTrack/ATDefines.h>
#import <AppTrack/ATApp.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATLifecycle : ATApp

@property (readonly, strong) NSDate *date;

@property (readonly, assign) ATSBLifecycleChangeType changeType;

@end

NS_ASSUME_NONNULL_END