//
//  addViewController.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/8/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "addViewController.h"

@interface addViewController ()

@end

@implementation addViewController

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


- (IBAction)submitInfo:(id)sender {

    NSString *compName = self.textName.text;
    NSString *compLogo = @"defaultCLogo.png";
    
    
    NSString *compStock = self.textStockCode.text;
   
    Company *comp = [[Company alloc] init];
    comp.companyName = compName;
    comp.companyLogo = compLogo;
   
    
    if([self.textStockCode.text isEqualToString:@""]){
        comp.stockCode = @"N/A";
    }else
    {
    comp.stockCode = compStock;
    }
    
    
    comp.products = [[NSMutableArray alloc]init];

    
    
    [self.companyList addObject:comp];

    [self.navigationController popViewControllerAnimated:YES];
    [self.dao save];


}



- (void)dealloc {
    [_textTitle release];
    [_textName release];
    [_textStockCode release];
    [super dealloc];
}

@end
