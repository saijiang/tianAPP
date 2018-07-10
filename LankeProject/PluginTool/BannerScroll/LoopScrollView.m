//
//  LoopScrollView.m
//  bannerScroll
//
//  Created by Appolls on 15-2-9.
//  Copyright (c) 2015年 test. All rights reserved.
//


#import "LoopScrollView.h"
#import "UIImageView+WebCache.h"
@interface LoopScrollView(private)
- (void) setCurrentImage;
- (void) cacheImageViewSetImage;
@end

@implementation LoopScrollView
@synthesize loop,titleLabel;

-(void)dealloc
{
    [self timerEnd];
}
- (id)initWithFrame:(CGRect)frame withBannerStyle:(AdBannerStyle )bannerStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        
        showIndex1 = 0;
        showIndex2 = 0;
        showIndex3 = 0;
        
        showArray = [[NSMutableArray alloc] init];
        imageArray = [[NSArray alloc] init];
        
        myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [myScrollView setDelegate:self];
        [myScrollView setBackgroundColor:[UIColor clearColor]];
        [myScrollView setShowsHorizontalScrollIndicator:NO];
        [myScrollView setShowsVerticalScrollIndicator:NO];
        [myScrollView setBounces:NO];
        [myScrollView setPagingEnabled:YES];
        [self addSubview:myScrollView];
        
        self.currentScrollView=[[UIScrollView alloc] init];
        self.currentScrollView=myScrollView;
        
        CGFloat width = myScrollView.frame.size.width;
        CGFloat height = myScrollView.frame.size.height;
        
        firstView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        firstView.userInteractionEnabled=YES;
        firstView.clipsToBounds=YES;
        firstView.contentMode=UIViewContentModeScaleAspectFill;
        [myScrollView addSubview:firstView];
        
        UIButton *firstButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [firstButton addTarget:self action:@selector(firstButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:firstButton];
        
        secondView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        secondView.userInteractionEnabled=YES;
        secondView.clipsToBounds=YES;
        secondView.contentMode=UIViewContentModeScaleAspectFill;
        [myScrollView addSubview:secondView];
        
        UIButton *secondButton = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        [secondButton addTarget:self action:@selector(secondButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:secondButton];
        
        thirdView = [[UIImageView alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
        thirdView.userInteractionEnabled=YES;
        thirdView.clipsToBounds=YES;
        thirdView.contentMode=UIViewContentModeScaleAspectFill;
        [myScrollView addSubview:thirdView];
        
        UIButton *thirdButton = [[UIButton alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
        [thirdButton addTarget:self action:@selector(thirdButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:thirdButton];
        
        //shadow
        shadow = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 35, self.frame.size.width, 35)];
        shadow.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:.5];
        [self addSubview:shadow];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height - 35, 220, 35)];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.layer.shadowOffset = CGSizeMake(0, -2);
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        
        self.pc = [[HLLPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 25, frame.size.width - 5, 20)];
        [self.pc setUserInteractionEnabled:NO];
        self.pc.backgroundColor = [UIColor clearColor];
        self.pc.numberOfPages = 0;
        self.pc.pageIndicatorTintColor = [UIColor colorWithHexString:@"#7E7787"];
        self.pc.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:self.pc];
        
        
    }
    return self;
}
- (void) setImageArray : (NSArray*) _imageArray
{
    if (!_imageArray || _imageArray.count == 0)
    {
        return;
    }
    else
    {
        if (showArray) {
            [showArray removeAllObjects];
        }
        imageArray = [[NSArray alloc] initWithArray:_imageArray];
        self.pc.numberOfPages = [imageArray count];
        
        if (self.bannerStyle == AdBannerStyleTitle){
            
            CGSize pointSize = [self.pc sizeForNumberOfPages:self.pc.numberOfPages];
            
            CGFloat page_x = -(self.pc.bounds.size.width - pointSize.width) / 2 ;
            
            [self.pc setBounds:CGRectMake(page_x, self.pc.bounds.origin.y, self.pc.bounds.size.width, self.pc.bounds.size.height)];
            
        }else{
            shadow.alpha = 0;
            self.titleLabel.alpha = 0;
            self.pc.frame = CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 20);
        }
        
        if ([imageArray count] > 2) {
            [myScrollView setContentSize:CGSizeMake(self.frame.size.width * 3, self.frame.size.height)];
            showIndex1 = 0/*[imageArray count] - 1*/;
            showIndex2 = 1;
            showIndex3 = 2;
            [showArray addObject:[imageArray objectAtIndex:showIndex1]];
            [showArray addObject:[imageArray objectAtIndex:showIndex2]];
            [showArray addObject:[imageArray objectAtIndex:showIndex3]];
            
            
            [firstView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [secondView setFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [thirdView setFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
            
            [self cacheImageViewSetImage];
            [self setPageTag:0];
            [myScrollView setScrollEnabled:YES];
            [myScrollView setContentOffset:CGPointMake(/*self.frame.size.width*/0, 0)];
        }
        else if ([imageArray count] == 2)
        {
            if (loop) {
                [myScrollView setContentSize:CGSizeMake(self.frame.size.width * 3, self.frame.size.height)];
            }
            else
            {
                [myScrollView setContentSize:CGSizeMake(self.frame.size.width * 2, self.frame.size.height)];
            }
            
            showIndex1 = 0;
            showIndex2 = 1;
            showIndex3 = 0;
            [showArray addObject:[imageArray objectAtIndex:showIndex1]];
            [showArray addObject:[imageArray objectAtIndex:showIndex2]];
            [showArray addObject:[imageArray objectAtIndex:showIndex3]];
            [self cacheImageViewSetImage];
            [myScrollView setScrollEnabled:YES];
            [myScrollView setContentOffset:CGPointMake(0/*self.frame.size.width*/, 0)];
        }
        else if ([imageArray count] == 1)
        {
            [showArray addObject:[imageArray objectAtIndex:0]];
            [showArray addObject:[imageArray objectAtIndex:0]];
            [showArray addObject:[imageArray objectAtIndex:0]];
            [self cacheImageViewSetImage];
            [myScrollView setScrollEnabled:NO];
            [myScrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        }
    }
}

#pragma mark - buttonAction
- (void) firstButtonAction : (id) sender
{
    //    NSLog(@"firstButtonAction index : %d" , self.pc.currentPage);
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopScrollView:didSelectIndex:didSelectImage:)]) {
        [self.delegate loopScrollView:self didSelectIndex:self.pc.currentPage didSelectImage:firstView.image];
    }
    
}

