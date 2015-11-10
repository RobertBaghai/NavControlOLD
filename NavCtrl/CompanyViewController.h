//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Robert Baghai on 11/5/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccessObject.h"
#import "CustomCell.h"

@interface CompanyViewController : UICollectionViewController 

@property (strong, nonatomic) NSMutableArray *companyList;
@property (strong, nonatomic) NSMutableArray *rows;
@property (strong, nonatomic) DataAccessObject *dao;
@property (strong, nonatomic) UIBarButtonItem *selectCells;
@property (strong, nonatomic) UIBarButtonItem *deleteCells;
@property (strong, nonatomic) NSMutableArray *arrayOfSelectedCells;
@property(nonatomic) NSInteger *indexPath;

@end