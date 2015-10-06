//
//  ChildViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//
#import "ChildViewController.h"
#import "UrlViewController.h"

@interface ChildViewController ()

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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.productOne = [[NSMutableArray alloc ] initWithObjects:@"iPad", @"iPod Touch",@"iPhone", nil];
    self.picsOne = [[NSMutableArray alloc] initWithObjects:@"ipad.png",@"ipodtouch.png",@"iphone.png", nil];
    self.productTwo= [[NSMutableArray alloc ] initWithObjects:@"Galaxy S5", @"Galaxy Note", @"Galaxy Tab", nil];
    self.picsTwo = [[NSMutableArray alloc] initWithObjects:@"s5.png",@"note.png",@"tab.png", nil];
    self.productThree= [[NSMutableArray alloc] initWithObjects:@"HTC One M9",@"Google Nexus",@"RE Camera", nil];
    self.picsThree = [[NSMutableArray alloc] initWithObjects: @"htcone.png", @"nexus.png", @"recamera.png", nil];
    self.productFour= [[NSMutableArray alloc] initWithObjects:@"LG G4",@"LG Tablet",@"LG Watch", nil];
    self.picsFour = [[NSMutableArray alloc] initWithObjects: @"lgg4.png",@"lgtablet.png", @"lgwatch.png", nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    [self.tableView reloadData];
    
    
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
    
    if ( [self.title isEqualToString:@"Apple mobile devices"] ) {
        return [self.productOne count];
    }
    
    else if ([self.title isEqualToString:@"Samsung mobile devices"])
    {
        return [self.productTwo count];
        
    }
    
    else if ([ self.title isEqualToString:@"HTC mobile devices"])
    {
        return [self.productThree count];
    }
    
    else
    {
        return [self.productFour count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if ( [self.title isEqualToString:@"Apple mobile devices"] ) {
        cell.textLabel.text = [self.productOne objectAtIndex:[indexPath row]];
        cell.imageView.image = [UIImage imageNamed:[self.picsOne objectAtIndex:[indexPath row]]];
    }
    else if ([self.title isEqualToString:@"Samsung mobile devices"])
    {
        cell.textLabel.text = [self.productTwo objectAtIndex:[indexPath row]];
        cell.imageView.image = [UIImage imageNamed:[self.picsTwo objectAtIndex:[indexPath row]]];
        
    }
    else if ([ self.title isEqualToString:@"HTC mobile devices"])
    {
        cell.textLabel.text = [self.productThree objectAtIndex:[indexPath row]];
        cell.imageView.image = [UIImage imageNamed:[self.picsThree objectAtIndex:[indexPath row]]];
    }
    else if ([self.title isEqualToString:@"LG mobile devices"])
    {
        cell.textLabel.text = [self.productFour objectAtIndex:[indexPath row]];
        cell.imageView.image = [UIImage imageNamed:[self.picsFour objectAtIndex:[indexPath row]]];
    }
    
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
        
        if ( [self.title isEqualToString:@"Apple mobile devices"] ) {
            [self.productOne removeObjectAtIndex:indexPath.row];
            [self.picsOne removeObjectAtIndex:indexPath.row];
        }
        else if ([self.title isEqualToString:@"Samsung mobile devices"])
        {
            [self.productTwo removeObjectAtIndex:indexPath.row];
            [self.picsTwo removeObjectAtIndex:indexPath.row];
        }
        else if ([ self.title isEqualToString:@"HTC mobile devices"])
        {
            [self.productThree removeObjectAtIndex:indexPath.row];
            [self.picsThree removeObjectAtIndex:indexPath.row];
        }
        else if ([self.title isEqualToString:@"LG mobile devices"])
        {
            [self.productFour removeObjectAtIndex:indexPath.row];
            [self.picsFour removeObjectAtIndex:indexPath.row];
        }

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView beginUpdates];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];

        
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
    
    NSString *stringToMoveOne = [self.productOne objectAtIndex:fromRow];
    [self.productOne removeObjectAtIndex:fromRow];
    [self.productOne insertObject:stringToMoveOne atIndex:toRow];
    
    NSString *stringToMoveTwo = [self.productTwo objectAtIndex:fromRow];
    [self.productTwo removeObjectAtIndex:fromRow];
    [self.productTwo insertObject:stringToMoveTwo atIndex:toRow];
    
    NSString *stringToMoveThree = [self.productThree objectAtIndex:fromRow];
    [self.productThree removeObjectAtIndex:fromRow];
    [self.productThree insertObject:stringToMoveThree atIndex:toRow];
    
    NSString *stringToMoveFour = [self.productFour objectAtIndex:fromRow];
    [self.productFour removeObjectAtIndex:fromRow];
    [self.productFour insertObject:stringToMoveFour atIndex:toRow];
    
    
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
    
    // Navigation logic may go here, for example:
    // Create the next view controller.
    UrlViewController *urlViewController = [[UrlViewController alloc] initWithNibName:@"UrlViewController" bundle:nil];

    // Pass the selected object to the new view controller.
    
    NSString *prodOne = [self.productOne objectAtIndex:indexPath.row];
    NSString *prodTwo = [self.productTwo objectAtIndex:indexPath.row];
    NSString *prodThree = [self.productThree objectAtIndex:indexPath.row];
    NSString *prodFour = [self.productFour objectAtIndex:indexPath.row];


    if ([self.title isEqualToString:@"Apple mobile devices"]){

        if ([prodOne isEqualToString:@"iPad"]){
        [urlViewController setURL:@"https://www.apple.com/ipad/"];
        
    }
        
    else if ([prodOne isEqualToString:@"iPod Touch"]){
        [urlViewController setURL:@"https://www.apple.com/ipod-touch/"];
    }
    
    else if ([prodOne isEqualToString:@"iPhone"]){
        [urlViewController setURL:@"http://www.apple.com/iphone/"];
        }
    }
    
    if ([self.title isEqualToString:@"Samsung mobile devices"]){
        
        if([prodTwo isEqualToString:@"Galaxy S5"]){
            [urlViewController setURL:@"https://www.cricketwireless.com/cell-phones/smartphones/samsung-galaxy-s5.html"];
        }
        
        else if ([prodTwo isEqualToString:@"Galaxy Note"]){
            [urlViewController setURL:@"https://www.samsung.com/us/mobile/galaxy-note/"];
        }
        
        else if ([prodTwo isEqualToString:@"Galaxy Tab"]){
            [urlViewController setURL:@"https://www.samsung.com/us/explore/tab-s2-features-and-specs/?cid=ppc-"];
        }
    }
    
    if ([ self.title isEqualToString:@"HTC mobile devices"]){
        
        if([prodThree isEqualToString:@"iHTC One M9"]){
            [urlViewController setURL:@"https://www.htc.com/us/smartphones/htc-one-m9/"];
        }
        
        else if ([prodThree isEqualToString:@"Google Nexus"]){
            [urlViewController setURL:@"https://store.google.com/product/nexus_6p?utm_source=en-ha-na-sem&utm_medium=text&utm_content=skws&utm_campaign=nexus6p&gclid=CjwKEAjws7OwBRCn2Ome5tPP8gESJAAfopWsF1f3gGR_3ME1Ixcmv8sq_vO9pzHjJwS6Sf_ztXnn_hoCiRDw_wcB"];
        }
        
        else if ([prodThree isEqualToString:@"RE Camera"]){
            [urlViewController setURL:@"https://www.htc.com/us/re/re-camera/"];
        }
    }
    
    if ([self.title isEqualToString:@"LG mobile devices"]){
        
        if([prodFour isEqualToString:@"LG G4"]){
            [urlViewController setURL:@"https://www.lg.com/us/mobile-phones/g4"];
        }
        
        else if ([prodFour isEqualToString:@"LG Tablet"]){
            [urlViewController setURL:@"https://www.lg.com/us/tablets"];
        }
        
        else if ([prodFour isEqualToString:@"LG Watch"]){
            [urlViewController setURL:@"https://www.lg.com/us/smart-watches/lg-W150-lg-watch-urbane"];
        }
    }
        
    
    // Push the view controller.
    [self.navigationController pushViewController:urlViewController animated:YES];
}
 


@end
