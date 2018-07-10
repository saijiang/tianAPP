/*
 * This file is part of the CSStickyHeaderFlowLayout package.
 * (c) James Tang <j@jamztang.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

//! Project version number for CSStickyHeaderFlowLayout.
FOUNDATION_EXPORT double CSStickyHeaderFlowLayoutVersionNumber;

//! Project version string for CSStickyHeaderFlowLayout.
FOUNDATION_EXPORT const unsigned char CSStickyHeaderFlowLayoutVersionString[];

// Import All public headers
#import "CSStickyHeaderFlowLayoutAttributes.h"

#pragma mark -

extern NSString *const CSStickyHeaderParallaxHeader;

@interface CSStickyHeaderFlowLayout : UICollectionViewFlowLayout

/**
 *  设置整个UICollectionView的headerView尺寸
 */
@property (nonatomic) CGSize parallaxHeaderReferenceSize;
/**
 *  将这个属性设置成和`parallaxHeaderReferenceSize`一样就可以不使headerView跟随拖拽变化
 */
@property (nonatomic) CGSize parallaxHeaderMinimumReferenceSize;

@property (nonatomic) BOOL parallaxHeaderAlwaysOnTop;
/**
 *  设置header是否可以粘在最顶部，默认是NO，效果是UITableView的plain效果；YES的时候是UITableView的group效果。sticky: 粘性。
 */
@property (nonatomic) BOOL disableStickyHeaders;

@end


