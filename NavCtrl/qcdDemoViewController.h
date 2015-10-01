//
//  qcdDemoViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChildViewController;

@interface qcdDemoViewController : UITableViewController

@property (nonatomic, retain) NSArray *companyList;

@property (nonatomic, retain) IBOutlet  ChildViewController * childVC;

@end
