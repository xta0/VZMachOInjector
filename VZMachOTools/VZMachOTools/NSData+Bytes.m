//
//  NSData+Bytes.m
//  VZMachOTools
//
//  Created by moxin on 15/11/5.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import "NSData+Bytes.h"

@implementation NSData (Bytes)

- (uint8_t)vz_byteFromLoc:(NSUInteger)offset
{
    uint8_t result;
    [self getBytes:&result range:NSMakeRange(offset, sizeof(result))];
    return result;
}

- (uint16_t)vz_shortFromLoc:(NSUInteger)offset
{
    uint16_t result;
    [self getBytes:&result range:NSMakeRange(offset, sizeof(result))];
    return result;
}

- (uint32_t)vz_intFromLoc:(NSUInteger)offset
{
    uint32_t result;
    [self getBytes:&result range:NSMakeRange(offset, sizeof(result))];
    return result;

}

- (uint64_t)vz_longFromLoc:(NSUInteger)offset
{
    uint64_t result;
    [self getBytes:&result range:NSMakeRange(offset, sizeof(result))];
    return result;

}

@end
