//
//  CustomCompanyCollectionViewCell.m
//  NavCtrl
//
//  Created by Robert Baghai on 11/5/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    // background color
    UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView = bgView;
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]];
    //selected background
    UIView *selectedView = [[UIView alloc]initWithFrame:self.bounds];
    self.selectedBackgroundView = selectedView;
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green.png"]];
    [bgView release];
    [selectedView release];
}

- (void)dealloc {
    [_image release];
    [_label release];
    [_detailLabel release];
    [super dealloc];
}

@end
