//
//  OMISEService.h
//  OpenMobileAPI
//
//  Created by su on 14/9/2.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMIReader;
@protocol OMISEService <NSObject>
/**
 * Tells whether or not the service is connected.
 *
 * @return <code>true</code> if the service is connected.
 */
- (BOOL)isConnected;

/**
 * Returns the list of available Secure Element readers. More precisely it
 * returns the list of readers that the calling application has the
 * permission to connect to.
 *
 * @return The readers list, as an array of Readers. If there are no readers the returned array is of length 0.
 */
- (NSArray*)getReaders;

/**
 * Releases all Secure Elements resources allocated by this CMSEService. It is
 * recommended to call this method in the termination method of the calling
 * application (or part of this application) which is bound to this
 * CMSEService.
 */
- (void)shutdown;
@end


/**
 * Interface to receive call-backs when the service is connected. If the
 * target language and environment allows it, then this shall be an inner
 * interface of the SEService class.
 */
@protocol OMICallBack <NSObject>
/**
 * Called by the framework when the service is connected.
 *
 * @param service the connected service.
 */
- (void)serviceConnected:(id<OMISEService>)service;
@end
