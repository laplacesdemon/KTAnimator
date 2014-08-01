//
//  KTAnimator.h
//  by Katu
//
//  Created by batu@orhanalp.com on 20.06.2014.
//  Copyright (c) 2014 Katu. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kUpperLeftOutside (CGPoint){-100,-100}
#define kUpperRightOutside (CGPoint){1124,-100}
#define kLeftOutside (CGPoint){-100,384}
#define kRightOutside (CGPoint){1124,384}
#define kLeftBottomOutside (CGPoint){-100,868}
#define kRightBottomOutside (CGPoint){1124,868}
#define kTopOutside (CGPoint){512,-100}
#define kBottomOutside (CGPoint){512,868}


@protocol KTAnimatorViewDataSource;
@class KTSlide, KTItem;

@interface KTAnimatorView : UIScrollView

@property (nonatomic, weak) id<KTAnimatorViewDataSource> dataSource;

@property (nonatomic) NSInteger currentPage;

- (void)reloadData;
- (void)showNextPageAnimated:(BOOL)animated;
- (void)showPreviousPageAnimated:(BOOL)animated;
- (void)showLastSlideAnimated:(BOOL)animated;
- (void)showPage:(NSInteger)index
        animated:(BOOL)animated;

@end


///////////////////////////////////////////////////////////////
//                                                           //
///////////////////////////////////////////////////////////////


@protocol KTAnimatorViewDataSource <NSObject>

- (NSInteger)totalNumberOfSlides;
- (KTSlide *)animator:(KTAnimatorView *)animator
        slideForIndex:(NSInteger)index;

@optional
- (void)animator:(KTAnimatorView *)animator
   didSelectItem:(KTItem *)item
           slide:(KTSlide *)slide
         atIndex:(NSInteger)index;

@end


///////////////////////////////////////////////////////////////
//                                                           //
///////////////////////////////////////////////////////////////


@interface KTSlide : NSObject

@property (nonatomic, strong) NSString *background;
@property (nonatomic, strong) NSMutableArray *items;

- (instancetype)initWithItems:(NSArray *)items
             backgroundSource:(NSString *)backgroundSource;

+ (instancetype)slideWithItems:(NSArray *)items
              backgroundSource:(NSString *)backgroundSource;
@end


///////////////////////////////////////////////////////////////
//                                                           //
///////////////////////////////////////////////////////////////


@interface KTItem : NSObject

@property (nonatomic, strong) NSString *src;
@property (nonatomic) CGPoint startPosition;
@property (nonatomic) CGPoint endPosition;
@property (nonatomic) CGFloat startAlpha;
@property (nonatomic) CGFloat endAlpha;

/**
 *  Defaults to 1.0f
 */
@property (nonatomic) CGFloat animationDuration;

- (instancetype)initWithImageSource:(NSString *)source
                      startPosition:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint
                         startAlpha:(CGFloat)startAlpha
                            endApha:(CGFloat)endAlpha
                  animationDuration:(CGFloat) animationDuration;

+ (instancetype)itemWithImageSource:(NSString *)source
                      startPosition:(CGPoint)startPoint
                           endPoint:(CGPoint)endPoint
                         startAlpha:(CGFloat)startAlpha
                            endApha:(CGFloat)endAlpha
                  animationDuration:(CGFloat) animationDuration;

@end