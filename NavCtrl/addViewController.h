//
//  addViewController.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/8/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccessObject.h"
#import "Company.h"
@interface addViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *textTitle;
@property (retain, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) NSMutableArray *companyList;
@property (retain, nonatomic) IBOutlet UITextField *textStockCode;
- (IBAction)submitInfo:(id)sender;
@property (strong, nonatomic) DataAccessObject *dao;

@end
