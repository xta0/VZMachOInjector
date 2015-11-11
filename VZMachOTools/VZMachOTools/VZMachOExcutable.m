//
//  VZMachOArchObject.m
//  VZMachOTools
//
//  Created by moxin on 15/11/11.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "VZMachOExcutable.h"
#import "VZMachOArcHeader.h"
#import "NSData+Bytes.h"
#import "VZMachODefines.h"
#import <mach-o/loader.h>
#import <mach-o/fat.h>

@interface VZMachOExcutable()

@property(nonatomic,assign)BOOL isExcutableEncypted;
@property(nonatomic,strong)VZMachOArcHeader* excutableHeader;
@property(nonatomic,strong)NSMutableArray* loadCommandsInternal;

@end

@implementation VZMachOExcutable
{}

+ (instancetype)excutableWithBinary:(NSData* )binary Offset:(NSUInteger)offset
{
    VZMachOExcutable* excutable = [VZMachOExcutable new];
    excutable.excutableHeader = [VZMachOArcHeader headerWithBinary:binary Offset:offset];
    
    NSUInteger l_offset = offset+ excutable.excutableHeader.headerSize;
    for (int i=0; i<excutable.excutableHeader.numberOfLoadCommands; i++)
    {
        struct load_command* l_cmd = (struct load_command* )(binary.bytes+l_offset);
        uint32_t cmd = l_cmd -> cmd;
        
        if (cmd == LC_ENCRYPTION_INFO) {
            
            struct encryption_info_command e_cmd = *(struct encryption_info_command* )l_cmd;
            
            if (e_cmd.cryptid == 0)
            {
                excutable.isExcutableEncypted = NO;
            }
            else
            {
                excutable.isExcutableEncypted = YES;
            }
        }
        
        
        l_offset += l_cmd->cmdsize;
    }
    
    return excutable;
}

- (BOOL)isExcutableAvailable
{
    return self.excutableHeader.isAvailable;
}


- (void)removeEncryption
{
    if (self.isExcutableEncypted) {
        
        
    }

}
- (void)removeCodeSignature
{

}

@end
