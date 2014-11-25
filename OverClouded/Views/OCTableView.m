//
//  OCTableView.m
//  OverClouded
//
//  Created by Parag Dulam on 21/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCTableView.h"
#import "OCDragView.h"
#import "AppDelegate.h"


#define IS_DRAGGING_UP @"isDraggingUp"

@interface OCTableView()<UIGestureRecognizerDelegate>
{
    UIView *draggingView;
    UILongPressGestureRecognizer *longPressGesture;
    
    NSIndexPath *fromIndexPath;
    NSIndexPath *draggedIndexPath;
    NSIndexPath *toIndexPath;
    NSTimer *holdTimer;
    NSInteger holdCounter;
}
-(void) enableFileMoveGestureRecognizer;

@property(nonatomic,strong) NSIndexPath *fromIndexPath;
@property(nonatomic,strong) NSIndexPath *draggedIndexPath;
@property(nonatomic,strong) NSIndexPath *toIndexPath;
@property(nonatomic,strong) NSTimer *holdTimer;

@end

@implementation OCTableView
@synthesize fromIndexPath;
@synthesize draggedIndexPath;
@synthesize toIndexPath;
@synthesize holdTimer;

-(void) setDragTableViewDelegate:(id<OCTableViewDelegate>)aDelegate
{
    dragTableViewDelegate = aDelegate;
    [self enableFileMoveGestureRecognizer];
}

-(id<OCTableViewDelegate>) dragTableViewDelegate
{
    return dragTableViewDelegate;
}

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style andGestureRecognizer:(UILongPressGestureRecognizer *) lngPrsGestureRecognizer
{
    if (self = [super initWithFrame:frame
                              style:style]) {
    }
    return self;
}


-(void) enableFileMoveGestureRecognizer
{
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [longPressGesture setDelegate:self];
    longPressGesture.delaysTouchesBegan = YES;
    longPressGesture.minimumPressDuration = 1.f;
    [self addGestureRecognizer:longPressGesture];
}



#pragma mark - Helpers

-(void) timerFired:(NSTimer *) aTimer
{
    if ([self.dragTableViewDelegate shouldIndexPath:draggedIndexPath AnimateFor:self]) {
        holdCounter++;
        NSLog(@"holdCounter %d",holdCounter);
        if (holdCounter == 5) {
            [self.dragTableViewDelegate tableView:self
                         isDraggingNowOnIndexPath:draggedIndexPath
                            withStartingIndexPath:fromIndexPath];
            NSLog(@"called");
            [aTimer invalidate];
            holdCounter = 0;
        } else {
            [self.dragTableViewDelegate tableView:self
                         isDraggingNowOnIndexPath:draggedIndexPath
                            withStartingIndexPath:fromIndexPath
                                  WithHoldCounter:holdCounter];
        }
    } else {
        [aTimer invalidate];
        holdCounter = 0;
    }
}


#pragma mark - UIGestureRecognizerDelegate


-(void) longPressGesture:(UILongPressGestureRecognizer *) gestureRecognizer
{
    UITableView *tableView = (OCTableView *)gestureRecognizer.view;
    CGPoint startPoint = [gestureRecognizer locationInView:tableView];
    NSIndexPath *indPath = [tableView indexPathForRowAtPoint:startPoint];
    if (indPath == nil) {
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        holdCounter = 0;
        CGPoint p = [gestureRecognizer locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        self.fromIndexPath = indexPath;
        tableView.scrollEnabled = NO;
        
        draggingView = [self.dragTableViewDelegate dragViewForTableView:self];
        [self addSubview:draggingView];
        CGRect dragViewFrame = draggingView.frame;
        
        dragViewFrame.size.width = 60;
        dragViewFrame.size.height = 60;
        draggingView.center = p;
        
        CGPoint centerPoint = CGPointMake(tableView.center.x,
                                          p.y - 30);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3f];
        
        draggingView.frame = dragViewFrame;
        draggingView.center = centerPoint;
        draggingView.alpha = 1.f;
        
        [UIView commitAnimations];
        
        //return back with a delegate
        
        id selectedObj = [[self.dragTableViewDelegate dataForTableView:self] objectAtIndex:indexPath.row];
        [self.dragTableViewDelegate tableView:self
                                didSelectFile:selectedObj
                                  AtIndexPath:fromIndexPath
                             withDraggingView:draggingView];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint p = [gestureRecognizer locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        self.toIndexPath = indexPath;
        
        tableView.scrollEnabled = YES;
        tableView.alpha = 1.0;
        
        [UIView animateWithDuration:.3f animations:^{
            draggingView.frame = CGRectMake(draggingView.frame.origin.x,
                                            draggingView.frame.origin.y,
                                            0,
                                            0);
            draggingView.center = CGPointMake(tableView.center.x,
                                              p.y);
        } completion:^(BOOL finished) {
            [self.dragTableViewDelegate tableView:self
                                      didDropFile:[[self.dragTableViewDelegate dataForTableView:self] objectAtIndex:toIndexPath.row]
                            withStartingIndexPath:fromIndexPath
                                toEndingIndexPath:toIndexPath];
            
            [draggingView removeFromSuperview];
            [self.holdTimer invalidate];
            holdCounter = 0;
        }];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        
        CGPoint p = [gestureRecognizer locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        if (indexPath.section == fromIndexPath.section &&
            indexPath.row != fromIndexPath.row) {
            if (draggedIndexPath.section == indexPath.section &&
                draggedIndexPath.row != indexPath.row) {
                self.draggedIndexPath = indexPath;
                [self.holdTimer invalidate];
                holdCounter = 0;
                self.holdTimer = [NSTimer timerWithTimeInterval:1.f
                                                         target:self
                                                       selector:@selector(timerFired:)
                                                       userInfo:nil
                                                        repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.holdTimer forMode:NSDefaultRunLoopMode];
            }
        }
        CGPoint centerPoint = CGPointMake(tableView.center.x,p.y - 30);
        draggingView.center = centerPoint;
        
        CGRect boundingRect = CGRectMake(tableView.contentOffset.x,
                                         tableView.contentOffset.y + 60,
                                         tableView.bounds.size.width,
                                         tableView.bounds.size.height - 120);
        draggingView.hidden = NO;
        BOOL isDraggingUp = NO;
        if (draggingView.frame.origin.y <= boundingRect.origin.y) {
            draggingView.hidden = YES;
            isDraggingUp = YES;
        }
        
        if (CGRectGetMaxY(draggingView.frame) >= CGRectGetMaxY(boundingRect)) {
            draggingView.hidden = YES;
        }

        if (draggingView.hidden) {
            CGFloat offset = (2 * tableView.rowHeight);
            CGFloat contentOffsetY = isDraggingUp ? tableView.contentOffset.y - offset : tableView.contentOffset.y + offset;
            contentOffsetY = contentOffsetY <= -64.f ? -64.f : contentOffsetY;
            [tableView setContentOffset:CGPointMake(tableView.contentOffset.x, contentOffsetY) animated:YES];
        }
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL retVal = YES;
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        retVal = NO;
    }
    return retVal;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
