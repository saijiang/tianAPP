//
//  OMSEServiceFactory.h
//  OpenMobileAPI
//
//  Created by su on 14/9/2.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMISEService.h"
#import <MESDK/NLICCardModule.h>
@interface OMSEServiceFactory : NSObject
+ (id<OMISEService>)createInstanceWithListener:(id<OMICallBack>)listener  icCardModule:(id<NLICCardModule>)icCardModule;
@end
