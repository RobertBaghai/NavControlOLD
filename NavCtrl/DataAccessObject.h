//
//  DataAccessObject.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/7/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
#import "Product.h"
#import "Company.h"
#import <Foundation/Foundation.h>

@interface DataAccessObject : NSObject

-(void)getCompaniesAndProducts;

@property (retain, nonatomic) NSMutableArray *companyList;

@property (retain, nonatomic) NSMutableArray *stockPrices;

@property (strong, nonatomic) NSString * plistPath;


-(void)updateStockPrices;

-(void) unarchiveSavedObjectsInPath: (NSString*) filepath;
-(void) createAndArchiveObjectsAtPath:(NSString *)filepath;
-(void)createCompaniesAndProducts;
-(void)save;


+(instancetype)sharedInstance;


@end
