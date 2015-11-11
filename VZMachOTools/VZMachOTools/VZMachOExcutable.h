//
//  VZMachOArchObject.h
//  VZMachOTools
//
//  Created by moxin on 15/11/11.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VZMachOArcHeader;
@interface VZMachOExcutable : NSObject

@property(nonatomic,assign,readonly)BOOL isExcutableAvailable;
@property(nonatomic,assign,readonly)BOOL isExcutableEncypted;
@property(nonatomic,strong,readonly)VZMachOArcHeader* excutableHeader;
@property(nonatomic,strong,readonly)NSArray* loadCommands;

+ (instancetype)excutableWithBinary:(NSData* )binary Offset:(NSUInteger)offset;

- (void)removeEncryption;
- (void)removeCodeSignature;

@end
