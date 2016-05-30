#include <objc/runtime.h>
#include <objc/message.h>
#include <CydiaSubstrate/CydiaSubstrate.h>
#import "ATSBManager.h"
#import "ATSBApp.h"
#import "ATSBUsage.h"
#import "ATSBLifecycle.h"
#import <MHData/NSManagedObjectContext+MH.h>

//Make sure you codesign

// When in an app and bringing notification center then tapping a notifiatin that takes to another app, activate new app is called before deactivate old app.
// Same for app switcher.

// replaced_SBApplication_didActivateForScene called twice brining down NC in an app.

// replaced_SBApplication_didActivateForScene called one leaving NC in an app.

// willActivate and willDeactivateForEventsOnly seem best. It's not ideal the activate is called before the deactivate for switching to an app while in an app but that's ok.

// The forScene methods seem related to animations and fire duplicates and are a bit strange so not using them.

// the default store would have been file:///var/mobile/Library/Application%20Support/SpringBoard/com.apple.springboard.sqlite

@interface SBApplication

- (void)willActivate;
- (void)willDeactivateForEventsOnly:(BOOL)arg1;
- (NSString*)bundleIdentifier;
- (NSString*)bundleVersion;

@end

@interface SpringBoard

- (void)frontDisplayDidChange:(id)arg1;
- (id)_accessibilityFrontMostApplication;

@end

@interface SBApplicationController <NSObject>

- (void)_sendInstalledAppsDidChangeNotification:(id)arg1 removed:(id)arg2 modified:(id)arg3;
- (SBApplication*)applicationWithBundleIdentifier:(id)arg1; // from iOS 8
- (SBApplication*)applicationWithDisplayIdentifier:(id)arg1; // iOS 7 possibly below but not checked

@end

/*
void (*original_SBApplication_willActivate)(SBApplication* self, SEL sel);
static void replaced_SBApplication_willActivate(SBApplication* self, SEL sel){
    NSLog(@"original_SBApplication_willActivate");
    NSLog(@"bundleIdentifier %@", self.bundleIdentifier);    
    NSLog(@"%@",[NSThread callStackSymbols]);
    
    objc_setAssociatedObject(self, "at_startDate", [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    (*original_SBApplication_willActivate)(self,sel);
}


void (*original_SBApplication_willDeactivateForEventsOnly)(SBApplication* self, SEL sel, BOOL eventsOnly);
static void replaced_SBApplication_willDeactivateForEventsOnly(SBApplication* self, SEL sel, BOOL eventsOnly){
    (*original_SBApplication_willDeactivateForEventsOnly)(self,sel,eventsOnly);
    
    NSLog(@"original_SBApplication_willDeactivateForEventsOnly %d", eventsOnly);
    NSLog(@"bundleIdentifier %@", self.bundleIdentifier);
    NSLog(@"%@",[NSThread callStackSymbols]);
    
    // get the start date and clear it
    NSDate* startDate = objc_getAssociatedObject(self, "at_startDate");
    if(!startDate){
        return;
    }
    objc_setAssociatedObject(self, "at_start", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    ATSBManager* a = [ATSBManager sharedManager];
    NSManagedObjectContext* c = a.mainContext;
    c.undoManager = [[NSUndoManager alloc] init];
    
    NSDictionary* dict = @{@"bundleIdentifier" : self.bundleIdentifier,
                           @"bundleVersion" : self.bundleVersion};
    BOOL inserted;
    NSError* error;
    ATSBApp* app = (ATSBApp*)[c mh_fetchOrInsertObjectWithEntityName:[ATSBApp entityName] dictionary:dict inserted:&inserted error:&error];
    if(app){
        ATSBUsage* track = (ATSBUsage*)[c mh_insertNewObjectForEntityName:[ATSBUsage entityName]];
        track.app = app;
        track.startDate = startDate;
        // set how long the app was used.
        track.endDate = [NSDate date]; //@(-[track.start timeIntervalSinceNow]); // it validates a rule with >= 0
        
        if(![c save:&error]){ // errors if duration is negative
            NSLog(@"save error %@", error);
            // just now the track gets left with a null duration.
        }else{
            NSLog(@"successfully saved usage");
        }
    }else{
        NSLog(@"error fetching app %@", error);
    }
    // undo if any errors so future saves can work.
    if(error){
        [c.undoManager undo];
    }
    c.undoManager = nil;
}
*/

static BOOL _first = YES;

