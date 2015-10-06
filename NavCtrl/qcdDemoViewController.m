//
//  qcdDemoViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "qcdDemoViewController.h"
#import "ChildViewController.h"

@interface qcdDemoViewController ()

@end

@implementation qcdDemoViewController

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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.companyList = [[NSMutableArray alloc]
                       initWithObjects:@"Apple mobile devices",
                                       @"Samsung mobile devices",
                                       @"HTC mobile devices",
                                       @"LG mobile devices",nil];
    
    self.companyPics=[[NSMutableArray alloc] initWithObjects:@"apple.png",
                                                      @"samsung.png",
                                                      @"htc.png",
                                                      @"lg.png", nil];
    
    self.title = @"Mobile device makers";
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    
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
    return [self.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    
    // Configure the cell...


    cell.textLabel.text = [self.companyList objectAtIndex:[indexPath row]];
//    NSString * imageName = [self.companyPics objectAtIndex:[indexPath row]];
//    UIImage* theImage = [UIImage imageNamed:imageName];
//    cell.imageView.image= theImage;
    
    cell.imageView.image = [UIImage imageNamed:[self.companyPics objectAtIndex:[indexPath row]]];
    
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
        [self.companyList removeObjectAtIndex:indexPath.row];
        [self.companyPics removeObjectAtIndex:indexPath.row];
    
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    NSString *stringToMove = [self.companyList objectAtIndex:fromRow];
    [self.companyList removeObjectAtIndex:fromRow];
    [self.companyList insertObject:stringToMove atIndex:toRow];
    
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

    NSString *compName = [self.companyList objectAtIndex:indexPath.row];
    
    
    if ([compName isEqualToString:@"Apple mobile devices"]) {
        self.childVC.title = @"Apple mobile devices";
    }
    
    else if ([compName isEqualToString:@"Samsung mobile devices"]) {
        self.childVC.title = @"Samsung mobile devices";
    }
    else if ([compName isEqualToString:@"HTC mobile devices"]) {
        self.childVC.title = @"HTC mobile devices";
    }
    else if ([compName isEqualToString:@"LG mobile devices"]) {
        self.childVC.title = @"LG mobile devices";
    }
   
    
    [self.navigationController pushViewController:self.childVC animated:YES];
    
  
    

}
 


@end
