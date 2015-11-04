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
#import "CoreData/CoreData.h"

@interface DataAccessObject : NSObject

@property (strong, nonatomic) NSMutableArray *companyList;
@property (strong, nonatomic) NSMutableArray *stockPrices;
@property (strong, nonatomic) NSString *dbPath;
@property (strong) NSManagedObjectModel *model;
@property (strong) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableArray *result;
@property (strong, nonatomic) NSEntityDescription *compEntity;

-(void)getCompaniesAndProducts;
+(instancetype)sharedInstance;
-(void)updateStockPrices;
-(NSString*) archivePath;
-(void)initModelContext;
-(void)readOrCreateCoreData;
-(void)saveChanges;
-(void)deleteComp:(long)index;
-(void)editCompany:(NSString*)company_Name withStockCode:(NSString*)stockCode logo:(NSString*)companyLogo andIndex:(long)index;
-(void)addCompany:(NSString*)company_Name withStockCode:(NSString*)stockCode logo:(NSString*)companyLogo;
-(void)editProduct:(NSString*)product_Name withLogo:(NSString*)product_logo url:(NSString*)prod_url andIndex:(NSInteger*)index forCompanyIndex:(NSInteger *)companyIndex;
-(void)addProduct:(NSString*)product_Name withLogo:(NSString*)logo andUrl:(NSString*)url toCompanyID:(NSInteger *)index ;
-(void)deletProd:(long)index forCompanyIndex:(NSInteger *)companyIndex;
@end


