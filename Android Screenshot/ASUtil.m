//
//  ASUtil.m
//  Android Screenshot
//
//  Created by Jake on 7/03/16.
//  Copyright © 2016 Jake Laurie. All rights reserved.
//

#import "ASUtil.h"
#import <AppKit/AppKit.h>

@implementation ASUtil

NSString *const FILE_TYPE = @".png";

+ (NSString *)getFileName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH.mm.ss a"];
    
    return [NSString stringWithFormat:@"Android Screen at %@%@",
            [formatter stringFromDate:[NSDate new]], FILE_TYPE]; //Example "Android Screen at 2016-03-07_01.17.29 AM.png"
}

+ (NSString *)getSavePath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:[self getFileName]];
}

+ (void)saveImageToFile:(NSData *)data {
    NSString *notificationMessage;
    if([self dataIsValidImage:data]) {
        notificationMessage = [NSString stringWithFormat:@"Image saved as %@", [self getSavePath]];
        [data writeToFile:[self getSavePath] atomically:NO];
    } else {
        notificationMessage = @"Failed to retrieve screenshot";
    }
    
    [self showNotificationWithTitle:[self getAppName] body:notificationMessage];
    [NSApp terminate:self];
}

+ (BOOL)dataIsValidImage:(NSData *)data {
    return [[NSImage alloc] initWithData:data] != nil;
}

+ (void)showNotificationWithTitle:(NSString *)title body:(NSString *)body {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:title];
    [notification setInformativeText:body];
    [notification setSoundName:NSUserNotificationDefaultSoundName];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

+ (NSString *)getPathToADB {
    NSPipe *outPipe = [NSPipe pipe];
    NSFileHandle *fileHandle = [outPipe fileHandleForReading];
    
    NSArray	*args = [NSArray arrayWithObjects:@"-l",
                     @"-c",
                     @"which -a adb", //get path to 'adb' from $PATH
                     nil];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:args];
    [task setStandardError:outPipe];
    [task setStandardOutput:outPipe];
    [task launch];
    
    NSString *str = [[NSString alloc] initWithData:[fileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}

+ (NSString *)getAppName {
    return [[[NSBundle mainBundle] infoDictionary]  objectForKey:(id)kCFBundleNameKey];
}

@end
