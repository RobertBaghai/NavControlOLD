//
//  editProductCellViewController.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/12/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "editProductCellViewController.h"

@interface editProductCellViewController ()

@end

@implementation editProductCellViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dao = [DataAccessObject sharedInstance];
    self.productNameText.text = self.editName;
    self. productUrlText.text = self.editUrl;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction)makeProductChanges:(id)sender
{
    NSString *editProductName = self.productNameText.text;
    NSString *editProductUrl = self. productUrlText.text;
    NSString *editProductLogo = @"yourlogo.png";
    Product *prod = [self.compList objectAtIndex:self.indexPath.row];
    prod.productName = editProductName;
    prod.productURL = editProductUrl;
    prod.productLogo = editProductLogo;
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.dao updateProduct:self.productNameText.text withLogo:editProductLogo url:self.productUrlText.text andIndex:(NSInteger*)self.indexPath.row forCompanyIndex:self.companyIndex];
}

- (void)dealloc {
    [_editProductTitle release];
    [_editProductNameLabel release];
    [_productNameText release];
    [_editProductUrlLabel release];
    [_productUrlText release];
    [_indexPath release];
    [_compList release];
    [super dealloc];
}

@end
