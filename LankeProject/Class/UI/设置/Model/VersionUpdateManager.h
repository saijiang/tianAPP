//
//  VersionUpdateManager.h
//  LankeProject
//
//  Created by itman on 17/5/5.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUpdateManager : NSObject

+ (VersionUpdateManager *)sharedVersionUpdateManager;

- (void)versionUpdate;

@end
