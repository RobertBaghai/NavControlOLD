//
//  qcdDemoViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DataAccessObject.h"
#import <sqlite3.h>

@class ChildViewController;

@interface qcdDemoViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *companyList;
@property (strong, nonatomic) NSMutableArray *rows;
@property (nonatomic, retain) IBOutlet  ChildViewController * childVC;
@property (strong, nonatomic) DataAccessObject *dao;
-(void)add:(id)sender;



@end
