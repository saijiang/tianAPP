//
//  OMISession.h
//  OpenMobileAPI
//
//  Created by su on 14/9/2.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMIChannel.h"
#import "OMIReader.h"
@protocol OMISession <NSObject>
/**
 * Get an access to the basic channel, as defined in the ISO/IEC 7816-4 specification (the one that has
 * number 0). The obtained object is an instance of the CMChannel class.
 * If the AID is null, which means no Applet is to be selected on this channel and the default Applet is
 * used. If the AID is defined then the corresponding Applet is selected.
 * Once this channel has been opened by a device application, it is considered as "locked" by this device
 * application, and other calls to this method will return null, until the channel is closed. Some Secure
 * Elements (like the UICC) might always keep the basic channel locked (i.e. return null to applications),
 * to prevent access to the basic channel, while some other might return a channel object implementing
 * some kind of filtering on the commands, restricting the set of accepted command to a smaller set.
 * It is recommended for the UICC to reject the opening of the basic channel to a specific Applet, by
 * always answering null to such a request.
 * For other Secure Elements, the recommendation is to accept opening the basic channel on the default
 * Applet until another Applet is selected on the basic channel. As there is no other way than a reset to
 * select again the default Applet, the implementation of the transport API should guarantee that the
 * openBasicChannel(null) command will return null until a reset occurs. If such a restriction is not
 * possible, then openBasicChannel(null) should always return null and therefore prevent access to the
 * default Applet on the basic channel.
 * <p>
 *
 * The select response data can be retrieved with byte[] getSelectResponse().
 *
 * @param aid the AID of the Applet to be selected on this channel, as a byte array, or null if no Applet is to be
 * selected.
 * @throws IOException if there is a communication problem to the reader or the Secure Element (e.g. if the AID is not available).
 * @throws IllegalStateException if the Secure Element session is used after being closed.
 * @throws IllegalArgumentException if the aid's length is not within 5 to
 *             16 (inclusive).
 * @throws SecurityException if the calling application cannot be granted
 *             access to this AID or the default application on this
 *             session.
 *
 * @return an instance of CMChannel if available or null.
 */
- (id<OMIChannel>)openBasicChannel:(NSData*)aid error:(NSError**)err;

/**
 * Open a logical channel with the Secure Element, selecting the Applet
 * represented by the given AID. The AID can be null, which means no
 * Applet is to be selected on this channel, the default Applet is
 * used. It's up to the Secure Element to choose which logical channel will
 * be used.
 *
 * <p>
 *
 * The select response data can be retrieved with byte[] getSelectResponse().
 *
 * @param aid the AID of the Applet to be selected on this channel, as
 *            a byte array.
 * @throws IOException if there is a communication problem to the reader or the Secure Element. (e.g. if the AID is
 *	not available)
 * @throws IllegalStateException if the Secure Element is used after being
 *             closed.
 * @throws IllegalArgumentException if the aid's length is not within 5 to
 *             16 (inclusive).
 * @throws SecurityException if the calling application cannot be granted
 *             access to this AID or the default application on this
 *             session.
 * @throws NoSuchElementException if an Applet with the defined aid does not exist in the SE.
 *
 * @return an instance of CMChannel. Null if the Secure Element is unable to
 *         provide a new logical channel.
 */
- (id<OMIChannel>)openLogicalChannel:(NSData*)aid error:(NSError**)err;

/**
 * Close the connection with the Secure Element. This will close any
 * channels opened by this application with this Secure Element.
 */
- (void)close;

/**
 * Tells if this session is closed.
 *
 * @return <code>true</code> if the session is closed, false otherwise.
 */
- (BOOL)isClosed;

/**
 * Get the Answer to Reset of this Secure Element. <br>
 * The returned byte array can be null if the ATR for this Secure Element
 * is not available.
 *
 * @return the ATR as a byte array or null.
 */
- (NSData*)getATR;

/**
 * Get the reader that provides this session.
 *
 * @return The CMReader object.
 */
- (id<OMIReader>)getReader;

/**
 * Close any channel opened on this session.
 */
- (void)closeChannels;
@end
