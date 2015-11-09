//
//  VZMachODefines.h
//  VZMachOTools
//
//  Created by moxin on 15/11/8.
//  CVZyright © 2015年 VizLab. All rights reserved.
//

#ifndef VZMachODefines_h
#define VZMachODefines_h

typedef NS_ENUM(int, VZError) {
    VZErrorNone               = 0,
    VZErrorRead               = 1,           // failed to read target path
    VZErrorIncompatibleBinary = 2,           // couldn't find x86 or x86_64 architecture in binary
    VZErrorStripFailure       = 3,           // failed to strip codesignature
    VZErrorWriteFailure       = 4,           // failed to write data to final output path
    VZErrorNoBackup           = 5,           // no backup to restore
    VZErrorRemovalFailure     = 6,           // failed to remove executable during restore
    VZErrorMoveFailure        = 7,           // failed to move backup to correct location
    VZErrorNoEntries          = 8,           // cant remove dylib entries because they dont exist
    VZErrorInsertFailure      = 9,           // failed to insert load command
    VZErrorInvalidLoadCommand = 10,          // user provided an unnacceptable load command string
    VZErrorResignFailure      = 11,          // codesign failed for some reason
    VZErrorBackupFailure      = 12,          // failed to write backup
    VZErrorInvalidArguments   = 13,          // bad arguments
    VZErrorBadULEB            = 14,          // uleb while reading binding ordinals is in an invalid format
    VZErrorULEBEncodeFailure  = 15           // failed to encode a uleb within specified length requirements
};


#define vz_should_swap(magic) (magic == MH_CIGAM || magic == MH_CIGAM_64 || magic == FAT_CIGAM);


#endif /* VZMachODefines_h */
