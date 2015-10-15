//
//  addProductsViewController.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/9/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "addProductsViewController.h"

@interface addProductsViewController ()

@end

@implementation addProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)submitProduct:(id)sender {
    

    
    NSString *prodName = self.productText.text;
    NSString *prodLogo = @"prodLogo.png";
    NSString *prodURL = self.productUrlText.text;
    
    Product *prod = [[Product alloc] init];
    
    prod.productName = prodName;
    prod.productLogo = prodLogo;
    prod.productURL = prodURL ;

    [self.company.products addObject:prod];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (void)dealloc {
    [_productTitle release];
    [_productText release];
    [_productUrlTitle release];
    [_productUrlText release];
    [super dealloc];
    
}
@end
