//
//  editCompanyCellViewController.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/11/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "editCompanyCellViewController.h"

@interface editCompanyCellViewController ()

@end

@implementation editCompanyCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"Customize Your Companies!";
    
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


- (IBAction)makeChangesButton:(id)sender {
    
    
   NSString *editCompanyCell = self.createdCompanyName.text;
    NSString *editCompanyPic = @"yourlogo.png";
    
    NSString *editCompStock = self.editStockCodeText.text;
    
    NSLog(@"%ld",self.indexPath.row);
    
    
    Company *comp = [self.compList objectAtIndex:self.indexPath.row];
    
    comp.companyName = editCompanyCell;
    
    comp.companyLogo = editCompanyPic;
    
    if([self.editStockCodeText.text isEqualToString:@""]){
        comp.stockCode = @"N/A";
    }else
    {
    comp.stockCode = editCompStock;
    }

    [self.navigationController popViewControllerAnimated:YES];

    [self.dao save];

}


- (void)dealloc {
    [_createdCompanyName release];
    [_createdCompNameTitle release];
    [_compViewTitle release];
    [_editStockCodeText release];
    [super dealloc];
}
@end
