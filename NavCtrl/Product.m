//
//  Product.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:[self productName] forKey:@"productName"];
    [encoder encodeObject:[self productLogo] forKey:@"productLogo"];
    [encoder encodeObject:[self productURL] forKey:@"productUrl"];
    
    
}


- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self)
    {
        //decode properties, other class vars
        [self setProductName:[decoder decodeObjectForKey:@"productName"]];
        [self setProductLogo:[decoder decodeObjectForKey:@"productLogo"]];
        [self setProductURL:[decoder decodeObjectForKey:@"productUrl"]];
      
        
    }
    return self;
}


@end
