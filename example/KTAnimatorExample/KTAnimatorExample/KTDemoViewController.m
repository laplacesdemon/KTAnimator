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
    NSArray *slides;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        blueView.backgroundColor = [UIColor blueColor];
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        redView.backgroundColor = [UIColor redColor];
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        greenView.backgroundColor = [UIColor greenColor];
        UIView *brownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        brownView.backgroundColor = [UIColor brownColor];
        UIView *cyanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        cyanView.backgroundColor = [UIColor cyanColor];
        
        NSArray *pageOneItems = @[[KTItem itemWithView:blueView
                                  startPosition:CGPointMake(100.0f, 700.0f)
                                     startAlpha:0.0f
                            animationProperties:[KTItemAnimationProperties ]
                                   ],
                           [KTItem itemWithView:redView
                                  startPosition:CGPointMake(400.0f, -700.0f)
                                       endPoint:CGPointMake(400.0f, 400.0f)
                                     startAlpha:0.0f
                                        endApha:1.0f
                              animationDuration:1.0f delay:1.0f],
                                  
                                  [KTItem itemWithView:greenView
                                         startPosition:CGPointMake(400.0f, -700.0f)
                                              endPoint:CGPointMake(100.0f, 100.0f)
                                            startAlpha:0.0f
                                               endApha:1.0f
                                     animationDuration:1.0f delay:2.0f],
                                  
                                  [KTItem itemWithView:brownView
                                         startPosition:CGPointMake(400.0f, -700.0f)
                                              endPoint:CGPointMake(600.0f, 600.0f)
                                            startAlpha:0.0f
                                               endApha:1.0f
                                     animationDuration:1.0f delay:3.0f],
                                  
                                  [KTItem itemWithView:cyanView
                                         startPosition:CGPointMake(400.0f, -700.0f)
                                              endPoint:CGPointMake(700.0f, 700.0f)
                                            startAlpha:0.0f
                                               endApha:1.0f
                                     animationDuration:1.0f delay:4.0f]
                           ];
        NSArray *pageTwoItems = @[[KTItem itemWithView:greenView
                                         startPosition:CGPointMake(-300.0f, -300.0f)
                                              endPoint:CGPointMake(300.0f, 300.0f)
                                            startAlpha:0.0f
                                               endApha:1.0f
                                     animationDuration:1.0f]
                                  ];
        slides = @[[KTSlide slideWithItems:pageOneItems backgroundSource:@""],
                   [KTSlide slideWithItems:pageTwoItems backgroundSource:@""]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animatorView.dataSource = self;
    self.animatorView.verticalScrolling = NO;
    [self.animatorView reloadData];
}

#pragma mark - animator view data source

- (NSInteger)totalNumberOfSlides
{
    return [slides count];
}

- (KTSlide *)animator:(KTAnimatorView *)animator
        slideForIndex:(NSInteger)index
{
    return [slides objectAtIndex:index];
}

- (void)animator:(KTAnimatorView *)animator
   didSelectItem:(KTItem *)item
           slide:(KTSlide *)slide
         atIndex:(NSInteger)index
{
    [[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"item at index: %d is selected", index] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
}


@end
