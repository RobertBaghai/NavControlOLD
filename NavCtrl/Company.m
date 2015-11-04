//
//  Company.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(void)dealloc
{
    [_companyName release];
    [_companyLogo release];
    [_stockCode release];
    [_products release];
    [_stockPrice release];
    [super dealloc];
}
 



@end