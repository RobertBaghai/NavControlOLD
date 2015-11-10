//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Robert Baghai on 11/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccessObject.h"
#import "Company.h"

@interface ProductViewController : UICollectionViewController

@property (strong, nonatomic) NSMutableArray *companyProducts;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSMutableArray *pics;
@property (strong, nonatomic) DataAccessObject *dao;
@property(nonatomic) NSInteger *compIndexPath;
@property (strong, nonatomic) UIBarButtonItem *selectCells;
@property (strong, nonatomic) UIBarButtonItem *deleteCells;
@property (strong, nonatomic) NSMutableArray *arrayOfSelectedCells;
@property(nonatomic) NSInteger *indexPath;

@end
