//
//  addProductsViewController.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/9/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qcdDemoViewController.h"
#import "ChildViewController.h"
#import "DataAccessObject.h"

@interface addProductsViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *productTitle;

@property (retain, nonatomic) IBOutlet UITextField *productText;

@property (retain, nonatomic) IBOutlet UILabel *productUrlTitle;

@property (retain, nonatomic) IBOutlet UITextField *productUrlText;

@property (retain, nonatomic) NSMutableArray *companyList;
@property (strong, nonatomic) Company * company;

- (IBAction)submitProduct:(id)sender;


@property (nonatomic, retain) DataAccessObject *dao;

@end
