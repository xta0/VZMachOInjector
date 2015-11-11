//
//  main.m
//  VZMachOTools
//
//  Created by moxin on 15/11/3.
//  Copyright © 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VZMachOManager.h"
#import "VZMachOExcutable.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
       
        const char* str = argv[1];
        VZMachOManager* manager = [VZMachOManager sharedInstance];
        BOOL ret = [manager loadBinary:[NSString stringWithUTF8String:str]];
        if (ret) {
            
            BOOL shouldRewriteBinary = NO;
            for (VZMachOExcutable* excutable in manager.machoExcutables) {
                
                if (excutable.isExcutableAvailable) {
                    
                    if (excutable.isExcutableEncypted) {
                        
                        [excutable removeEncryption];
                        [excutable removeCodeSignature];
                        shouldRewriteBinary = YES;
                    }
                }
            }
            
            if (shouldRewriteBinary) {
                //重新生成binary
                if ([manager rewriteBinary]) {
                    NSLog(@"Rewrite binary succeed!");
                }
                else{
                    NSLog(@"Rewrite binary failed!");
                }
            }
        }
        else{
            NSLog(@"Read binary failed!");
        }
        
        
    }
    return 0;
}
