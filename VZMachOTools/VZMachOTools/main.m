//
//  main.m
//  VZMachOTools
//
//  Created by moxin on 15/11/3.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        NSString *byteOrder = [NSString stringWithFormat:@"%x",CFSwapInt32(0x12345678)];
        NSLog(@"%@",byteOrder);
    }
    return 0;
}
