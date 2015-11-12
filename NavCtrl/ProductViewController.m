//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Robert Baghai on 11/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "CustomCell.h"
#import "editProductCellViewController.h"
#import "UrlViewController.h"
#import "Product.h"
#import "addProductsViewController.h"

@interface ProductViewController ()
{
    BOOL selectionEnabled;
}
@end

@implementation ProductViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    selectionEnabled = YES;
    self.arrayOfSelectedCells = [[[NSMutableArray alloc] init] autorelease];
    _dao = [DataAccessObject sharedInstance];
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIImage *addImage = [UIImage imageNamed:@"itemAdd"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:addImage style:UIBarButtonItemStylePlain target:self action:@selector(add:)];
    self.selectCells = [[[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(select:)] autorelease];
    self.deleteCells = [[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(delete:)] autorelease];
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:addButton,_selectCells,_deleteCells, nil];
    self.navigationItem.rightBarButtonItems = buttons;
    UILongPressGestureRecognizer *holdEdit = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleLongPress:)];
    [holdEdit setCancelsTouchesInView:YES];
    holdEdit.minimumPressDuration = 1.0; //seconds
    [self.collectionView addGestureRecognizer:holdEdit];
    self.collectionView.allowsMultipleSelection = YES;
    [holdEdit release];
    [addButton release];
    [buttons release];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    self.selectCells.title = @"Select";
    self.deleteCells.tintColor = [UIColor clearColor];
    [self.arrayOfSelectedCells removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.companyProducts.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(600, 150);
}

- (CustomCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    Product *product = [self.companyProducts objectAtIndex:indexPath.row];
    cell.label.text = product.productName;
    cell.image.image = [UIImage imageNamed:product.productLogo];
    cell.detailLabel.text = nil;
    product.productID = [self.companyProducts objectAtIndex:indexPath.row];
    return cell;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    editProductCellViewController *editProdView =[[[editProductCellViewController alloc]
                                                   initWithNibName:@"editProductCellViewController" bundle:nil] autorelease];
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        editProdView.compList = self.companyProducts;
        editProdView.companyIndex = self.compIndexPath;
        UICollectionView* collectView = (UICollectionView*)self.collectionView;
        CGPoint touchPoint = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath* row = [collectView indexPathForItemAtPoint:touchPoint];
        NSLog(@"Row: %ld", (long)row.row);
        Product *product = [self.companyProducts objectAtIndex:[row row]];
        if (row != nil) {
            editProdView.indexPath = row;
        }
        editProdView.editName = product.productName;
        editProdView.editUrl = product.productURL;
        [self.navigationController pushViewController:editProdView animated:YES];
    }
}

-(void)select:(id)sender {
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
        for (int i = 0 ; i < self.arrayOfSelectedCells.count; i++) {
            for (int j = 0; j < self.companyProducts.count; j++) {
                if (self.arrayOfSelectedCells[i] == [self.companyProducts[j] productID]) {
                    [self.companyProducts removeObjectAtIndex:j];
                    break;
                }
            }
        }
        [self.arrayOfSelectedCells removeAllObjects];
        NSLog(@"%zd",self.indexPath);
        [self.dao deletProd:(int)self.indexPath forCompanyIndex:self.compIndexPath];
        [self.collectionView reloadData];
        [self.collectionView reloadInputViews];
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

-(void)delete:(id)sender {
    NSIndexPath *indexPath = nil;
    
    [self showDeleteCancelActionSheet:indexPath];
    [self.collectionView reloadData];
}

-(void)add:(id)sender {
    NSLog(@"Add button pressed");
    addProductsViewController *addProdView = [[addProductsViewController alloc] initWithNibName:@"addProductsViewController" bundle:nil];
    addProdView.company = self.company;
    addProdView.myindexPath = self.compIndexPath;
    [self.navigationController pushViewController:addProdView animated:YES];
    [addProdView release];
}
#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectCells.title isEqualToString:@"Cancel"]) {
        NSNumber *productID = [self.companyProducts[indexPath.row]productID];
        [self.arrayOfSelectedCells addObject:productID];
        NSLog(@"%@",_arrayOfSelectedCells);
    }else{
        UrlViewController *urlView = [[UrlViewController alloc] initWithNibName:@"UrlViewController" bundle:nil];
        Product *prod = [self.companyProducts objectAtIndex:indexPath.row];
        [urlView setURL:[NSString stringWithFormat:@"%@",prod.productURL]];
        [self.navigationController pushViewController:urlView animated:YES];
        [urlView release];
    }
    self.indexPath = (NSInteger*)indexPath.row;
    NSLog(@"%zd",self.indexPath);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *productID = [self.companyProducts[indexPath.row]productID];
    if ([self.arrayOfSelectedCells containsObject:productID]) {
        [self.arrayOfSelectedCells removeObject:productID];
    }
    return  YES;
}

@end
