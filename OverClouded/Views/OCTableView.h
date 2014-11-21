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


@end



@protocol OCTableViewDelegate <NSObject>
@required
-(NSArray *) dataForTableView:(OCTableView *) tableView;
-(UIView *) dragViewForTableView:(OCTableView *) tableView;

@optional
-(void) tableView:(OCTableView *) tableView didSelectFile:(id) file withDraggingView:(UIView *) aView;

@end