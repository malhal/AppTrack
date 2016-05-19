//
//  ATApp.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <AppTrack/ATObject.h>

@interface ATApp : ATObject

@property (readonly, strong) NSString *bundleIdentifier;
@property (readonly, strong) NSString *bundleVersion;

@end
