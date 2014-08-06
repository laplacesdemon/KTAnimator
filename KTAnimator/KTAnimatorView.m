//
//  KTAnimator.m
//  by Katu
//
//  Created by batu@orhanalp.com on 20.06.2014.
//  Copyright (c) 2014 Katu. All rights reserved.
//

#import "KTAnimatorView.h"


@interface KTAnimatorView () <UIScrollViewDelegate>

- (void)_initialize;
- (void)removeSubViewsFromSlideView:(UIView *)slideView forPage:(NSInteger)page;

@end

@implementation KTAnimatorView
{
    NSInteger _currentPage;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    //Setting scrollview properties
    self.pagingEnabled = YES;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.verticalScrolling = NO;
 
    // observe the page changes to kick animations off
    [self addObserver:self
           forKeyPath:@"currentPage"
              options:NSKeyValueObservingOptionNew
              context:NULL];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentPage"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // do animations for the current page
    KTSlide *slide = [self.dataSource animator:self slideForIndex:self.currentPage];
    UIView *slideView = [self viewWithTag:10 + self.currentPage];
    
    int i = 100;
    for (__block KTItem *itemModel in slide.items) {
        
        UIImage *im = (itemModel.src == nil) ? [UIImage new] : [UIImage imageNamed:itemModel.src];
        CGRect itemFrame = CGRectMake(itemModel.startPosition.x,
                                      itemModel.startPosition.y,
                                      im.size.width,
                                      im.size.height);
        __block UIButton *iv = [[UIButton alloc] initWithFrame:itemFrame];
        [iv setImage:im forState:UIControlStateNormal];
        [iv addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [iv setAdjustsImageWhenHighlighted:NO];
        iv.alpha = itemModel.startAlpha;
        iv.tag = i; i++;
        
        iv.clipsToBounds = YES;
        __block CGRect originalFr = iv.frame;
        CGRect fr = iv.frame;
        fr.size.height *= itemModel.zoom;
        fr.size.width *= itemModel.zoom;
        fr.origin.x -= (fr.size.width - originalFr.size.width)/2.0f;
        fr.origin.y -= (fr.size.height - originalFr.size.height)/2.0f;
        iv.frame = fr;
        
        [slideView addSubview:iv];
        
        [UIView animateWithDuration:itemModel.animationDuration
                         animations:^{
                             iv.alpha = itemModel.endAlpha;
                             originalFr.origin.x = itemModel.endPosition.x;
                             originalFr.origin.y = itemModel.endPosition.y;
                             iv.frame = originalFr;
                         }];
    }
    
    // delete views of previous page
    if (self.currentPage > 0) {
        [self removeSubViewsFromSlideView:[self viewWithTag:9 + self.currentPage]
                                forPage:self.currentPage - 1];
    }
    
    // delete views of next page
    UIView *nextSlideView = [self viewWithTag:11 + self.currentPage];
    [self removeSubViewsFromSlideView:nextSlideView forPage:self.currentPage + 1];
}

- (void)reloadData
{
    // calculate the content size width
    NSInteger totalContentSize = 0;
    
    NSInteger totalSlides = [self.dataSource totalNumberOfSlides];
    for (int i = 0; i < totalSlides; i++) {
        KTSlide *slide = [self.dataSource animator:self slideForIndex:i];
        
        //Creating view with background image with scrollview size on its' own position
        UIView *view;
        if (self.hasVerticalScrolling) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, totalContentSize, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        } else {
            view = [[UIView alloc] initWithFrame:CGRectMake(totalContentSize, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        }
        
        
        UIImage *im = (slide.background == nil) ? [UIImage new] : [UIImage imageNamed:slide.background];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:im];
        bgView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        [view addSubview:bgView];
        
        view.tag = i + 10;
        [self addSubview:view];
        
        totalContentSize += (self.hasVerticalScrolling) ? CGRectGetHeight(self.frame) : CGRectGetWidth(self.frame);
    }
    
    self.contentSize = (self.hasVerticalScrolling) ?
    CGSizeMake(CGRectGetWidth(self.frame), totalContentSize) :
    CGSizeMake(totalContentSize, CGRectGetHeight(self.frame));
    
    // the initial page will kick the 1st animations
    self.currentPage = 0;
}

- (void)showNextPageAnimated:(BOOL)animated
{
    [self showPage:self.currentPage + 1 animated:animated];
}

- (void)showPreviousPageAnimated:(BOOL)animated
{
    [self showPage:self.currentPage - 1 animated:animated];
}

- (void)showLastSlideAnimated:(BOOL)animated
{
    [self showPage:[self.dataSource totalNumberOfSlides] - 1 animated:animated];
}

- (void)showPage:(NSInteger)index animated:(BOOL)animated
{
    CGRect fr;
    if (self.hasVerticalScrolling) {
        fr = CGRectMake(self.contentOffset.x,
                        CGRectGetHeight(self.frame) * index,
                        CGRectGetWidth(self.frame),
                        CGRectGetHeight(self.frame));
    } else {
        fr = CGRectMake(CGRectGetWidth(self.frame) * index,
                        self.contentOffset.y,
                        CGRectGetWidth(self.frame),
                        CGRectGetHeight(self.frame));
    }
    
    [self scrollRectToVisible:fr animated:animated];
    self.currentPage = index;
}

#pragma mark - private methods

- (void)removeSubViewsFromSlideView:(UIView *)slideView forPage:(NSInteger)page
{
    if (!slideView) return;
    
    KTSlide  *slide = [self.dataSource animator:self slideForIndex:page];
    for (int j = 100; j < [slide.items count] + 100; j++) {
        UIImageView *iv = (UIImageView *)[slideView viewWithTag:j];
        [iv removeFromSuperview];
    }
}

- (void)onButton:(UIButton *)sender
{
    KTSlide *slide = [self.dataSource animator:self slideForIndex:self.currentPage];
    KTItem *item = [slide.items objectAtIndex:sender.tag - 100];
    
    if ([self.dataSource respondsToSelector:@selector(animator:didSelectItem:slide:atIndex:)]) {
        [self.dataSource animator:self didSelectItem:item slide:slide atIndex:self.currentPage];
    }
}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    if (!tmp) {
        tmp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p06bttnCarlsberg"]];
        tmp.frame = CGRectMake(-tmp.image.size.width, -tmp.image.size.height, tmp.image.size.width, tmp.image.size.height);
        UIView *slideView = [self viewWithTag:10 + self.currentPage];
        [slideView addSubview:tmp];
    }
    
    CGFloat endX = 400.0f;
    CGFloat endY = 400.0f;
    CGRect fr = tmp.frame;
    fr.origin.x = (scrollView.contentOffset.x * endX) / 1024.0f;
    fr.origin.y = (scrollView.contentOffset.x * endY) / 1024.0f;
    tmp.frame = fr;
    
    NSLog(@"x: %f, y: %f, offset: %@", fr.origin.x, fr.origin.y, NSStringFromCGPoint(scrollView.contentOffset));
     */
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = YES;
    
    // calculate the current page
    if (self.hasVerticalScrolling) {
        NSInteger page = self.contentOffset.y / self.frame.size.height;
        if (page != self.currentPage) {
            self.currentPage = page;
        }
    } else {
        NSInteger page = self.contentOffset.x / self.frame.size.width;
        if (page != self.currentPage) {
            self.currentPage = page;
        }
    }
    
}


