//
//  OMITerminal.h
//  OpenMobileAPI
//
//  Created by su on 14/9/16.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMIChannel.h"
/**
 * Smartcard service interface for terminal resources.
 */
@protocol OMITerminal <NSObject>
/**
 * Closes all open channels of this terminal.
 */
- (void)closeChannels;

/**
 * Returns the channel for the specified handle or <code>null</code> if this
 * handle is not registered.
 *
 * @param hChannel the channel handle.
 * @return the channel for the specified handle or <code>null</code> if this
 *         handle is not registered.
 */
- (id<OMIChannel>)getChannel:(long long)hChannel;

/**
 * Returns the reader name.
 *
 * @return the reader name.
 */
- (NSString*)getName;

/**
 * Sends a select command on the basic channel. With this command the
 * default application will be selected on the card. (e.g. CardManager)
 *
 * @throw NoSuchElementException if the default applet couldn't be found or
 *        selected
 */
- (void)select:(NSError**)err;

/**
 * Sends a select command on the basic channel.
 *
 * @param aid the aid which should be selected
 * @throw NoSuchElementException if the corresponding applet couldn't be
 *        found
 */
- (void)select:(NSData*)aid error:(NSError**)err;

/**
 * Opens the basic channel to the card.
 *
 * @param callback the callback used to react on the death of the client.
 * @return a handle for the basic channel.
 * @throws CardException if opening the basic channel failed or the basic
 *             channel is in use.
 */
- (long long)openBasicChannel:(NSError**)err;

/**
 * Opens the basic channel to the card.
 *
 * @param aid the AID of the applet to be selected.
 * @param callback the callback used to react on the death of the client.
 * @return a handle for the basic channel.
 * @throws CardException if opening the basic channel failed or the basic
 *             channel is in use.
 */
- (long long)openBasicChannel:(NSData*)aid error:(NSError**)err;

/**
 * Opens a logical channel to the card.
 *
 * @param callback the callback used to react on the death of the client.
 * @return a handle for the logical channel.
 * @throws CardException if opening the logical channel failed.
 */
- (long long)openLogicalChannel:(NSError**)err;

/**
 * Opens a logical channel to the card.
 *
 * @param aid the AID of the applet to be selected.
 * @param callback the callback used to react on the death of the client.
 * @return a handle for the logical channel.
 * @throws CardException if opening the logical channel failed.
 */
- (long long)openLogicalChannel:(NSData*)aid error:(NSError**)err;

/**
 * Returns <code>true</code> if a card is present; <code>false</code>
 * otherwise.
 *
 * @return <code>true</code> if a card is present; <code>false</code>
 *         otherwise.
 * @throws CardException if card presence information is not available.
 */
- (BOOL)isCardPresent:(NSError**)err;

/**
 * Returns <code>true</code> if terminal is connected <code>false</code>
 * otherwise.
 *
 * @return <code>true</code> if at least one terminal is connected.
 */
- (BOOL)isConnected;

/**
 * Returns the ATR of the connected card or null if the ATR is not
 * available.
 *
 * @return the ATR of the connected card or null if the ATR is not
 *         available.
 */
- (NSData*)getAtr;

/**
 * Returns the data as received from the application select command inclusively the status word.
 * The returned byte array contains the data bytes in the following order:
 * [<first data byte>, ..., <last data byte>, <sw1>, <sw2>]
 * @return The data as returned by the application select command inclusively the status word.
 * @return Only the status word if the application select command has no returned data.
 * @return null if an application select command has not been performed or the selection response can not
 * be retrieved by the reader implementation.
 */
- (NSData*)getSelectResponse;
@end
