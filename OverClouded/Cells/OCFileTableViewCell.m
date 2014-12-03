//
//  OCFileTableViewCell.m
//  OverClouded
//
//  Created by Parag Dulam on 04/12/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCFileTableViewCell.h"

@implementation OCFileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void) layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(4.f,
                                        4.f,
                                        36.f,
                                        36.f)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
