//
//  NSData+Bytes.h
//  VZMachOTools
//
//  Created by moxin on 15/11/5.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Bytes)

- (uint8_t)vz_byteFromLoc:(NSUInteger)offset;
- (uint16_t)vz_shortFromLoc:(NSUInteger)offset;
- (uint32_t)vz_intFromLoc:(NSUInteger)offset;
- (uint64_t)vz_longFromLoc:(NSUInteger)offset;

@end
