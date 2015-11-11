//
//  VZMachOFatHeader.m
//  VZMachOTools
//
//  Created by moxin on 15/11/10.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZMachOFatHeader.h"
#import "VZMachODefines.h"
#import "NSData+Bytes.h"
#import <mach-o/loader.h>
#import <mach-o/fat.h>



@interface VZMachOFatArcHeader()

@property(nonatomic,assign)NSUInteger headerSize;
@property(nonatomic,assign)NSUInteger offset;

@end

@implementation VZMachOFatArcHeader

- (NSString* )description
{
    return [NSString stringWithFormat:@"FatArcHeader:{headerSize:%ld\n offset:%ld\n}",self.headerSize,self.offset];
}

@end

@interface VZMachOFatHeader()

@property(nonatomic,assign)NSUInteger headerSize;
@property(nonatomic,assign)NSUInteger numberOfArchitechture;
@property(nonatomic,strong)NSMutableArray* fatArchSubHeaders;

@end

@implementation VZMachOFatHeader

- (NSArray* )fatArchHeaders
{
    return [self.fatArchSubHeaders copy];
}

+ (instancetype)fatHeaderWithBinary:(NSData* )binary
{
    uint32_t magic = [binary vz_intFromLoc:0];
    BOOL shouldSwap = vz_should_swap(magic);
    
    VZMachOFatHeader* obj = [VZMachOFatHeader new];
    
    struct fat_header fatHeader = *(struct fat_header *)binary.bytes;
    fatHeader.nfat_arch = CFSwapInt32(fatHeader.nfat_arch); //标识fat_header下有几个fat_arch结构
    obj.headerSize = sizeof(struct fat_header);
    obj.numberOfArchitechture = fatHeader.nfat_arch;
    
    obj.fatArchSubHeaders = [NSMutableArray new];
    
    NSUInteger offset = obj.headerSize;
    for (int i=0; i<obj.numberOfArchitechture; i++) {
      
        struct fat_arch fatArc = *(struct fat_arch *)(binary.bytes + offset);
        
        VZMachOFatArcHeader* fatArcHeader = [VZMachOFatArcHeader new];
        fatArcHeader.headerSize = sizeof(struct fat_arch);
        fatArcHeader.offset = shouldSwap?CFSwapInt32(fatArc.offset):fatArc.offset;
        [obj.fatArchSubHeaders addObject:fatArcHeader];
        
        offset += sizeof(struct fat_arch);
    }
    
    return obj;
}

- (NSString* )description
{
    return [NSString stringWithFormat:@"FatHeader:{\nheaderSize:%ld\nnumberOfArchs:%ld\n }",self.headerSize,self.numberOfArchitechture];
}


@end
