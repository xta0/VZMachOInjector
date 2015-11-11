//
//  VZMachOManager.h
//  VZMachOTools
//
//  Created by moxin on 15/11/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZMachOFatHeader;
@interface VZMachOManager : NSObject

@property(nonatomic,assign,readonly)BOOL binaryHasFatHeader;
@property(nonatomic,strong,readonly)VZMachOFatHeader* fatHeader;
@property(nonatomic,strong,readonly)NSArray* machoExcutables;


+ (instancetype)sharedInstance;

- (BOOL)loadBinary:(NSString* )path;

- (void)unloadBinary;

- (BOOL)rewriteBinary;


@end
