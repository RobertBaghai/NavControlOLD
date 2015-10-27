//
//  qcdDemoViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//
#import "Company.h"
#import "qcdDemoViewController.h"
#import "ChildViewController.h"
#import "Product.h"
#import "addViewController.h"
#import "editCompanyCellViewController.h"

@interface qcdDemoViewController ()

{
    long indexPathCounter;
}

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
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                      target:self
                                      action:@selector(refresh:)];
    UIImage *addImage = [UIImage imageNamed:@"itemAdd"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:addImage style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    NSArray *buttons = [[NSArray alloc]initWithObjects:refreshButton,addButton,self.editButtonItem,nil];
    self.navigationItem.rightBarButtonItems = buttons;
    
    _dao = [DataAccessObject sharedInstance];
    [self.dao findOrCopyDB];
    self.companyList = self.dao.companyList;
    
    self.title = @"Mobile device makers";
    self.tableView.delaysContentTouches = NO;
    
    UILongPressGestureRecognizer *holdEdit = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [holdEdit setCancelsTouchesInView:NO];
    holdEdit.minimumPressDuration = 2.0; //seconds
    [self.tableView addGestureRecognizer:holdEdit];
    [buttons release];
    [holdEdit release];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadStockPrices];
    
}

-(void)loadStockPrices{
    //Async Request
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *str = @"";
    
    for (int j=0; j<[self.companyList count]; j++) {
        Company *company = [self.companyList objectAtIndex:j];
        str = [str stringByAppendingString:company.stockCode];
        if (j!= [self.companyList count]-1) {
            str = [str stringByAppendingString:@"+"];
        }
    }
    str = [NSString stringWithFormat:@"http://finance.yahoo.com/d/quotes.csv?s=%@&f=a",str];
    
    [[ session dataTaskWithURL:[NSURL URLWithString:str]
             completionHandler:^(NSData *data,
                                 NSURLResponse *response,
                                 NSError *error) {
                 // handle response
                 if (error==nil) {
                     NSLog(@"Perfect \n\n");
                     
                     NSString * stockString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
                     self.rows = (NSMutableArray*)[stockString componentsSeparatedByString:@"\n"];
                     [self.rows removeLastObject];
                     NSLog(@"%@", self.rows);
                     self.dao.stockPrices = self.rows;
                     [self.dao updateStockPrices];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.tableView reloadData];
                     });
                 }
             } ]resume];
    [_rows retain];
    [_rows release];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    editCompanyCellViewController *editView =[[[editCompanyCellViewController alloc]
                                              initWithNibName:@"editCompanyCellViewController" bundle:nil] autorelease];
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        editView.compList = self.companyList;
        
        UITableView* tableView = (UITableView*)self.view;
        CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
        NSIndexPath* row = [tableView indexPathForRowAtPoint:touchPoint];
        if (row != nil) {
            editView.indexPath = row;
        }
        
        [self.navigationController pushViewController:editView animated:YES];
    }
}

-(void)refresh:(id)sender
{
    [self.navigationController pushViewController:self.childVC animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)add:(id)sender
{
    NSLog(@"Add button pressed");
    addViewController *addView = [[addViewController alloc] initWithNibName:@"addViewController" bundle:nil];
    addView.companyList = self.companyList;
    [self.navigationController pushViewController:addView animated:YES];
    [addView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
}
    
    Company *companyN = [self.companyList objectAtIndex:[indexPath row]];
    NSString *stockPrice = nil;
    if (companyN.stockPrice == nil) {
        stockPrice = @"   No Stock Info Available";
    }else{
        stockPrice = [@"                Current Stock Price:    " stringByAppendingString:companyN.stockPrice];
    }
    cell.textLabel.text = [companyN.companyName stringByAppendingString:stockPrice];;
    cell.imageView.image = [UIImage imageNamed: companyN.companyLogo];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Company *comp = [self.companyList objectAtIndex:indexPath.row];
        [self.dao deleteData:[NSString stringWithFormat:@"DELETE FROM Company WHERE c_name IS '%s'",[comp.companyName UTF8String]]];
        [self.companyList removeObjectAtIndex:indexPath.row];
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
    NSLog(@"move data %ld to %ld", (unsigned long)fromRow, (unsigned long)toRow);
    
    Company *companyFrom = [self.companyList objectAtIndex:fromRow];
    [companyFrom retain];
    [self.companyList removeObjectAtIndex:fromRow];
    [self.companyList insertObject:companyFrom atIndex:toRow];
    [companyFrom release];
    self.dao.companyList = self.companyList;
    for (int i=1; i <= [self.companyList count]; i++) {
        Company *comp = [self.companyList objectAtIndex:i-1];
        NSString *updateStmt = [NSString stringWithFormat:@"UPDATE Company SET c_position = %d WHERE id = %d",i,[comp.companyID intValue]];
        [self.dao moveData:updateStmt];
        NSLog(@"Comp Name at index %d = %@",i,comp.companyName);
    }
//    [_companyList release];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Company *company = [self.companyList objectAtIndex:indexPath.row];
    self.childVC.title = company.companyName;
    self.childVC.company = company;
    [self.childVC setCompanyProducts:company.products];
    [self.navigationController pushViewController:self.childVC animated:YES];
}

@end
