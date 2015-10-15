//
//  ChildViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//
#import "Company.h"
#import <UIKit/UIKit.h>

@interface ChildViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *companyProducts;

@property (strong, nonatomic) Company *company;


@property (nonatomic, retain) NSMutableArray *pics;

-(void)add:(id)sender;


@end