@end


///////////////////////////////////////////////////////////////
//                                                           //
///////////////////////////////////////////////////////////////


@implementation KTSlide

- (instancetype)initWithItems:(NSArray *)items
            backgroundSource:(NSString *)backgroundSource
{
    self = [super init];
    
    if(self){
        self.background = backgroundSource;
        self.items = [NSMutableArray arrayWithArray:items];
    }
    
    return self;
}

+ (instancetype)slideWithItems:(NSArray *)items
              backgroundSource:(NSString *)backgroundSource
{
    return [[KTSlide alloc] initWithItems:items
                         backgroundSource:backgroundSource];
}

@end


///////////////////////////////////////////////////////////////
//                                                           //
///////////////////////////////////////////////////////////////


@implementation KTItem

- (instancetype)initWithImageSource:(NSString *)source
                      startPosition:(CGPoint)startPosition
                           endPoint:(CGPoint)endPosition
                         startAlpha:(CGFloat)startAlpha
                            endApha:(CGFloat)endAlpha
                  animationDuration:(CGFloat) animationDuration
{
    self = [super init];
    
    if(self){
        self.src = source;
        self.startPosition = startPosition;
        self.endPosition = endPosition;
        self.startAlpha = startAlpha;
        self.endAlpha = endAlpha;
        self.animationDuration = animationDuration;
        self.zoom = 1.0f;
    }
    
    return self;
}

+ (instancetype)itemWithImageSource:(NSString *)source
                      startPosition:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint
                         startAlpha:(CGFloat)startAlpha
                            endApha:(CGFloat)endAlpha
                  animationDuration:(CGFloat)animationDuration
{
    return [[KTItem alloc] initWithImageSource:source
                                 startPosition:startPoint
                                      endPoint:endPoint
                                    startAlpha:startAlpha
                                       endApha:endAlpha
                             animationDuration:animationDuration];
}

@end
