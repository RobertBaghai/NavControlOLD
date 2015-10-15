//
//  editProductCellViewController.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/12/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qcdDemoViewController.h"
#import "ChildViewController.h"
#import "DataAccessObject.h"

@interface editProductCellViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *editProductTitle;

@property (retain, nonatomic) IBOutlet UILabel *editProductNameLabel;

@property (retain, nonatomic) IBOutlet UITextField *productNameText;

@property (retain, nonatomic) IBOutlet UILabel *editProductUrlLabel;

@property (retain, nonatomic) IBOutlet UITextField *productUrlText;

- (IBAction)makeProductChanges:(id)sender;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property (retain, nonatomic) NSMutableArray *compList;

@end
