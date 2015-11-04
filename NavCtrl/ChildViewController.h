//
//  ChildViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//
#import "Company.h"
#import <UIKit/UIKit.h>
#import "DataAccessObject.h"

@interface ChildViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *companyProducts;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSMutableArray *pics;
@property (strong, nonatomic) DataAccessObject *dao;
@property(nonatomic) NSInteger *myindexPath;
-(void)add:(id)sender;


@end
