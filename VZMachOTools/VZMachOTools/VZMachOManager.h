//
//  VZMachOManager.h
//  VZMachOTools
//
//  Created by moxin on 15/11/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZMachOHeader;
@interface VZMachOManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)loadBinary:(NSString* )path;

- (void)unloadBinary;

- (NSArray* )headers;

@end
