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
{

}

@property(nonatomic,strong)NSMutableData* binary;
@property(nonatomic,assign)BOOL isExcutableEncypted;
@property(nonatomic,strong)VZMachOArcHeader* excutableHeader;
@property(nonatomic,assign)NSUInteger cryptidOffset;

@end

@implementation VZMachOExcutable
{}

+ (instancetype)excutableWithBinary:(NSMutableData* )binary Offset:(NSUInteger)offset
{
    if (!binary) {
        return nil;
    }
    
    VZMachOExcutable* excutable = [VZMachOExcutable new];
    excutable.binary = binary;
    excutable.excutableHeader = [VZMachOArcHeader headerWithBinary:binary.copy Offset:offset];
    
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
                excutable.cryptidOffset = l_offset + sizeof(struct encryption_info_command) - sizeof(uint32_t);
                NSLog(@"cryptidOffset is : %lx",(unsigned long)excutable.cryptidOffset);

            }
        }
        
        if (cmd == LC_CODE_SIGNATURE) {
            
            struct linkedit_data_command* code_cmd = (struct linkedit_data_command* )(l_cmd);
            
            
        }
        l_offset +=  l_cmd->cmdsize;
    }
    
    return excutable;
}

- (BOOL)isExcutableAvailable
{
    return self.excutableHeader.isAvailable;
}

uint32_t CRYPTID_ZERO = 0x00000000;
- (void)removeEncryption
{
    if (self.isExcutableEncypted) {
        
        //set cryptid to 0:
        if (self.cryptidOffset > 0) {
           [self.binary replaceBytesInRange:NSMakeRange(self.cryptidOffset, sizeof(uint32_t)) withBytes:&CRYPTID_ZERO];
        }
    }

}
- (void)removeCodeSignature
{

}

@end