void (*original_SBApplicationController_sendInstalledAppsDidChangeNotification$removed$modified$)(SBApplicationController* self, SEL sel, NSArray* added, NSArray* removed, NSArray* modified);
static void replaced_SBApplicationController_sendInstalledAppsDidChangeNotification$removed$modified$(SBApplicationController* self, SEL sel, NSArray* added, NSArray* removed, NSArray* modified){
(*original_SBApplicationController_sendInstalledAppsDidChangeNotification$removed$modified$)(self,sel,added,removed,modified);
    
    NSLog(@"replaced_SBApplicationController_sendInstalledAppsDidChangeNotification$removed$modified$");
    NSLog(@"%@",[NSThread callStackSymbols]);
    
    ATSBManager* a = [ATSBManager sharedManager];
    NSManagedObjectContext* c = a.mainContext;
    
    // the first notification includes all applications added again when springboard starts.
    if(_first){
        _first = NO;
        
        // count how many we have to see if this is the first ever.
        NSFetchRequest* countRequest = [NSFetchRequest fetchRequestWithEntityName:[ATSBLifecycle entityName]];
        NSUInteger count = [c countForFetchRequest:countRequest error:nil];
        
        // skip this event if it is not the first ever.
        if(count != 0){
            return;
        }
    }

    NSDate* date = [NSDate date];
    c.undoManager = [[NSUndoManager alloc] init];
    
    // only returns false in case of database error.
    BOOL (^insertLifecycle)(NSString* bundleIdentifier, ATSBLifecycleChangeType changeType, NSError** error) = ^BOOL(NSString* bundleIdentifier, ATSBLifecycleChangeType changeType, NSError** error){
        
        SBApplication* application = nil;
        if([self respondsToSelector:@selector(applicationWithBundleIdentifier:)]){
            application = [self applicationWithBundleIdentifier:bundleIdentifier];
        }else if([self respondsToSelector:@selector(applicationWithDisplayIdentifier:)]){
            application = [self applicationWithDisplayIdentifier:bundleIdentifier];
        }
        
        if(!application){
            // if we didn't get an application for whatever reason just skip this app
            NSLog(@"skipping because didn't get application");
            return YES;
        }
        
        NSString* bundleVersion = application.bundleVersion;
    
        // we either don't get a bundleVersion if the app doesn't have one, or if this is a remove because the SBApplication has already gone.
        if(!bundleVersion){
            if(changeType != ATSBLifecycleChangeTypeRemoved){
                NSLog(@"skipping because missing version");
                // just skip if there is no version which might happen with a non-conforming Cydia app like Activator.
                return YES;
            }
            // if this is a remove it doenst usually have a version so we need to look it up in its last lifecycle
            NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[ATSBLifecycle entityName]];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"app.bundleIdentifier = %@", bundleIdentifier];
            fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
            fetchRequest.resultType = NSDictionaryResultType;
            fetchRequest.fetchLimit = 1;
            fetchRequest.propertiesToFetch = @[@"app.bundleVersion"];
            NSArray* results = [c executeFetchRequest:fetchRequest error:nil];
            bundleVersion = results.firstObject[@"app.bundleVersion"];
            // If we still didn't get one so just skip this app.
            if(!bundleVersion){
                NSLog(@"skipping because still missing version");
                return YES;
            }
        }
        
        // if its Modify, get the most recent entry for this app and if it was modify then just skip it
        // to prevent so many duplicates of re-deployed apps.
        
        NSDictionary* dict = @{@"bundleIdentifier" : bundleIdentifier,
                               @"bundleVersion" : bundleVersion};
        BOOL inserted;
        ATSBApp* app = (ATSBApp*)[c mh_fetchOrInsertObjectWithEntityName:[ATSBApp entityName] dictionary:dict inserted:&inserted error:error];
        if(!app){
            NSLog(@"error fetching/inserting app %@", *error);
            return NO;
        }
        ATSBLifecycle* lifecycle = (ATSBLifecycle*)[c mh_insertNewObjectForEntityName:[ATSBLifecycle entityName]];
        lifecycle.app = app;
        lifecycle.date = date;
        lifecycle.changeType = changeType;
        return YES;
    };
    
    NSError* error;
    for(NSString* bundleIdentifier in added){
        if(!insertLifecycle(bundleIdentifier, ATSBLifecycleChangeTypeAdded, &error)){
            break;
        }
    }
    
    if(!error){
        for(NSString* bundleIdentifier in modified){
            if(!insertLifecycle(bundleIdentifier, ATSBLifecycleChangeTypeModified, &error)){
                break;
            }
        }
    }
    
    if(!error){
        for(NSString* bundleIdentifier in removed){
            if(!insertLifecycle(bundleIdentifier, ATSBLifecycleChangeTypeRemoved, &error)){
                break;
            }
        }
    }
    
    if(!error){
        if(![c save:&error]){ // errors if validation failed.
            NSLog(@"save error %@", error);
            
            // just now the track gets left with a null duration.
        }else{
            NSLog(@"successfully saved lifecycle");
        }
    }
    
    // if we got an error undo all the changes, so the mistakes don't affect a future save.
    if(error){
        [c.undoManager undo];
    }
    
    c.undoManager = nil;
}

/*
void (*original_SBApplication_didActivateForScene$transactionID$)(SBApplication* self, SEL sel, id arg1, unsigned int arg2);
static void replaced_SBApplication_didActivateForScene$transactionID$(SBApplication* self, SEL sel, id arg1, unsigned int arg2){
    NSLog(@"replaced_SBApplication_didActivateForScene$transactionID$");
    NSLog(@"%@",[NSThread callStackSymbols]);
    (*original_SBApplication_didActivateForScene$transactionID$)(self,sel,arg1,arg2);
}

void (*original_SBApplication_willActivateForScene$transactionID$)(SBApplication* self, SEL sel, id arg1, unsigned int arg2);
static void replaced_SBApplication_willActivateForScene$transactionID$(SBApplication* self, SEL sel, id arg1, unsigned int arg2){
    NSLog(@"replaced_SBApplication_willActivateForScene$transactionID$");
    NSLog(@"%@",[NSThread callStackSymbols]);
    (*original_SBApplication_willActivateForScene$transactionID$)(self,sel,arg1,arg2);
}
 */

