//
//  Company.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company




- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:[self companyName] forKey:@"companyName"];
    [encoder encodeObject:[self companyLogo] forKey:@"companyLogo"];
    [encoder encodeObject:[self stockCode] forKey:@"stockCode"];
    [encoder encodeObject:[self products] forKey:@"companyProducts"];
    [encoder encodeObject:[self stockPrice] forKey:@"stockPrice"];
    
}


- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        //decode properties, other class vars
        [self setCompanyName:[decoder decodeObjectForKey:@"companyName"]];
        [self setCompanyLogo:[decoder decodeObjectForKey:@"companyLogo"]];
        [self setStockCode:[decoder decodeObjectForKey:@"stockCode"]];
        [self setProducts:[decoder decodeObjectForKey:@"companyProducts"]];
        [self setStockPrice:[decoder decodeObjectForKey:@"stockPrice"]];
        
    }
    return self;
}

@end
