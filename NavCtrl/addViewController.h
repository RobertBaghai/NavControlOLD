//
//  addViewController.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/8/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qcdDemoViewController.h"
#import "DataAccessObject.h"

@interface addViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *textTitle;

@property (retain, nonatomic) IBOutlet UITextField *textName;

@property (retain, nonatomic) NSMutableArray *companyList;

@property (retain, nonatomic) IBOutlet UITextField *textStockCode;



- (IBAction)submitInfo:(id)sender;

@end
