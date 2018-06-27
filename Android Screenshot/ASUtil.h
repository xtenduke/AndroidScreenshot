//
//  ASUtil.h
//  Android Screenshot
//
//  Created by Jake on 7/03/16.
//  Copyright © 2016 Jake Laurie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASUtil : NSObject

+ (void)saveImageToFile:(NSData *)data;
+ (NSString *)getPathToADB;

@end
