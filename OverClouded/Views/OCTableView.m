//
//  OCTableView.m
//  OverClouded
//
//  Created by Parag Dulam on 21/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCTableView.h"
#import "OCDragView.h"

@interface OCTableView()<UIGestureRecognizerDelegate>
{
    UIView *draggingView;
}
-(void) enableFileMoveGestureRecognizer;

@end

@implementation OCTableView

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
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [longPressGesture setDelegate:self];
    longPressGesture.minimumPressDuration = 2.f;
    [self addGestureRecognizer:longPressGesture];
}



#pragma mark - UIGestureRecognizerDelegate


-(void) longPressGesture:(UILongPressGestureRecognizer *) gestureRecognizer
{
    UITableView *tableView = (OCTableView *)gestureRecognizer.view;
    CGPoint startPoint = [gestureRecognizer locationInView:tableView];
    NSIndexPath *indPath = [tableView indexPathForRowAtPoint:startPoint];
    if (indPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        NSLog(@"long press on table view at row %d", indexPath.row);
        
        tableView.scrollEnabled = NO;
        
        draggingView = [self.dragTableViewDelegate dragViewForTableView:self];
        [self addSubview:draggingView];
        CGRect dragViewFrame = draggingView.frame;
        
        dragViewFrame.size.width = 200;
        dragViewFrame.size.height = 25;
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
        [self.dragTableViewDelegate tableView:selectedObj didSelectFile:selectedObj withDraggingView:draggingView];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [gestureRecognizer locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        NSLog(@"Ended long press on table view at row %d", indexPath.row);
        
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
            [draggingView removeFromSuperview];
        }];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint p = [gestureRecognizer locationInView:tableView];
        
        NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];
        NSInteger firstIndex = [[visibleIndexPaths firstObject] row] + 2;
        NSInteger lastIndex = [[visibleIndexPaths lastObject] row] - 2;
        
        NSIndexPath *firstVisibleIndexPath = [NSIndexPath indexPathForRow:firstIndex inSection:0];
        NSIndexPath *lastVisibleIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
        
        CGRect firstCellRect = [tableView rectForRowAtIndexPath:firstVisibleIndexPath];
        CGRect lastCellRect = [tableView rectForRowAtIndexPath:lastVisibleIndexPath];
        
        draggingView.hidden = NO;
        if (draggingView.frame.origin.y < firstCellRect.origin.y) {
            CGRect targetRect = CGRectZero;
            targetRect.size = firstCellRect.size;
            targetRect.origin.x = firstCellRect.origin.x;
            targetRect.origin.y = firstCellRect.origin.y - (firstCellRect.size.height * 2);
            draggingView.hidden = YES;
            //            [tableView scrollRectToVisible:targetRect animated:YES];
            [tableView scrollToRowAtIndexPath:[visibleIndexPaths firstObject]
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
        }
        
        if (draggingView.frame.origin.y > lastCellRect.origin.y) {
            CGRect targetRect = CGRectZero;
            targetRect.size = lastCellRect.size;
            targetRect.origin.x = lastCellRect.origin.x;
            targetRect.origin.y = lastCellRect.origin.y + (lastCellRect.size.height * 3);
            
            draggingView.hidden = YES;
            [tableView scrollToRowAtIndexPath:[visibleIndexPaths lastObject]
                             atScrollPosition:UITableViewScrollPositionBottom
                                     animated:YES];
        }
        
        if (tableView.contentOffset.y <= 0 || tableView.contentOffset.y >= tableView.contentSize.height - tableView.frame.size.height) {
            draggingView.hidden = NO;
        }
        CGPoint centerPoint = CGPointMake(tableView.center.x,p.y - 30);
        draggingView.center = centerPoint;
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
