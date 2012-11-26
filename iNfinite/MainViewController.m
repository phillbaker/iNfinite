//
//  ViewController.m
//  iNfinite
//
//  Created by Baker, Phillip on 11/25/12.
//  Copyright (c) 2012 phillbaker. All rights reserved.
//

#import "MainViewController.h"
#include <stdlib.h>

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize scrollView;

#pragma mark -
#pragma mark View lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // a scroll view which can contain an infinite amount of items
    // Because these items can be any kind of class, the only assumption you can make is they are a custom View Controller. The items need to load asynchronously. Custom View Controllers loading images is fine for this class
    
    // General strategy:
    //  * assume each view takes a standard height, calculate which view controller we're going to show based on the position we're currently at in the scroll view
    //  * async query  a datasource similar to a UITableView which provides basic info: index and viewcontroller (and hence the view to find the actual height/etc.)
    //  * tell the view controller to load itself
    
    //async:
//    dispatch_queue_t queue = dispatch_queue_create("com.yourdomain.yourappname", NULL);
//    dispatch_async(queue, ^{
//        //code to executed in the background
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //code to be executed on the main thread when background task is finished
//        });
//    });
    
    scrollView.dataSource = self;
    scrollView.infiniteDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [scrollView reloadData];
    
    CGRect frame = [scrollView bounds];//
    NSLog(@"viewdidappear: %@", NSStringFromCGRect(frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Protocol implementations
#pragma mark -

- (BOOL)infiniteViewHasViews:(InfiniteView *)view {
    // hardcoded yes
    return YES;
}

- (BOOL)infiniteView:(InfiniteView *)view containsViewForIndex:(NSUInteger)index {
    // hardcoded yes
    return YES;
}

- (UIView *)infiniteView:(InfiniteView*)view viewForIndex:(NSUInteger)index {
    CGRect frame = [scrollView bounds];
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setText:[NSString stringWithFormat:@"Test %d", index]];
    [label setTextAlignment:UITextAlignmentCenter];
    
    NSUInteger hex = ((index+1) * 0x0f0f0f + (arc4random() % 0xfff)) % 0xFFFFFF;
    [label setBackgroundColor:[UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.f
                                              green:((float)((hex & 0xFF00) >> 8))/255.f
                                               blue:((float)(hex & 0xFF))/255.f
                                              alpha:1.f]];
    return label;
}

//@optional
- (void)infiniteView:(InfiniteView *)view didScrollToViewAtIndex:(NSUInteger)index {
    NSLog(@"Switched to index: %d", index);
}

@end