static NSDate* startDate = nil;
static NSString* prevBundleIdentifier = nil;
static NSString* prevBundleVersion = nil;

// sender can be an SBApplication or SBLockScreenViewController. Null when going to springboard or app switcher.
void (*original_SpringBoard_frontDisplayDidChange$)(SpringBoard* self, SEL sel, id sender);
static void replaced_SpringBoard_frontDisplayDidChange$(SpringBoard* self, SEL sel, id sender){
    NSLog(@"replaced_SpringBoard_frontDisplayDidChange$ %@", sender);
    (*original_SpringBoard_frontDisplayDidChange$)(self, sel, sender);
    
    //SBApplication* app = [self _accessibilityFrontMostApplication];
    //NSLog(@"_accessibilityFrontMostApplication %@", app.bundleIdentifier);
    
    // get the new app info
    NSString* bundleIdentifier = @"com.apple.Springboard";
    NSString* bundleVersion = @"1.0";
    Class $SBApplication(objc_getClass("SBApplication"));
    if(sender){
        if([sender isKindOfClass:$SBApplication]){
            // update bundle id to the app.
            SBApplication* app = (SBApplication*)sender;
            bundleIdentifier = app.bundleIdentifier.copy;
            bundleVersion = app.bundleVersion.copy;
        }else{
            // append the whatever class is to the springboard bundle id, should be com.apple.Springboard.SBLockScreenViewController but might be others.
            bundleIdentifier = [NSString stringWithFormat:@"com.apple.Springboard.%@", NSStringFromClass([sender class])];
        }
    }
    
    // if the app hasn't changed since last time do nothing
    if([prevBundleIdentifier isEqualToString:bundleIdentifier]){
        NSLog(@"App is same");
        return;
    }
    
    // save that we used the prev app we just changed from.
    if(startDate){
        ATSBManager* a = [ATSBManager sharedManager];
        NSManagedObjectContext* c = a.mainContext;
        c.undoManager = [[NSUndoManager alloc] init];
        
        NSDictionary* dict = @{@"bundleIdentifier" : prevBundleIdentifier,
                               @"bundleVersion" : prevBundleVersion};
        BOOL inserted;
        NSError* error;
        ATSBApp* app = (ATSBApp*)[c mh_fetchOrInsertObjectWithEntityName:[ATSBApp entityName] dictionary:dict inserted:&inserted error:&error];
        if(app){
            ATSBUsage* track = (ATSBUsage*)[c mh_insertNewObjectForEntityName:[ATSBUsage entityName]];
            track.app = app;
            track.startDate = startDate;
            // set how long the app was used.
            track.endDate = [NSDate date]; //@(-[track.start timeIntervalSinceNow]); // it validates a rule with >= 0
            
            if(![c save:&error]){ // errors if duration is negative
                NSLog(@"save error %@", error);
                // just now the track gets left with a null duration.
            }else{
                NSLog(@"successfully saved usage");
            }
        }else{
            NSLog(@"error fetching app %@", error);
        }
        // undo if any errors so future saves can work.
        if(error){
            [c.undoManager undo];
        }
        c.undoManager = nil;
    }
    
    // update the prev app to current.
    startDate = [NSDate date];
    prevBundleIdentifier = bundleIdentifier;
    prevBundleVersion = bundleVersion;
}

extern "C" void TweakInitialize() {
    
	NSLog(@"AppTrack: starting up...");
    
    [ATSBManager sharedManager];
    
    //Class $SBApplication(objc_getClass("SBApplication"));
    //MSHookMessageEx($SBApplication, @selector(willActivate), (IMP)&replaced_SBApplication_willActivate, (IMP*)&original_SBApplication_willActivate);

    //MSHookMessageEx($SBApplication, @selector(willDeactivateForEventsOnly:), (IMP)&replaced_SBApplication_willDeactivateForEventsOnly, (IMP*)&original_SBApplication_willDeactivateForEventsOnly);
    
    Class $SBApplicationController(objc_getClass("SBApplicationController"));
    MSHookMessageEx($SBApplicationController, @selector(_sendInstalledAppsDidChangeNotification:removed:modified:), (IMP)&replaced_SBApplicationController_sendInstalledAppsDidChangeNotification$removed$modified$, (IMP*)&original_SBApplicationController_sendInstalledAppsDidChangeNotification$removed$modified$);
    
    Class $SpringBoard(objc_getClass("SpringBoard"));
    MSHookMessageEx($SpringBoard, @selector(frontDisplayDidChange:), (IMP)&replaced_SpringBoard_frontDisplayDidChange$, (IMP*)&original_SpringBoard_frontDisplayDidChange$);
    
	NSLog(@"AppTrack: successfully started.");
}

