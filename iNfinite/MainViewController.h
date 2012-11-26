//
//  ViewController.h
//  iNfinite
//
//  Created by Baker, Phillip on 11/25/12.
//  Copyright (c) 2012 phillbaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniteView.h"

@interface MainViewController : UIViewController <InfiniteViewDataSource, InfiniteViewDelegate>
@property (weak, nonatomic) IBOutlet InfiniteView *scrollView;

@end
