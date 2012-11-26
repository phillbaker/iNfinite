//
//  InfiniteScrollView.h
//  iNfinite
//
//  Created by Baker, Phillip on 11/25/12.
//  Copyright (c) 2012 phillbaker. All rights reserved.
//

#import <UIKit/UIKit.h>

// class declaration so the protocols can reference it
@class InfiniteView;

#pragma mark -
#pragma mark Protocols
#pragma mark -

@protocol InfiniteViewDataSource <NSObject>

@required
- (BOOL)infiniteViewHasViews:(InfiniteView *)view;
- (BOOL)infiniteView:(InfiniteView *)view containsViewForIndex:(NSUInteger)index;
- (UIView *)infiniteView:(InfiniteView*)view viewForIndex:(NSUInteger)index;

@end

@protocol InfiniteViewDelegate <NSObject>

@optional
- (void)infiniteView:(InfiniteView *)view didScrollToViewAtIndex:(NSUInteger)index;

@end

#pragma mark -
#pragma mark Class declaration
#pragma mark -

@interface InfiniteView : UIScrollView <UIScrollViewDelegate> {}

@property (nonatomic, assign) id <InfiniteViewDataSource> dataSource;
@property (nonatomic, assign) id <InfiniteViewDelegate> infiniteDelegate;

- (id)initWithFrame:(CGRect)frame
         dataSource:(id <InfiniteViewDataSource>) dataSource
           delegate:(id <InfiniteViewDelegate>) delegate;

- (void)reloadData;

@end


