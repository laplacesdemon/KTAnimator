//
//  KTDemoViewController.m
//  KTAnimatorExample
//
//  Created by Suleyman Melikoglu on 01/08/14.
//  Copyright (c) 2014 Katu. All rights reserved.
//

#import "KTDemoViewController.h"

@interface KTDemoViewController ()

@end

@implementation KTDemoViewController
{
    KTSlide *slide;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *items = @[[KTItem itemWithImageSource:@""
                                         startPosition:CGPointMake(0.0f, 0.0f)
                                              endPoint:CGPointMake(100.0f, 100.0f)
                                            startAlpha:0.0f
                                               endApha:1.0f
                                     animationDuration:1.0f]
                           ];
        slide = [KTSlide slideWithItems:items backgroundSource:@""];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

#pragma mark - animator view data source

- (NSInteger)totalNumberOfSlides
{
    return 1;
}

- (KTSlide *)animator:(KTAnimatorView *)animator
        slideForIndex:(NSInteger)index
{
    return slide;
}

- (void)animator:(KTAnimatorView *)animator
   didSelectItem:(KTItem *)item
           slide:(KTSlide *)slide
         atIndex:(NSInteger)index
{
    NSLog(@"item at index: %d is selected", index);
}


@end
