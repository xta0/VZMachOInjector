//
//  VZMachOFatHeader.h
//  VZMachOTools
//
//  Created by moxin on 15/11/10.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VZMachOFatHeader : NSObject

@property(nonatomic,assign,readonly)NSUInteger headerSize;
@property(nonatomic,assign,readonly)NSUInteger numberOfArchitechture;
@property(nonatomic,strong,readonly)NSArray* fatArchHeaders;

+ (instancetype)fatHeaderWithBinary:(NSData* )binary;


@end

@interface VZMachOFatArcHeader : NSObject

@property(nonatomic,assign,readonly)NSUInteger headerSize;
@property(nonatomic,assign,readonly)NSUInteger offset;

@end
