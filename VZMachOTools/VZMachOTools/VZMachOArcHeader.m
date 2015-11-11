//
//  VZMachOHeader.m
//  VZMachOTools
//
//  Created by moxin on 15/11/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZMachOArcHeader.h"
#import "NSData+Bytes.h"
#import "VZMachODefines.h"
#import <mach-o/loader.h>
#import <mach-o/fat.h>

@interface VZMachOArcHeader()

@property(nonatomic,assign)BOOL isAvailable;
@property(nonatomic,assign)BOOL is64bit;
@property(nonatomic,assign)NSUInteger headerSize;
@property(nonatomic,assign)NSUInteger numberOfLoadCommands;
@property(nonatomic,assign)NSUInteger sizeOfAllLoadCommnads;
@property(nonatomic,strong)NSString* cpuType;

@end

@implementation VZMachOArcHeader

+ (instancetype)headerWithBinary:(NSData* )binary Offset:(NSUInteger)offset
{
    VZMachOArcHeader* obj = [VZMachOArcHeader new];
    
    struct mach_header header = *(struct mach_header* )(binary.bytes + offset);
    if (header.magic == MH_MAGIC || header.magic == MH_CIGAM)
    {
        obj.is64bit = NO;
        obj.headerSize = sizeof(struct mach_header);
    }
    else{
        obj.is64bit = YES;
        obj.headerSize = sizeof(struct mach_header_64);
    }
    
    cpu_type_t cpu_t = header.cputype;
    
    if (cpu_t == CPU_TYPE_X86_64 || cpu_t == CPU_TYPE_X86 ||
        cpu_t == CPU_TYPE_ARM || cpu_t == CPU_TYPE_ARM64)
    {
        obj.isAvailable = YES;
    }
    else
    {
        obj.isAvailable = NO;
    }
    
    obj.cpuType = [self cpuDesc:cpu_t];
    obj.numberOfLoadCommands  = header.ncmds;
    obj.sizeOfAllLoadCommnads = header.sizeofcmds;
    
    
    return obj;
}


+ (NSString* )cpuDesc:(cpu_type_t)type
{
    if (type == CPU_TYPE_X86_64) {
        return @"x86_64";
    }
    else if (type == CPU_TYPE_X86){
        return @"x86";
    }
    else if (type == CPU_TYPE_ARM){
        return @"arm";
    }
    else if (type == CPU_TYPE_ARM64)
    {
        return @"arm_64";
    }
    else{
        return @"";
    }
}

- (NSString* )description
{
    return [NSString stringWithFormat:@"ArchHeader:{\nisAvailable:%d\nis64Bit:%d\nheaderSize:%ld\ncpu:%@ \nloadCommands:%ld\nsizeOfCommands:%ld\n }",self.isAvailable,self.is64bit,self.headerSize,self.cpuType,self.numberOfLoadCommands,self.sizeOfAllLoadCommnads];
}


@end
