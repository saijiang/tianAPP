//
//  OMIChannel.h
//  OpenMobileAPI
//
//  Created by su on 14/9/2.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMISession;
@protocol OMIChannel <NSObject>
/**
 * Closes this channel to the Secure Element. If the method is called when the channel is already closed,
 * this method will be ignored. The close() method shall wait for completion of any pending
 * transmit(byte[] command) before closing the channel.
 */
-(void)close;

/**
 * Tells if this channel is closed.
 *
 * @return <code>true</code> if the channel is closed, <code>false</code> otherwise.
 */
- (BOOL)isClosed;

/**
 * Returns the channel number according to ISO 7816-4.
 *
 * @return the channel number according to ISO 7816-4.
 */
- (int)getChannelNumber;

/**
 * Returns a boolean telling if this channel is the basic channel.
 *
 * @return <code>true</code> if this channel is a basic channel. <code>false</code> if
 *         this channel is a logical channel.
 */
- (BOOL)isBasicChannel;

/**
 * Transmit an APDU command (as per ISO7816-4) to the secure element and
 * wait for the response. The underlying layers might generate as much TPDUs
 * as necessary to transport this APDU. The transport part is invisible from
 * the application. <br>
 * The system ensures the synchronization between all the concurrent calls
 * to this method, and that only one APDU will be sent at a time,
 * irrespective of the number of TPDUs that might be required to transport
 * it to the SE. <br>
 * The channel information in the class byte in the APDU will be completely
 * ignored. The underlying system will add any required information to
 * ensure the APDU is transported on this channel. There are restrictions on
 * the set of commands that can be sent: <br>
 *
 * <ul>
 * <li>MANAGE_CHANNEL commands are not allowed.</li>
 * <li>SELECT by DF Name (p1=04) are not allowed.</li>
 * <li>CLA bytes with channel numbers are de-masked.</li>
 * </ul>
 *
 * @param command the APDU command to be transmitted, as a byte array.
 *
 * @return the response received, as a byte array.
 *
 * @throws IOException if there is a communication problem to the reader or the Secure Element.
 * @throws IllegalStateException if the channel is used after being closed.
 * @throws IllegalArgumentException if the command byte array is less than 4 bytes long.
 * @throws IllegalArgumentException if the length of the APDU is not coherent with the length of the command byte array.
 * @throws SecurityException if the command is filtered by the security
 *             policy
 */
- (NSData*)transmit:(NSData*)command error:(NSError**)err;

/**
 * Get the session that has opened this channel.
 *
 * @return the session object this channel is bound to.
 */
- (id<OMISession>)session;

/**
 * Returns the data as received from the application select command inclusively the status word.
 * The returned byte array contains the data bytes in the following order:
 * [&lt;first data byte&gt;, ..., &lt;last data byte&gt;, &lt;sw1&gt;, &lt;sw2&gt;]
 * @return The data as returned by the application select command inclusively the status word.
 * Only the status word if the application select command has no returned data.
 * Returns null if an application select command has not been performed or the selection response can not
 * be retrieved by the reader implementation.
 */
- (NSData*)getSelectResponse;
- (long long)handle;
@end
