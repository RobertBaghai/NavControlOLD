//
//  ChildViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//
#import "ChildViewController.h"
#import "UrlViewController.h"
#import "Product.h"
#import "addProductsViewController.h"
#import "editProductCellViewController.h"

@interface ChildViewController ()
{
    long indexPathCounter;
}

@end

@implementation ChildViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dao = [DataAccessObject sharedInstance];
    
    UIImage *addImage = [UIImage imageNamed:@"itemAdd"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:addImage style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    NSArray *buttons = [[NSArray alloc]initWithObjects:addButton,self.editButtonItem,nil];
    self.navigationItem.rightBarButtonItems = buttons;
    self.tableView.delaysContentTouches = NO;
    
    UILongPressGestureRecognizer *holdEdit = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [holdEdit setCancelsTouchesInView:NO];
    holdEdit.minimumPressDuration = 2.0; //seconds
    //    holdEdit.delegate = self;
    [self.tableView addGestureRecognizer:holdEdit];
    [buttons release];
    [holdEdit release];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    editProductCellViewController *editProductView =[[[editProductCellViewController alloc]
                                                     initWithNibName:@"editProductCellViewController"
                                                     bundle:nil] autorelease];
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        
        editProductView.compList = self.companyProducts;
        UITableView* tableView = (UITableView*)self.view;
        CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
        NSIndexPath* row = [tableView indexPathForRowAtPoint:touchPoint];
        if (row != nil) {
            editProductView.indexPath = row;
        }
        [self.navigationController pushViewController:editProductView animated:YES];
    }

}

-(void)add:(id)sender
{
    NSLog(@"Add button pressed");
    addProductsViewController *addProdView = [[addProductsViewController alloc] initWithNibName:@"addProductsViewController" bundle:nil];
    addProdView.company = self.company;
    [self.navigationController pushViewController:addProdView animated:YES];
    [addProdView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.companyProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    //configure cell
    Product *productN = [self.company.products objectAtIndex:[indexPath row]];
    cell.textLabel.text = productN.productName;
    cell.imageView.image = [UIImage imageNamed: productN.productLogo];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        Product *prod = [self.companyProducts objectAtIndex:indexPath.row];
        
        NSLog(@"Delete Prod = %@",prod.productName);
        NSString *deleteStatement = [NSString stringWithFormat:@"DELETE FROM Product WHERE p_name IS '%s'",[prod.productName UTF8String]];
        NSLog(@"Delete Statement = %@",deleteStatement);
        [self.dao deleteData:deleteStatement];
        
        [self.companyProducts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSUInteger fromRow = [fromIndexPath row];
    NSUInteger toRow = [toIndexPath row];
    Product *prodToMove = [self.companyProducts objectAtIndex:fromRow];
    [prodToMove retain];
    [self.companyProducts removeObjectAtIndex:fromRow];
    [self.companyProducts insertObject:prodToMove atIndex:toRow];
    [prodToMove release];
    self.company.products = self.companyProducts;
    for(int i = 1; i<= [self.companyProducts count]; i++){
        Product *prod = [self.companyProducts objectAtIndex:i-1];
        NSLog(@"prod.productID = %d \n",[prod.productID intValue]);
        NSString *updateStmt = [NSString stringWithFormat:@"UPDATE Product SET p_position = %d WHERE id = %d",i,[prod.productID intValue]];
        [self.dao moveData:updateStmt];
        NSLog(@"Prod name at index %d = %@",i,prod.productName);
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrlViewController *urlViewController = [[UrlViewController alloc] initWithNibName:@"UrlViewController" bundle:nil];
    Product *productU = [self.companyProducts objectAtIndex:[indexPath row]];
    [urlViewController setURL: [NSString stringWithFormat:@"%@", productU.productURL]];
    [self.navigationController pushViewController:urlViewController animated:YES];
    [urlViewController release];
}



@end
