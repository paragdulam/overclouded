//
//  OCTableView.h
//  OverClouded
//
//  Created by Parag Dulam on 21/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OCTableViewDelegate;
@interface OCTableView : UITableView
{
    __weak id<OCTableViewDelegate> dragTableViewDelegate;
}

@property (nonatomic,weak) id<OCTableViewDelegate> dragTableViewDelegate;
-(void) setDragTableViewDelegate:(id<OCTableViewDelegate>)aDelegate;


@end



@protocol OCTableViewDelegate <NSObject>
@required
-(NSArray *) dataForTableView:(OCTableView *) tableView;
-(UIView *) dragViewForTableView:(OCTableView *) tableView;
-(BOOL) shouldIndexPath:(NSIndexPath *)indexPath AnimateFor:(OCTableView *) tableView;

@optional
-(void) tableView:(OCTableView *) tableView didSelectFile:(id) file AtIndexPath:(NSIndexPath *) indexPath withDraggingView:(UIView *) aView;
-(void) tableView:(OCTableView *)tableView isDraggingNowOnIndexPath:(NSIndexPath *) dragIndexPath withStartingIndexPath:(NSIndexPath *)startIndexPath;
-(void) tableView:(OCTableView *)tableView isDraggingNowOnIndexPath:(NSIndexPath *) dragIndexPath withStartingIndexPath:(NSIndexPath *)startIndexPath WithHoldCounter:(NSInteger) counter;
-(void) tableView:(OCTableView *)tableView didDropFile:(id)file withStartingIndexPath:(NSIndexPath *) anIndexPath toEndingIndexPath:(NSIndexPath *) otherIndexPath;
@end