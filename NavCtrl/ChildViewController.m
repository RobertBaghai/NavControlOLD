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
    
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller. 
    
    UIImage *addImage = [UIImage imageNamed:@"itemAdd"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:addImage style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
       NSArray *buttons = [[NSArray alloc]initWithObjects:addButton,self.editButtonItem,nil];
    self.navigationItem.rightBarButtonItems = buttons;
    
    
    
    
    self.tableView.delaysContentTouches = NO;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    UILongPressGestureRecognizer *holdEdit = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [holdEdit setCancelsTouchesInView:NO];
    holdEdit.minimumPressDuration = 2.0; //seconds
    //    holdEdit.delegate = self;
    [self.tableView addGestureRecognizer:holdEdit];
    [holdEdit release];
    


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    editProductCellViewController *editProductView =[[editProductCellViewController alloc]
                                              initWithNibName:@"editProductCellViewController"
                                                     bundle:nil];
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Product *productN = [self.company.products objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = productN.productName;
    cell.imageView.image = [UIImage imageNamed: productN.productLogo];
    [self.dao save];


    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        

        [self.companyProducts removeObjectAtIndex:indexPath.row];
//        [self.pics removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [tableView beginUpdates];
        [tableView endUpdates];
        [self.dao save];

        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }

}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSUInteger fromRow = [fromIndexPath row];
    NSUInteger toRow = [toIndexPath row];
    
//    Product *prodToMoveOne = [self.companyProducts objectAtIndex:fromRow];
//    [prodToMoveOne retain];
//
//    [self.companyProducts removeObjectAtIndex:fromRow];
//    [self.companyProducts insertObject:prodToMoveOne atIndex:toRow];
//    
//    [prodToMoveOne release];

    [self.companyProducts exchangeObjectAtIndex:fromRow withObjectAtIndex:toRow];
    [self.dao save];


}



// Override to support conditional rearranging of the table view.
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

    // Pass the selected object to the new view controller.
    
    Product *productU = [self.companyProducts objectAtIndex:[indexPath row]];
    
    [urlViewController setURL: [NSString stringWithFormat:@"%@", productU.productURL]];
    
    
    
    // Push the view controller.
    [self.navigationController pushViewController:urlViewController animated:YES];
    [self.dao save];

}



@end
