//
//  OCConstants.h
//  OverClouded
//
//  Created by Parag Dulam on 18/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#ifndef OverClouded_OCConstants_h
#define OverClouded_OCConstants_h


typedef enum OCCLOUD_TYPE {
    DROPBOX = 0,
}OCCLOUD_TYPE;


typedef enum OCMESSAGE_TYPE {
    NOTIFICATION,
    SUCCESS,
    ERROR,
}OCMESSAGE_TYPE;


#define OC_ACCOUNTS @"accounts"
#define OC_ACCOUNTS_DB @"accounts.db"

#define OC_FILES @"files"
#define OC_FILES_DB @"files.db"

#define OC_FILES_METADATA_LOAD_START_NOTIFICATION @"com.metadata.load.start"
#define OC_FILES_METADATA_LOAD_END_NOTIFICATION @"com.metadata.load.end"


#endif