- (void) secondButtonAction : (id) sender
{
    //    NSLog(@"secondButtonAction index : %d" , self.pc.currentPage);
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopScrollView:didSelectIndex:didSelectImage:)]) {
        [self.delegate loopScrollView:self didSelectIndex:self.pc.currentPage didSelectImage:secondView.image];
    }
}

- (void) thirdButtonAction : (id) sender
{
    //    NSLog(@"thirdButtonAction index : %d" , self.pc.currentPage);
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopScrollView:didSelectIndex:didSelectImage:)]) {
        [self.delegate loopScrollView:self didSelectIndex:self.pc.currentPage didSelectImage:thirdView.image];
    }
}

#pragma mark - private methods
- (void) cacheImageViewSetImage
{
    
    if ([[showArray objectAtIndex:0] isKindOfClass:[UIImage class]])
    {
        [firstView setImage:[showArray objectAtIndex:0] ];
    }
    else if ([[showArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        [firstView sd_setImageWithURL:[NSURL URLWithString:[showArray objectAtIndex:0]]placeholderImage:[UIImage imageNamed:@"default_restaurant"]];
    }
    else if ([[showArray objectAtIndex:0] isKindOfClass:[NSURL class]])
    {
        [firstView sd_setImageWithURL:[showArray objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"default_restaurant"]];
    }
    
    if ([[showArray objectAtIndex:1] isKindOfClass:[UIImage class]]) {
        [secondView setImage:[showArray objectAtIndex:1]];
    }
    else if ([[showArray objectAtIndex:1] isKindOfClass:[NSString class]])
    {
        [secondView sd_setImageWithURL:[NSURL URLWithString:[showArray objectAtIndex:1]]placeholderImage:[UIImage imageNamed:@"default_restaurant"]];
    }
    else if ([[showArray objectAtIndex:1] isKindOfClass:[NSURL class]])
    {
        [secondView sd_setImageWithURL:[showArray objectAtIndex:1]placeholderImage:[UIImage imageNamed:@"default_restaurant"]];
    }
    
    if ([[showArray objectAtIndex:2] isKindOfClass:[UIImage class]]) {
        [thirdView setImage:[showArray objectAtIndex:2]];
    }
    else if ([[showArray objectAtIndex:2] isKindOfClass:[NSString class]])
    {
        [thirdView sd_setImageWithURL:[NSURL URLWithString:[showArray objectAtIndex:2]]placeholderImage:[UIImage imageNamed:@"default_restaurant"]];
    }
    else if ([[showArray objectAtIndex:2] isKindOfClass:[NSURL class]])
    {
        [thirdView sd_setImageWithURL:[showArray objectAtIndex:2]placeholderImage:[UIImage imageNamed:@"default_restaurant"]];
    }
}

-(void)setPageTag:(NSInteger)index{
    
    [self.pc setupPageControlCurrentPage:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopScrollView:didSelectIndex:didSelectImage:)]) {
        [self.delegate loopScrollViewTitle:self didSelectIndex:self.pc.currentPage];
    }
}

