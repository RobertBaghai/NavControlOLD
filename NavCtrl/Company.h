//
//  Company.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
#import "Product.h"
#import <Foundation/Foundation.h>

@interface Company : NSObject
@property (strong, nonatomic) NSNumber *companyID;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *companyLogo;
@property (strong, nonatomic) NSString *stockCode;
@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) NSString *stockPrice;


@end
