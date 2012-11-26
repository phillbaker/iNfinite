//
//  InfiniteScrollView.m
//  iNfinite
//
//  Created by Baker, Phillip on 11/25/12.
//  Copyright (c) 2012 phillbaker. All rights reserved.
//

#import "InfiniteView.h"

#define INFINITE_INCREMENT 1

@implementation InfiniteView {
    CGPoint _currentOffset;
    
    NSInteger _currentIndex;
    
    UIView *_currentView;
    UIView *_previousView;
    UIView *_nextView;
}

@synthesize dataSource = _dataSource;
@synthesize infiniteDelegate = _infiniteDelegate;

- (void)commonInit {
    NSLog(@"inited");
    _currentIndex = 0;
    
    [self setDelegate:self];
    [self setPagingEnabled:YES];
}

// when added with storyboard/xib
- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"init with coder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		[self commonInit];
    }
    return self;
	
}

- (id)initWithFrame:(CGRect)frame
         dataSource:(id <InfiniteViewDataSource>) dataSource
           delegate:(id <InfiniteViewDelegate>) delegate {
    NSLog(@"init with frame");
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = dataSource;
        self.infiniteDelegate = delegate;
        
        [self commonInit];
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    [_previousView removeFromSuperview];
    [_currentView removeFromSuperview];
    [_nextView removeFromSuperview];
    
    [self setupInfiniteView];
}

- (void)setupInfiniteView {
    if([self.dataSource infiniteViewHasViews:self]) {
        // Add/remove first views
        NSInteger previousIndex = [self previousIndex];
        if(previousIndex >= 0) {
            _previousView = [self.dataSource infiniteView:self viewForIndex:previousIndex];
            [self addSubview:_previousView];
        }
        else {
            [_previousView removeFromSuperview];
            _previousView = nil;
        }
        
        _currentView = [self.dataSource infiniteView:self viewForIndex:_currentIndex];
        [self addSubview:_currentView];
        NSLog(@"setup, index: %d, current view: %@", _currentIndex, _currentView);
        
        NSInteger nextIndex = [self nextIndex];
        if(nextIndex >= 0) {
            _nextView = [self.dataSource infiniteView:self viewForIndex:nextIndex];
            [self addSubview:_nextView];
        }
        else {
            [_nextView removeFromSuperview];
            _nextView = nil;
        }
        
        [self layoutScrollView];
    }
}

/**
 * Returns the index before the current index, or a negative number signaling an invalid index. (This infinite loop stops at 0, and is not circular.)
 *
 **/
- (NSInteger)previousIndex {
    NSInteger previousIndex = _currentIndex - INFINITE_INCREMENT;
//    if (previousIndex < 0) {
//        // if we wanted it to be circular, we would set it to the last available index
//    }
    
    return previousIndex;
}

/**
 * Returns the index after the current index, or a negative number signaling an invalid index. (This infinite loop stops at the end of the datasource, and is not circular.)
 *
 * This method may be modified to return an index increment of greater than 1 to create jumping effects.
 **/
- (NSInteger)nextIndex {
    NSInteger nextIndex = _currentIndex + INFINITE_INCREMENT;
    if ([self.dataSource infiniteView:self containsViewForIndex:nextIndex]) {
        return nextIndex;
    }
    // if we wanted a circular infinite view and the nextIndex was greater than the available number of views, we'd set the next index to 0
    return -1;
}

- (void)layoutScrollView {
    if([self previousIndex] < 0) {
        NSLog(@"setting up for beginning");
        // need to setup different for at beginning, middle and end
        // for non-circular motion, we want to start at 0, without previous view, so setup is a little funky
        CGRect frame = [_currentView frame];
        frame.origin.x = 0;
        [_currentView setFrame:frame];
        
        frame = [_nextView frame];
        frame.origin.x = [self frame].size.width;
        [_nextView setFrame:frame];
        
        [self setContentSize:CGSizeMake([self frame].size.width * 2, [self frame].size.height)];
        [self setContentOffset:CGPointZero];
    }
    else if ([self nextIndex] < 0) {
        // end
        //TODO
        NSLog(@"setting up for end");
    }
    else {
        // middle
        NSLog(@"setting up for middle");
        //    NSInteger count = 0;
        //    if(_previousView) {
        CGRect frame = [_previousView frame];
        frame.origin.x = 0;
        [_previousView setFrame:frame];
        //        count += 1;
        //    }
        
        frame = [_currentView frame];
        frame.origin.x = [self frame].size.width;
        [_currentView setFrame:frame];
        //    count += 1;
        
        //    if(_nextView) {
        frame = [_nextView frame];
        frame.origin.x = [self frame].size.width * 2;
        [_nextView setFrame:frame];
        //        count += 1;
        //    }
        
        [self setContentSize:CGSizeMake([self frame].size.width * 3, [self frame].size.height)];
        [self setContentOffset:CGPointMake([self frame].size.width, 0)];
    }
    

    
    
    _currentOffset = [self contentOffset];
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    // Intercept drag events or send event on to the next responder
//    if (!self.dragging) {
//        UITouch *touch = [touches anyObject];
//        CGPoint newPoint = [touch locationInView:self];
//        
////        UIView *result = [self gridViewAtPoint:newPoint];
////        if (self.gridDelegate && [self.gridDelegate respondsToSelector:@selector(infiniteGridView:didSelectGridAtIndex:)]) {
////            [self.gridDelegate infiniteGridView:self didSelectGridAtIndex:result.tag];
////        }
//        
//        [self.nextResponder touchesEnded: touches withEvent:event];
//    } else {
//        [super touchesEnded: touches withEvent: event];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // if we want to scroll horizontally, look at the x; if we want to scroll vertically, look at the y
    NSLog(@"%@ vs. %@", NSStringFromCGPoint([self contentOffset]), NSStringFromCGPoint(_currentOffset));
    if ([self contentOffset].x < _currentOffset.x) {
        // scroll up: switch the temp variables to shift up
        NSInteger previousIndex = [self previousIndex];
        if(previousIndex >= 0) {
            NSLog(@"switching to previous: %d", previousIndex);
            _currentIndex = previousIndex;
            
            [_nextView removeFromSuperview];
            _nextView = _currentView;
            _currentView = _previousView;
            
            NSInteger newIndex = [self previousIndex];
            if(newIndex >= 0) {
                _previousView = [self.dataSource infiniteView:self viewForIndex:newIndex];
                [self addSubview:_previousView];
            }
//            else {
//                [_previousView removeFromSuperview];
//                _previousView = nil;
//            }
            
            
            [self layoutScrollView];
        }
        else {
            NSLog(@"not switching to previous: %d", previousIndex);
        }
    }
    else if ([self contentOffset].x > _currentOffset.x) {
        // scroll down: switch the temp variables to shift down
        NSInteger nextIndex = [self nextIndex];
        if(nextIndex >= 0) {
            NSLog(@"switching to next: %d", nextIndex);
            _currentIndex = nextIndex;
            
            [_previousView removeFromSuperview];
            _previousView = _currentView;
            _currentView = _nextView;
            
            NSInteger newIndex = [self nextIndex];
            if(newIndex >= 0) {
                _nextView = [self.dataSource infiniteView:self viewForIndex:newIndex];
                [self addSubview:_nextView];
            }
//            else {
//                [_nextView removeFromSuperview];
//                _nextView = nil;
//            }
            
            [self layoutScrollView];
        }
        else {
            NSLog(@"not switching to next: %d", nextIndex);
        }
    }
    else {
        // we're equal in content offset, shouldn't do anything
        NSLog(@"not switching");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
