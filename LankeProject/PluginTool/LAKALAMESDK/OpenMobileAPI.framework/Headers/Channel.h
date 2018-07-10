//
//  Channel.h
//  OpenMobileAPI
//
//  Created by shen on 16/6/15.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TSMKit/TSMInterface.h>
#import "OMIChannel.h"

@class BTChannel;
@interface Channel : NSObject<UPTChannelDelegate>
/**
 *channel初始化方法
 */
- (id)initWithSession:(id<OMIChannel>)ichannel channelId:(NSString*)channelID resp:(NSString*)slectResp;
@end
