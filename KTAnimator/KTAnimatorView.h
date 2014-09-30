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


@protocol KTAnimatorViewDataSource;/Users/macair/Documents/Git/KTAnimator/KTAnimator/KTAnimatorView.m
@class KTSlide, KTItem;

@interface KTAnimatorView : UIScrollView

@property (nonatomic, weak) id<KTAnimatorViewDataSource> dataSource;

@property (nonatomic) NSInteger currentPage;

@property (nonatomic, getter = hasVerticalScrolling) BOOL verticalScrolling;

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


/**
 *  Slide object represents a page that has number of items that 
 *  are animatable and optionally a background
 */
@interface KTSlide : NSObject

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *items;

- (instancetype)initWithItems:(NSArray *)items
               backgroundView:(UIView *)backgroundView;

+ (instancetype)slideWithItems:(NSArray *)items
                backgroundView:(UIView *)backgroundView;

+ (instancetype)slideWithItems:(NSArray *)items
              backgroundSource:(NSString *)backgroundSource;

@end


///////////////////////////////////////////////////////////////
//                                                           //
///////////////////////////////////////////////////////////////


/**
 *  An item is a wrapper of the animatable view object with 
 *  propertiesthat will be used in animation
 */
@class KTItemAnimationProperties;

@interface KTItem : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic) CGPoint startPosition;
@property (nonatomic) CGFloat startAlpha;
@property (nonatomic) KTItemAnimationProperties *animationProperties;
@property (nonatomic) CGFloat zoomIn; // defaults to 1.0f
@property (nonatomic) CGFloat zoomOut; // defaults to 1.0f

/**
 *  An optional object to store information in item
 */
@property (nonatomic, strong) id itemInfo;

/**
 * Defaults to object width and height
 */
@property (nonatomic) CGFloat endWidth;
@property (nonatomic) CGFloat endHeight;


- (instancetype)initWithView:(UIView *)view
               startPosition:(CGPoint)startPoint
                  startAlpha:(CGFloat)startAlpha
         animationProperties:(KTItemAnimationProperties *)animationProperties;

+ (instancetype)itemWithView:(UIView *)view
               startPosition:(CGPoint)startPoint
                  startAlpha:(CGFloat)startAlpha
         animationProperties:(KTItemAnimationProperties *)animationProperties;

/**
 *  Creates an KTItem and adds an image view from the given imageSource
 */
+ (instancetype)itemWithImageSource:(NSString *)imageSource
                      startPosition:(CGPoint)startPoint
                         startAlpha:(CGFloat)startAlpha
                animationProperties:(KTItemAnimationProperties *)animationProperties;

+ (instancetype)itemWithView:(UIView *)view
               startPosition:(CGPoint)startPoint
                  startAlpha:(CGFloat)startAlpha
         animationProperties:(KTItemAnimationProperties *)animationProperties
                  startWidth:(CGFloat)startWidth
                    endWidth:(CGFloat)endWidth
                 startHeight:(CGFloat)startHeight
                   endHeight:(CGFloat)endHeight;

@end

///////////////////////////////////////////////////////////////
//                                                           //
///////////////////////////////////////////////////////////////


/**
 *  Item animation properties that using for chain animation
 */
@class KTCGPoint;
@interface KTItemAnimationProperties : NSObject

@property (nonatomic) NSArray *endPositions;
@property (nonatomic) NSArray *animationDurations;
@property (nonatomic) NSArray *alphas;
@property (nonatomic) NSArray *delays;

@end


@interface KTCGPoint : NSObject
@property (nonatomic) CGPoint endPoint;
@end


