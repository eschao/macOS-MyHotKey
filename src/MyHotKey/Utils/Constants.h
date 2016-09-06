//
//  Constants.h
//
//  Created by chao on 7/9/16.
//  Copyright © 2016 eschao. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const appNameKey;
FOUNDATION_EXPORT NSString * const appPIDKey;
FOUNDATION_EXPORT NSString * const windowOriginKey;
FOUNDATION_EXPORT NSString * const windowSizeKey;
FOUNDATION_EXPORT NSString * const windowIDKey;
FOUNDATION_EXPORT NSString * const windowLevelKey;
FOUNDATION_EXPORT NSString * const windowOrderKey;

typedef NS_ENUM(NSUInteger, HotKeyIDs) {
    // 2 Grids
    V2_GRIDS_LEFT = 1,
    V2_GRIDS_RIGHT,
    H2_GRIDS_TOP,
    H2_GRIDS_BOTTOM,

    // 3 Grids
    V3_GRIDS_LEFT,
    V3_GRIDS_MIDDLE,
    V3_GRIDS_RIGHT,
    V3_GRIDS_LEFT_MIDDLE,
    V3_GRIDS_MIDDLE_RIGHT,
    H3_GRIDS_TOP,
    H3_GRIDS_CENTER,
    H3_GRIDS_BOTTOM,
    H3_GRIDS_TOP_CENTER,
    H3_GRIDS_CENTER_BOTTOM,

    // 4 Grids
    H4_GRIDS_1,
    H4_GRIDS_2,
    H4_GRIDS_3,
    H4_GRIDS_4,
    H4_GRIDS_123,
    H4_GRIDS_23,
    H4_GRIDS_234,
    V4_GRIDS_1,
    V4_GRIDS_2,
    V4_GRIDS_3,
    V4_GRIDS_4,
    V4_GRIDS_123,
    V4_GRIDS_23,
    V4_GRIDS_234,
    E4_GRIDS_1,
    E4_GRIDS_2,
    E4_GRIDS_3,
    E4_GRIDS_4,

    // Other keys;
    FREE_HOTKEY_ID = 10000,
};

// 2 Grids name/description
FOUNDATION_EXPORT NSString * const h2GridsTopName;
FOUNDATION_EXPORT NSString * const h2GridsBottomName;
FOUNDATION_EXPORT NSString * const v2GridsLeftName;
FOUNDATION_EXPORT NSString * const v2GridsRightName;
FOUNDATION_EXPORT NSString * const h2GridsTopDesc;
FOUNDATION_EXPORT NSString * const h2GridsBottomDesc;
FOUNDATION_EXPORT NSString * const v2GridsLeftDesc;
FOUNDATION_EXPORT NSString * const v2GridsRightDesc;

// 3 Grids name/description
FOUNDATION_EXPORT NSString * const h3GridsTopName;
FOUNDATION_EXPORT NSString * const h3GridsCenterName;
FOUNDATION_EXPORT NSString * const h3GridsBottomName;
FOUNDATION_EXPORT NSString * const h3GridsTopCenterName;
FOUNDATION_EXPORT NSString * const h3GridsCenterBottomName;
FOUNDATION_EXPORT NSString * const v3GridsLeftName;
FOUNDATION_EXPORT NSString * const v3GridsMiddleName;
FOUNDATION_EXPORT NSString * const v3GridsRightName;
FOUNDATION_EXPORT NSString * const v3GridsLeftMiddleName;
FOUNDATION_EXPORT NSString * const v3GridsMiddleRightName;
FOUNDATION_EXPORT NSString * const h3GridsTopDesc;
FOUNDATION_EXPORT NSString * const h3GridsCenterDesc;
FOUNDATION_EXPORT NSString * const h3GridsBottomDesc;
FOUNDATION_EXPORT NSString * const h3GridsTopCenterDesc;
FOUNDATION_EXPORT NSString * const h3GridsCenterBottomDesc;
FOUNDATION_EXPORT NSString * const v3GridsLeftDesc;
FOUNDATION_EXPORT NSString * const v3GridsMiddleDesc;
FOUNDATION_EXPORT NSString * const v3GridsRightDesc;
FOUNDATION_EXPORT NSString * const v3GridsLeftMiddleDesc;
FOUNDATION_EXPORT NSString * const v3GridsMiddleRightDesc;

// 4 Grids name/description
FOUNDATION_EXPORT NSString * const h4Grids_1_Name;
FOUNDATION_EXPORT NSString * const h4Grids_2_Name;
FOUNDATION_EXPORT NSString * const h4Grids_3_Name;
FOUNDATION_EXPORT NSString * const h4Grids_4_Name;
FOUNDATION_EXPORT NSString * const h4Grids_123_Name;
FOUNDATION_EXPORT NSString * const h4Grids_23_Name;
FOUNDATION_EXPORT NSString * const h4Grids_234_Name;
FOUNDATION_EXPORT NSString * const v4Grids_1_Name;
FOUNDATION_EXPORT NSString * const v4Grids_2_Name;
FOUNDATION_EXPORT NSString * const v4Grids_3_Name;
FOUNDATION_EXPORT NSString * const v4Grids_4_Name;
FOUNDATION_EXPORT NSString * const v4Grids_123_Name;
FOUNDATION_EXPORT NSString * const v4Grids_23_Name;
FOUNDATION_EXPORT NSString * const v4Grids_234_Name;
FOUNDATION_EXPORT NSString * const e4Grids_1_Name;
FOUNDATION_EXPORT NSString * const e4Grids_2_Name;
FOUNDATION_EXPORT NSString * const e4Grids_3_Name;
FOUNDATION_EXPORT NSString * const e4Grids_4_Name;
FOUNDATION_EXPORT NSString * const e4Grids_1_Desc;
FOUNDATION_EXPORT NSString * const e4Grids_2_Desc;
FOUNDATION_EXPORT NSString * const e4Grids_3_Desc;
FOUNDATION_EXPORT NSString * const e4Grids_4_Desc;

