/*
 * Copyright (c) 2013-2015 by appPlant UG. All rights reserved.
 *
 * @APPPLANT_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apache License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://opensource.org/licenses/Apache-2.0/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPPLANT_LICENSE_HEADER_END@
 */


#import "SilentMode.h"
#import "SharkfoodMuteSwitchDetector.h"


@interface SilentMode ()

// Retrieves the application state
@property (readonly, getter=applicationState) NSString* applicationState;
// All events will be queued until deviceready has been fired
@property (readwrite, assign) BOOL deviceready;
// Event queue
@property (readonly, nonatomic, retain) NSMutableArray* eventQueue;
// Needed when calling `registerPermission`
@property (nonatomic, retain) CDVInvokedUrlCommand* command;

@end

@implementation SilentMode

@synthesize deviceready, eventQueue;

#pragma mark -
#pragma mark Interface

/**
 * Execute all queued events.
 */
- (void) deviceready:(CDVInvokedUrlCommand*)command
{
    deviceready = YES;

    
    // for (NSString* js in eventQueue) {
    //     [self.commandDelegate evalJs:js];
    // }

    // [eventQueue removeAllObjects];

}


#pragma mark -
#pragma mark Life Cycle

/**
 * Registers obervers after plugin was initialized.
 */
- (void) pluginInitialize
{
    NSNotificationCenter* center = [NSNotificationCenter
                                    defaultCenter];

    eventQueue = [[NSMutableArray alloc] init];

    [center addObserver:self
               selector:@selector(didReceiveLocalNotification:)
                   name:CDVLocalNotification
                 object:nil];

    [center addObserver:self
               selector:@selector(didFinishLaunchingWithOptions:)
                   name:UIApplicationDidFinishLaunchingNotification
                 object:nil];

    [center addObserver:self
               selector:@selector(didRegisterUserNotificationSettings:)
                   name:UIApplicationRegisterUserNotificationSettings
                 object:nil];
}

/**
 * Clears all single repeating notifications which are older then 5 days
 * before the app terminates.
 */
- (void) onAppTerminate
{
    [self cancelAllNotificationsWhichAreOlderThen:432000];
}

#pragma mark -
#pragma mark Helper

/**
 * Retrieves the application state
 *
 * @return
 *      Either "background" or "foreground"
 */
- (NSString*) applicationState
{
    UIApplicationState state = [self.app applicationState];

    bool isActive = state == UIApplicationStateActive;

    return isActive ? @"foreground" : @"background";
}

/**
 * Simply invokes the callback without any parameter.
 */
- (void) execCallback:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:result
                                callbackId:command.callbackId];
}

/**
 * Short hand for shared application instance.
 */
- (UIApplication*) app
{
    return [UIApplication sharedApplication];
}


@end