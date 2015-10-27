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
#import <sqlite3.h>

@interface DataAccessObject : NSObject


@property (strong, nonatomic) NSMutableArray *companyList;
@property (strong, nonatomic) NSMutableArray *stockPrices;
@property (strong, nonatomic) NSString *dbPath;

//-(void)getCompaniesAndProducts;
+(instancetype)sharedInstance;
-(void)updateStockPrices;
-(void)findOrCopyDB;
-(void)deleteData:(NSString *)deleteQuery;
-(void)addData:(NSString *)addQuery;
-(void)moveData:(NSString *)moveQuery;
-(void)editData:(NSString *)editQuery;
-(int)fetchPosition;



@end


