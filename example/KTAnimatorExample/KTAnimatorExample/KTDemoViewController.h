//
//  KTDemoViewController.h
//  KTAnimatorExample
//
//  Created by Suleyman Melikoglu on 01/08/14.
//  Copyright (c) 2014 Katu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTAnimatorView.h"

@interface KTDemoViewController : UIViewController <KTAnimatorViewDataSource>

@property (nonatomic, weak) IBOutlet KTAnimatorView *animatorView;

@end
