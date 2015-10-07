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

@end
