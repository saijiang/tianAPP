//
//  HorizontalViewCell.m
//  TvRemote
//
//  Created by Danila Gusev on 29/02/2016.
//  Copyright © 2016 com.abrt. All rights reserved.
//

#import "EHHorizontalLineViewCell.h"
#import "EHHorizontalViewCell.h"

@implementation EHHorizontalLineViewCell

static float _EHHorizontalColorHeight = 4;

static float _EHHorizontalScale = 1.0;

+ (float)cellGap
{
    return _EHDefaultGap * 8;
}

- (UIView *)createSelectedView
{
    self.clipsToBounds = NO;
    //self.coloredView.layer.shadowRadius = 7.5;
    //self.coloredView.layer.shadowOffset = CGSizeMake(0, 0);
    self.coloredView.layer.masksToBounds = NO;
    //self.coloredView.layer.shadowColor = self.coloredView.backgroundColor.CGColor;
    //self.coloredView.layer.shadowOpacity = 1;
    self.selectedView.clipsToBounds = NO;
    
    self.titleLabel.frame = self.bounds;
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView * tLabel = self.titleLabel;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tLabel)]];
    
    [self updateSelectedFrames];
    return self.selectedView;
}



+ (float)colorHeight
{
    return _EHHorizontalColorHeight;
}

+ (void)updateColorHeight:(float)newH
{
    _EHHorizontalColorHeight = newH;
}

+ (float) selectViewScaleForCell{
    
    return _EHHorizontalScale;
}

+ (void) updateScale:(float)scale{

    NSAssert(scale <= 1.0, @"you scale for selectView with cell is bigger then 1.");
    _EHHorizontalScale = scale;
}

- (void)updateSelectedFrames
{
    CGFloat width = self.selectedView.bounds.size.width * [[self class] selectViewScaleForCell];
    self.selectedView.frame = self.bounds;
    self.coloredView.frame = CGRectMake((self.selectedView.bounds.size.width - width) / 2,
                                        self.selectedView.bounds.size.height - [[self class] colorHeight],
                                        width ,
                                        [[self class] colorHeight]);
}

- (void)updateFramesForMovingFromRect:(CGRect)rect
{
    CGFloat width = self.selectedView.bounds.size.width * [[self class] selectViewScaleForCell];
    
    self.selectedView.frame = CGRectMake(CGRectGetMinX(rect) - CGRectGetMinX(self.frame), 0, rect.size.width, self.selectedView.bounds.size.height);
    self.coloredView.frame = CGRectMake((self.selectedView.bounds.size.width - width) / 2,
                                        self.selectedView.bounds.size.height - [[self class] colorHeight],
                                        width,
                                        [[self class] colorHeight]);
}

- (void)setSelectedCell:(BOOL)selected fromCellRect:(CGRect)rect
{
    if (selected)
    {
        self.selectedView.hidden = NO;
        [self updateSelectedFrames];
        if (!CGRectIsNull(rect))
        {
            [self updateFramesForMovingFromRect:rect];

            [UIView animateWithDuration:0.4 animations:^{
                [self updateSelectedFrames];
            
            }];
        }
     
        
        [UIView animateWithDuration:!CGRectIsNull(rect) ? 0.3 : 0.0 animations:^{
            self.titleLabel.font = self.fontMedium ? self.fontMedium : [[self class] fontMedium];
            //self.titleLabel.alpha = 1.0;
            self.titleLabel.highlighted = YES;
        }];
        
    }
    else
    {
        self.selectedView.hidden = YES;
        [UIView animateWithDuration:!CGRectIsNull(rect) ? 0.3 : 0.0 animations:^{
            self.titleLabel.font = self.font ? self.font : [[self class] font];
            //self.titleLabel.alpha = .5;
            self.titleLabel.highlighted = NO;
        } completion:^(BOOL finished) {
        }];
        
    }
}


- (void)setSelectedCell:(BOOL)selected
{
    [self setSelectedCell:selected fromCellRect:CGRectNull];
}
@end