- (void) setCurrentImage
{
    if (myScrollView.contentOffset.x == 0.0f) {
        
        showIndex1--;
        if (loop) {
            if (showIndex1 < 0) {
                showIndex1 = [imageArray count] - 1;
            }
        }
        else
        {
            if (showIndex1 < 0) {
                showIndex1 = 0;
            }
            
        }
        
        showIndex2--;
        if (loop) {
            if (showIndex2 < 0) {
                showIndex2 = [imageArray count] - 1;
            }
        }
        else
        {
            if (showIndex2 < 1) {
                showIndex2 = 1;
            }
        }
        
        showIndex3--;
        if (loop) {
            if (showIndex3 < 0) {
                showIndex3 = [imageArray count] - 1;
            }
        }
        else
        {
            if (showIndex3 < 2) {
                showIndex3 = 2;
            }
        }
        
        [showArray replaceObjectAtIndex:0 withObject:[imageArray objectAtIndex:showIndex1]];
        [showArray replaceObjectAtIndex:1 withObject:[imageArray objectAtIndex:showIndex2]];
        [showArray replaceObjectAtIndex:2 withObject:[imageArray objectAtIndex:showIndex3]];
        
        [self cacheImageViewSetImage];
        
        [self setPageTag:showIndex2];
        [myScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }
    else if (myScrollView.contentOffset.x == self.frame.size.width)
    {
        [self setPageTag:showIndex2];
    }
    else if (myScrollView.contentOffset.x == self.frame.size.width * 2)
    {
        showIndex1++;
        if (loop) {
            if (showIndex1 >= [imageArray count]) {
                showIndex1 = 0;
            }
        }
        else
        {
            if (showIndex1 > [imageArray count] - 3) {
                showIndex1 = [imageArray count] - 3;
            }
        }
        
        
        showIndex2++;
        if (loop) {
            if (showIndex2 >= [imageArray count]) {
                showIndex2 = 0;
            }
        }
        else
        {
            if (showIndex2 > [imageArray count] - 2) {
                showIndex2 = [imageArray count] - 2;
            }
        }
        
        showIndex3++;
        if (loop) {
            if (showIndex3 >= [imageArray count]) {
                showIndex3 = 0;
            }
        }
        else
        {
            if (showIndex3 == [imageArray count] - 1) {
                showIndex3 = [imageArray count] - 1;
            }
        }
        
        [showArray replaceObjectAtIndex:0 withObject:[imageArray objectAtIndex:showIndex1]];
        [showArray replaceObjectAtIndex:1 withObject:[imageArray objectAtIndex:showIndex2]];
        [showArray replaceObjectAtIndex:2 withObject:[imageArray objectAtIndex:showIndex3]];
        
        [self cacheImageViewSetImage];
        [self setPageTag:showIndex2];
        [myScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }
}

#pragma mark - timer action
- (void) timerStart : (float) duration
{
    [self setLoop:YES];
    [self timerEnd];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

- (void) timerEnd
{
    if (myTimer) {
        [myTimer invalidate];
        myTimer = nil;
    }
}
- (void) scrollAnimationStop
{
    [self setCurrentImage];
    [myScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    [myScrollView setUserInteractionEnabled:YES];
}
- (void) timerAction : (NSTimer*) sender
{
    [myScrollView setUserInteractionEnabled:NO];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(scrollAnimationStop)];
    
    [myScrollView setContentOffset:CGPointMake(myScrollView.contentOffset.x + self.frame.size.width, 0)];
    
    [UIView commitAnimations];
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x == 0) {
        return;
    }
    
    if (imageArray.count != 2 && scrollView.contentOffset.x == scrollView.bounds.size.width * 2) {
        return;
    }
    
    if (imageArray.count == 2 && scrollView.contentOffset.x == scrollView.bounds.size.width) {
        return;
    }
    
    [myScrollView setUserInteractionEnabled:NO];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!loop) {
        if (imageArray.count > 2) {
            if (showIndex2 == imageArray.count - 2) {
                if (scrollView.contentOffset.x > self.frame.size.width) {
                    [self setPageTag:showIndex3];
                }
                else if (scrollView.contentOffset.x < self.frame.size.width) {
                    if (imageArray.count == 3) {
                        [self setPageTag:showIndex1];
                    }
                    else
                    {
                        [self setCurrentImage];
                    }
                    
                }
                else
                {
                    [self setCurrentImage];
                }
            }
            else
            {
                if (showIndex2 == 1) {
                    if (scrollView.contentOffset.x < self.frame.size.width) {
                        [self setPageTag:showIndex1];
                    }
                    else
                    {
                        [self setCurrentImage];
                    }
                    
                }
                else
                {
                    [self setCurrentImage];
                }
                
            }
        }
        else
        {
            if (scrollView.contentOffset.x == 0) {
                [self setPageTag:showIndex1];
            }
            else
            {
                [self setPageTag:showIndex2];
            }
        }
    }
    else
    {
        [self setCurrentImage];
    }
    
    [myScrollView setUserInteractionEnabled:YES];
}

#pragma mark - scrollView setting
-(void)setLoop:(BOOL)_loop
{
    loop = _loop;
    if (imageArray.count == 2) {
        if (loop) {
            [myScrollView setContentSize:CGSizeMake(myScrollView.bounds.size.width * 3, myScrollView.bounds.size.height)];
        }
        else
        {
            [myScrollView setContentSize:CGSizeMake(myScrollView.bounds.size.width * 2, myScrollView.bounds.size.height)];
        }
    }
    else
    {
        [myScrollView setContentSize:CGSizeMake(myScrollView.bounds.size.width * 3, myScrollView.bounds.size.height)];
    }
}

- (void) setContentOffset : (CGPoint) point
{
    if (myScrollView) {
        [myScrollView setContentOffset:point];
    }
}

- (void) setContentOffset : (CGPoint) point animated : (BOOL) animated
{
    if (myScrollView) {
        [myScrollView setContentOffset:point animated:animated];
    }
}

- (void) setBounces : (BOOL) bounces
{
    if (myScrollView) {
        [myScrollView setBounces:bounces];
    }
}

- (void) setBackgroundColor : (UIColor*) color
{
    if (myScrollView) {
        [myScrollView setBackgroundColor:color];
    }
}

- (void) setPagingEnabled : (BOOL) enabled
{
    if (myScrollView) {
        [myScrollView setPagingEnabled:enabled];
    }
}

- (void) setHidden : (BOOL) hidden
{
    if (myScrollView) {
        [myScrollView setHidden:hidden];
    }
}

- (void) setScrollEnabled : (BOOL) enabled
{
    if (myScrollView) {
        [myScrollView setScrollEnabled:enabled];
    }
}

- (void) setScrollsToTop : (BOOL) top
{
    if (myScrollView) {
        [myScrollView setScrollsToTop:top];
    }
}

- (void) setShowsHorizontalScrollIndicator : (BOOL) show
{
    if (myScrollView) {
        [myScrollView setShowsHorizontalScrollIndicator:show];
    }
}

- (void) setShowsVerticalScrollIndicator : (BOOL) show
{
    if (myScrollView) {
        [myScrollView setShowsVerticalScrollIndicator:show];
    }
}

- (void) setUserInteractionEnabled : (BOOL) enabled
{
    if (myScrollView) {
        [myScrollView setUserInteractionEnabled:enabled];
    }
}

#pragma mark - pageControl setting
- (void) setPageControlHidden : (BOOL) hidden
{
    if (self.pc) {
        [self.pc setHidden:hidden];
    }
}

- (void) setPageControlOffset : (CGPoint) offset
{
    if (self.pc) {
        CGRect rect = self.pc.frame;
        [self.pc setFrame:CGRectMake(offset.x, rect.origin.y + offset.y, rect.size.width, rect.size.height)];
    }
}

- (void) setPageControlCurrentPage : (NSInteger) index
{
    if (self.pc) {
        [self.pc setupPageControlCurrentPage:index];
    }
}

- (void) setPageControlNumberOfPages : (NSInteger) pages
{
    if (self.pc) {
        [self.pc setNumberOfPages:pages];
    }
}

- (void) setPageControlCurrentImage : (UIImage*) currentImage
{
    if (self.pc) {
//        [self.pc setImagePageStateHighlighted:currentImage];
    }
}

- (void) setPageControlDefaultImage : (UIImage*) defaultImage
{
    if (self.pc) {
//        [self.pc setImagePageStateNormal:defaultImage];
        
    }
}

- (void) setPageControlCurrentColor : (UIColor*) currentColor{
    if (self.pc) {
        [self.pc setCurrentPageIndicatorTintColor:currentColor];
    }
}
- (void) setPageControlDefaultColor : (UIColor*) defaultColor{
    if (self.pc) {
        [self.pc setPageIndicatorTintColor:defaultColor];
    }
}

@end

