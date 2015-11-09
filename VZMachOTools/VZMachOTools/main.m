//
//  main.m
//  VZMachOTools
//
//  Created by moxin on 15/11/3.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZMachOManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        const char* str = argv[1];
        [[VZMachOManager sharedInstance] loadBinary:[NSString stringWithUTF8String:str]];
        
    }
    return 0;
}
