//
//  VZMachOManager.m
//  VZMachOTools
//
//  Created by moxin on 15/11/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZMachOManager.h"
#import "VZMachOHeader.h"
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

- (BOOL)loadBinary:(NSString* )path
{
    NSData *originalData = [NSData dataWithContentsOfFile:path];
    NSMutableData *binary = originalData.mutableCopy;
    
    if (!binary) {
        return NO;
    }
    
    uint32_t magic = [binary vz_intFromLoc:0];
    NSLog(@"magic header is : %x",magic);
    
    bool shouldSwap = vz_should_swap(magic);
    
    // a FAT file is basically a collection of thin MachO binaries
    if (magic == FAT_CIGAM || magic == FAT_MAGIC) {
        NSLog(@"Found FAT Header");
        
        struct fat_header fat = *(struct fat_header *)binary.bytes;
        fat.nfat_arch = CFSwapInt32(fat.nfat_arch); //标识fat_header下有几个fat_arch结构
        int offset = sizeof(struct fat_header);
        
        //生成headers
        for (int i=0; i<fat.nfat_arch; i++)
        {
            struct fat_arch arch;
            arch = *(struct fat_arch* )([binary bytes] + offset);
            NSUInteger header_offset  = shouldSwap?CFSwapInt32(arch.offset):arch.offset;
            VZMachOHeader* header = [VZMachOHeader headerWithBinary:originalData Offset:header_offset];
            
            //支持支x_86,arm,arm64三种CPU类型
            if (header.isAvailable) {
                [_headers addObject:header];
            }
            
            offset += sizeof(struct fat_arch);
        }
    }
    //thin header
    else if (magic == MH_MAGIC || magic == MH_MAGIC_64)
    {
         VZMachOHeader* header = [VZMachOHeader headerWithBinary:originalData Offset:0];
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


- (NSArray* )headers
{
    return [_headers copy];
}

@end
