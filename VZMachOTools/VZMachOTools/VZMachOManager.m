//
//  VZMachOManager.m
//  VZMachOTools
//
//  Created by moxin on 15/11/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZMachOManager.h"
#import "VZMachOFatHeader.h"
#import "VZMachOArcHeader.h"
#import "NSData+Bytes.h"
#import "VZMachODefines.h"
#import <mach-o/loader.h>
#import <mach-o/fat.h>

@interface VZMachOManager()


@end

@implementation VZMachOManager
{
    uint8_t* _pBinary;
    NSMutableArray* _headers;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _headers = [NSMutableArray new];
        _binaryHasFatHeader = NO;
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static VZMachOManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [VZMachOManager new];
    });
    return manager;
}

- (NSArray* )archHeaders
{
    return [_headers copy];
}

- (BOOL)loadBinary:(NSString* )path
{
    NSData *originalData = [NSData dataWithContentsOfFile:path];
    NSMutableData *binary = originalData.mutableCopy;
    
    if (!binary) {
        return NO;
    }
    
    uint32_t magic = [binary vz_intFromLoc:0];

    // a FAT file is basically a collection of thin MachO binaries
    if (magic == FAT_CIGAM || magic == FAT_MAGIC) {

        _binaryHasFatHeader = YES;
        _fatHeader = [VZMachOFatHeader fatHeaderWithBinary:originalData];
        [_fatHeader.fatArchHeaders enumerateObjectsUsingBlock:^(VZMachOFatArcHeader* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VZMachOArcHeader* arcHeader = [VZMachOArcHeader headerWithBinary:originalData Offset:obj.offset];
            
            if (arcHeader.isAvailable) {
                [_headers addObject:arcHeader];
            }
        }];
    }
    //thin header
    else if (magic == MH_MAGIC || magic == MH_MAGIC_64)
    {
         VZMachOArcHeader* header = [VZMachOArcHeader headerWithBinary:originalData Offset:0];
        if (header.isAvailable) {
            [_headers addObject:header];
        }
        
    }
    else{
        NSLog(@"no headers found.");
    }
    
    return YES;
}

- (void)unloadBinary
{
    _pBinary = NULL;
}



- (BOOL)removeEncryption
{
    if (_pBinary == NULL) {
        return NO;
    }

        return YES;
}


- (BOOL)removeSignature
{
    if (_pBinary == NULL) {
        return NO;
    }

        return YES;
}

@end