// 2 Grids hot keys
FOUNDATION_EXPORT NSString * const h2GridsTopHKey;
FOUNDATION_EXPORT NSString * const h2GridsBottomHKey;
FOUNDATION_EXPORT NSString * const v2GridsLeftHKey;
FOUNDATION_EXPORT NSString * const v2GridsRightHKey;

// 3 Grids hot keys
FOUNDATION_EXPORT NSString * const h3GridsTopHKey;
FOUNDATION_EXPORT NSString * const h3GridsCenterHKey;
FOUNDATION_EXPORT NSString * const h3GridsBottomHKey;
FOUNDATION_EXPORT NSString * const h3GridsTopCenterHKey;
FOUNDATION_EXPORT NSString * const h3GridsCenterBottomHKey;
FOUNDATION_EXPORT NSString * const v3GridsLeftHKey;
FOUNDATION_EXPORT NSString * const v3GridsMiddleHKey;
FOUNDATION_EXPORT NSString * const v3GridsRightHKey;
FOUNDATION_EXPORT NSString * const v3GridsLeftMiddleHKey;
FOUNDATION_EXPORT NSString * const v3GridsMiddleRightHKey;

// 4 Grids hot keys
FOUNDATION_EXPORT NSString * const h4Grids_1_HKey;
FOUNDATION_EXPORT NSString * const h4Grids_2_HKey;
FOUNDATION_EXPORT NSString * const h4Grids_3_HKey;
FOUNDATION_EXPORT NSString * const h4Grids_4_HKey;
FOUNDATION_EXPORT NSString * const h4Grids_123_HKey;
FOUNDATION_EXPORT NSString * const h4Grids_23_HKey;
FOUNDATION_EXPORT NSString * const h4Grids_234_HKey;
FOUNDATION_EXPORT NSString * const v4Grids_1_HKey;
FOUNDATION_EXPORT NSString * const v4Grids_2_HKey;
FOUNDATION_EXPORT NSString * const v4Grids_3_HKey;
FOUNDATION_EXPORT NSString * const v4Grids_4_HKey;
FOUNDATION_EXPORT NSString * const v4Grids_123_HKey;
FOUNDATION_EXPORT NSString * const v4Grids_23_HKey;
FOUNDATION_EXPORT NSString * const v4Grids_234_HKey;
FOUNDATION_EXPORT NSString * const e4Grids_1_HKey;
FOUNDATION_EXPORT NSString * const e4Grids_2_HKey;
FOUNDATION_EXPORT NSString * const e4Grids_3_HKey;
FOUNDATION_EXPORT NSString * const e4Grids_4_HKey;

// window normal behavior
FOUNDATION_EXPORT NSString * const maximizeWinName;
FOUNDATION_EXPORT NSString * const maximizeWinDesc;
FOUNDATION_EXPORT NSString * const maximizeWinHKey;
FOUNDATION_EXPORT NSString * const minimizeWinName;
FOUNDATION_EXPORT NSString * const minimizeWinDesc;
FOUNDATION_EXPORT NSString * const minimizeWinHKey;
FOUNDATION_EXPORT NSString * const fullscreenWinName;
FOUNDATION_EXPORT NSString * const fullscreenWinDesc;
FOUNDATION_EXPORT NSString * const fullscreenWinHKey;
FOUNDATION_EXPORT NSString * const centerWinName;
FOUNDATION_EXPORT NSString * const centerWinDesc;
FOUNDATION_EXPORT NSString * const centerWinHKey;

// keys in JSON and Preferences
FOUNDATION_EXPORT NSString * const CloudPreferenceFile;
FOUNDATION_EXPORT NSString * const UpdateDateKey;
FOUNDATION_EXPORT NSString * const MyWindowHotKeysKey;
FOUNDATION_EXPORT NSString * const MyAppHotKeysKey;
FOUNDATION_EXPORT NSString * const EnabledKey;
FOUNDATION_EXPORT NSString * const HotKeyKey;
FOUNDATION_EXPORT NSString * const IDKey;
FOUNDATION_EXPORT NSString * const NameKey;
FOUNDATION_EXPORT NSString * const CloudSyncKey;
FOUNDATION_EXPORT NSString * const AutoSyncKey;
FOUNDATION_EXPORT NSString * const SyncAccountTypeKey;
FOUNDATION_EXPORT NSString * const LastSyncDateKey;

