
//
//  editCompanyCellViewController.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "qcdDemoViewController.h"
#import "ChildViewController.h"
#import "DataAccessObject.h"
#import <UIKit/UIKit.h>

@interface editCompanyCellViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *createdCompNameTitle;
@property (retain, nonatomic) IBOutlet UITextField *createdCompanyName;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSMutableArray *compList;
@property (strong, nonatomic) Company * company;
@property (strong, nonatomic) DataAccessObject *dao;
- (IBAction)makeChangesButton:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *compViewTitle;
@property (retain, nonatomic) IBOutlet UITextField *editStockCodeText;
@property (strong , nonatomic) NSString *editName;
@property (strong , nonatomic) NSString *editStock;

@end