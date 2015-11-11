//
//  VZMachOHeader.h
//  VZMachOTools
//
//  Created by moxin on 15/11/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface VZMachOArcHeader : NSObject

@property(nonatomic,assign,readonly)BOOL isAvailable;
@property(nonatomic,assign,readonly)BOOL is64bit;
@property(nonatomic,assign,readonly)NSUInteger headerSize;
@property(nonatomic,strong,readonly)NSString*  cpuType;
@property(nonatomic,assign,readonly)NSUInteger numberOfLoadCommands;
@property(nonatomic,assign,readonly)NSUInteger sizeOfAllLoadCommnads;


+ (instancetype)headerWithBinary:(NSData* )binary Offset:(NSUInteger)offset;

@end
