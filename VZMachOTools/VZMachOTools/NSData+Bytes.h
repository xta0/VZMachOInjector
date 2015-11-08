//
//  NSData+Bytes.h
//  VZMachOTools
//
//  Created by moxin on 15/11/5.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Bytes)

- (uint8_t)byteFromLoc:(NSUInteger)offset;
- (uint16_t)shortFromLoc:(NSUInteger)offset;
- (uint32_t)intFromLoc:(NSUInteger)offset;
- (uint64_t)longFromLoc:(NSUInteger)offset;

@end
