//
//  OMIReader.h
//  OpenMobileAPI
//
//  Created by su on 14/9/2.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMISEService.h"

@protocol OMISession;
@protocol OMIReader <NSObject>
/**
 * Return the user-friendly name of this reader.
 * <ul>
 * <li>If this reader is a SIM reader, then its name must start with the "SIM" prefix.</li>
 * <li>If the reader is a SD or micro SD reader, then its name must start with the "SD" prefix</li>
 * <li>If the reader is a embedded SE reader, then its name must start with the "eSE" prefix</li>
 * <ul>
 *
 * @return name of this Reader
 */
- (NSString*)getName;

/**
 * Connects to a secure element in this reader. <br>
 * This method prepares (initialises) the Secure Element for communication
 * before the CMSession object is returned (e.g. powers the Secure Element by
 * ICC ON if its not already on). There might be multiple sessions opened at
 * the same time on the same reader. The system ensures the interleaving of
 * APDUs between the respective sessions.
 *
 * @throws IOException if something went wrong with the communicating to the
 *             Secure Element or the reader.
 * @return a CMSession object to be used to create Channels.
 */
- (id<OMISession>)openSession:(NSError**)err;

/**
 * Check if a Secure Element is present in this reader.
 *
 * @return <code>true</code> if the SE is present, <code>false</code> otherwise.
 */
- (BOOL)isSecureElementPresent;

/**
 * Return the Secure Element service this reader is bound to.
 *
 * @return the CMSEService object.
 */
- (id<OMISEService>)getSEService;

/**
 * Close all the sessions opened on this reader. All the channels opened by
 * all these sessions will be closed.
 */
- (void)closeSessions;
@end
