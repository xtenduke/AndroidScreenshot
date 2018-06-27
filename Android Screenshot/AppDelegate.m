//
//  AppDelegate.m
//  Android Screenshot
//
//  Created by Jake on 6/03/16.
//  Copyright © 2016 Jake Laurie. All rights reserved.
//

#import "AppDelegate.h"
#import "ASUtil.h"

@interface AppDelegate () <NSUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    NSPipe *outPipe = [NSPipe pipe];
    NSString *launchPath = [ASUtil getPathToADB];
    
    if(!launchPath || launchPath.length == 0) {
        NSLog(@"adb not found on $PATH");
        exit(1);
    }
    
    NSArray<NSString *> *arguments = @[@"exec-out",
                                       @"screencap",
                                       @"-p"];
    
    
    NSFileHandle *fileHandle = [outPipe fileHandleForReading];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:launchPath];
    [task setStandardError:outPipe];
    [task setStandardOutput:outPipe];
    [task setArguments:arguments];
    
    [task launch];

    [ASUtil saveImageToFile:[fileHandle readDataToEndOfFile]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end
