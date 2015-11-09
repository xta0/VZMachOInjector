//
//  VZMachOHeader.h
//  VZMachOTools
//
//  Created by moxin on 15/11/8.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>



/*
 *	uint32_t	magic;		/* mach magic number identifier */
//cpu_type_t	cputype;	/* cpu specifier */
//cpu_subtype_t	cpusubtype;	/* machine specifier */
//uint32_t	filetype;	/* type of file */
//uint32_t	ncmds;		/* number of load commands */
//uint32_t	sizeofcmds;	/* the size of all the load commands */





@interface VZMachOHeader : NSObject

@property(nonatomic,assign,readonly)BOOL isAvailable;
@property(nonatomic,assign,readonly)BOOL is64bit;
@property(nonatomic,assign,readonly)NSUInteger headerSize;
@property(nonatomic,strong,readonly)NSString*  cpuType;
@property(nonatomic,assign,readonly)NSUInteger numberOfLoadCommands;
@property(nonatomic,assign,readonly)NSUInteger sizeOfAllLoadCommnads;




+ (instancetype)headerWithBinary:(NSData* )binary Offset:(NSUInteger)offset;

@end
