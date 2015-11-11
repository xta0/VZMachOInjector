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
#import "VZMachOExcutable.h"
#import "NSData+Bytes.h"
#import "VZMachODefines.h"
#import <mach-o/loader.h>
#import <mach-o/fat.h>

@interface VZMachOManager()


@end

@implementation VZMachOManager
{
    NSMutableData* _pBinary;
    NSMutableArray* _archs;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        _archs = [NSMutableArray new];
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

- (NSArray* )machoExcutables
{
    return [_archs copy];
}

- (BOOL)loadBinary:(NSString* )path
{
    NSData *originalData = [NSData dataWithContentsOfFile:path];
    NSMutableData *binary = originalData.mutableCopy;
    _pBinary = binary;
    
    if (!binary) {
        return NO;
    }
    
    //magic header
    uint32_t magic = [binary vz_intFromLoc:0];

    // a FAT file is basically a collection of thin MachO binaries
    if (magic == FAT_CIGAM || magic == FAT_MAGIC) {

        _binaryHasFatHeader = YES;
        _fatHeader = [VZMachOFatHeader fatHeaderWithBinary:originalData];
        [_fatHeader.fatArchHeaders enumerateObjectsUsingBlock:^(VZMachOFatArcHeader* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            VZMachOExcutable* executable = [VZMachOExcutable excutableWithBinary:originalData Offset:obj.offset];
            if (executable.isExcutableAvailable) {
                [_archs addObject:executable];
            }
        }];
    }
    //thin header
    else if (magic == MH_MAGIC || magic == MH_MAGIC_64)
    {
        VZMachOExcutable* executable = [VZMachOExcutable excutableWithBinary:originalData Offset:0];
        if (executable.isExcutableAvailable) {
            [_archs addObject:executable];
        }
        
    }
    else{
        NSLog(@"no headers found.");
    }
    
    //chack to see if cycrptid is zero
    
    
    return YES;
}

- (void)unloadBinary
{
    _pBinary = NULL;
}

- (BOOL)rewriteBinary

{
    return [_pBinary writeToFile:@"./out" atomically:YES];
}




@end
