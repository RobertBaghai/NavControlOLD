//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Robert Baghai on 11/5/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"
#import "Company.h"
#import "Product.h"
#import "addViewController.h"
#import "editCompanyCellViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface CompanyViewController ()
{
    BOOL selectionEnabled;
}
@end

@implementation CompanyViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    selectionEnabled = YES;
    _dao = [DataAccessObject sharedInstance];
    [_dao readOrCreateCoreData];
    self.companyList = _dao.companyList;
    self.arrayOfSelectedCells = [[NSMutableArray alloc] init] ;
    //        self.collectionView.backgroundColor=[UIColor darkGrayColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.title = @"Mobile Device Makers";
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewWillAppear:)];
    UIImage *addImage = [UIImage imageNamed:@"itemAdd"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:addImage style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    self.selectCells = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(select:)] ;
    self.deleteCells = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(delete:)];
    NSArray *buttons = [[NSArray alloc] initWithObjects:refreshButton,addButton,_selectCells,_deleteCells, nil];
    self.navigationItem.rightBarButtonItems = buttons;
    self.collectionView.allowsMultipleSelection = YES;
    //longPress gestureRecognizer added to collectionView
    UILongPressGestureRecognizer *holdEdit = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleLongPress:)];
    [holdEdit setCancelsTouchesInView:YES];
    holdEdit.minimumPressDuration = 1.0; //seconds
    [self.collectionView addGestureRecognizer:holdEdit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadStockPrices];
    self.selectCells.title = @"Select";
    self.deleteCells.tintColor = [UIColor clearColor];
    [self.arrayOfSelectedCells removeAllObjects];
}

-(void)loadStockPrices {
    //Async Request With AFNetworking
    NSString *str = @"";
    for (int j=0; j<[self.companyList count]; j++) {
        Company *company = [self.companyList objectAtIndex:j];
        str = [str stringByAppendingString:company.stockCode];
        if (j!= [self.companyList count]-1) {
            str = [str stringByAppendingString:@"+"];
        }
    }
    str = [NSString stringWithFormat:@"http://finance.yahoo.com/d/quotes.csv?s=%@&f=a",str];
    //    NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\n\nSuccess with AFNetworking :\n%@", operation.responseString);
        NSString * stockString = [[NSString alloc] initWithData:operation.responseData encoding:NSASCIIStringEncoding];
        self.rows = (NSMutableArray*)[stockString componentsSeparatedByString:@"\n"];
        [self.rows removeLastObject];
        //                             NSLog(@"%@", self.rows);
        self.dao.stockPrices = self.rows;
        [self.dao updateStockPrices];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"error: %@",  operation.responseString);
                                      }
     ];
    [operation start];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.companyList.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(600, 150);
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    editCompanyCellViewController *editView =[[editCompanyCellViewController alloc]
                                              initWithNibName:@"editCompanyCellViewController" bundle:nil];
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        editView.compList = self.companyList;
        UICollectionView* collectView = (UICollectionView*)self.collectionView;
        CGPoint touchPoint = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *cell = [collectView indexPathForItemAtPoint:touchPoint];
        NSLog(@"Row: %ld", (long)cell.row);
        Company *companyN = [self.companyList objectAtIndex:cell.row];
        if (cell != nil) {
            editView.indexPath = cell;
        }
        editView.editName = companyN.companyName;
        editView.editStock = companyN.stockCode;
        [self.navigationController pushViewController:editView animated:YES];
    }
}

-(void)select:(id)sender{
    selectionEnabled = !selectionEnabled;
    self.selectCells.title = selectionEnabled ? @"Select" : @"Cancel";
    if ([self.selectCells.title isEqualToString:@"Select"]) {
        self.deleteCells.tintColor = [UIColor clearColor];
    }else{
        self.deleteCells.tintColor = [UIColor redColor];
    }
}

- (void)showDeleteCancelActionSheet:(NSIndexPath *)selectedPath {
    NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
    NSString *deleteButtonTitle = NSLocalizedString(@"Delete", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete the selected items?" preferredStyle:UIAlertControllerStyleActionSheet];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Canceled Deletion.");
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:deleteButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"Delete");
        for (int i = 0 ; i < self.arrayOfSelectedCells.count; i++) {
            for (int j = 0; j < self.companyList.count; j++) {
                if (self.arrayOfSelectedCells[i] == [self.companyList[j] companyID]) {
                    [self.companyList removeObjectAtIndex:j];
                    break;
                }
            }
        }
        [self.arrayOfSelectedCells removeAllObjects];
        [self.collectionView reloadData];
        [self.dao deleteComp:(int)self.indexPath];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    UIPopoverPresentationController *popoverPresentationController = [alertController popoverPresentationController];
    if (popoverPresentationController) {
        UICollectionViewCell *selectedCell = [self.collectionView cellForItemAtIndexPath:selectedPath];
        popoverPresentationController.sourceRect = selectedCell.frame;
        popoverPresentationController.sourceView = self.collectionView;
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)delete:(id)sender{
    
    NSIndexPath *indexPath = nil;
    [self showDeleteCancelActionSheet:indexPath];
    [self.collectionView reloadData];
}

-(void)add:(id)sender
{
    NSLog(@"Add button pressed");
    addViewController *addView = [[addViewController alloc] initWithNibName:@"addViewController" bundle:nil];
    addView.companyList = self.companyList;
    [self.navigationController pushViewController:addView animated:YES];
}

- (CustomCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Company *company = [self.companyList objectAtIndex:indexPath.row];
    // Configure the cell
    NSString *stockPrice = nil;
    if (company.stockPrice == nil) {
        stockPrice = @"   No Stock Info Available";
    }else{
        stockPrice = [@"Current Stock Price:    " stringByAppendingString:company.stockPrice];
    }
    cell.label.text = company.companyName;
    cell.image.image = [UIImage imageNamed: company.companyLogo];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@",stockPrice];
    company.companyID = [self.companyList objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */
// Uncomment this method to specify if the specified item should be selected
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@",[self.companyList[indexPath.row] companyName]);
//    return YES;
//}
/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 */
// - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//
//	return YES;
// }

//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//
//
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectCells.title isEqualToString:@"Cancel"]) {
        NSNumber *companyID = [self.companyList[indexPath.row] companyID];
        [self.arrayOfSelectedCells addObject:companyID];
        NSLog(@"%@",_arrayOfSelectedCells);
    }else{
        Company *comp = [self.companyList objectAtIndex:indexPath.row];
        ProductViewController *prodView = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
        prodView.company = comp;
        prodView.compIndexPath = (NSInteger*)indexPath.row;
        prodView.title = comp.companyName;
        prodView.companyProducts = comp.products;
        [self.navigationController pushViewController:prodView animated:YES];
    }
    self.indexPath = (NSInteger*)indexPath.row;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *companyID = [self.companyList[indexPath.row] companyID];
    if([self.arrayOfSelectedCells containsObject:companyID]){
        [self.arrayOfSelectedCells removeObject:companyID];
    }
    return YES;
}

@end
