//
//  DataAccessObject.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/7/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "DataAccessObject.h"
#import "CoreCompany.h"
#import "CoreProduct.h"

@implementation DataAccessObject
@synthesize model;
+(instancetype)sharedInstance
{
    CoreCompany *c = nil;
    [c companyName];
    static dispatch_once_t cp_singleton_once_token;
    static DataAccessObject *sharedInstance;
    dispatch_once(&cp_singleton_once_token, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSString*) archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
    
    self.dbPath = [documentsDirectory stringByAppendingPathComponent:@"CompAndProd.data"];
    return self.dbPath;
}

-(void)initModelContext
{
    NSManagedObjectModel * m = [NSManagedObjectModel mergedModelFromBundles:nil];
    self.model = m;
    NSPersistentStoreCoordinator *psc =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    
    NSString *path = [self archivePath];
    NSLog(@"%@",path);
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    self.context = [[[NSManagedObjectContext alloc] init] autorelease];
    self.context.undoManager = [[[NSUndoManager alloc] init] autorelease];
    [[self context] setPersistentStoreCoordinator:psc];
    [psc release];
}

-(void)createCompany:(NSString*)company_name withStockCode:(NSString*)stockCode logo:(NSString*)companyLogo productList:(NSMutableArray *)products
{
    CoreCompany *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:[self context]];
    [company setCompanyName:company_name];
    [company setStockCode:stockCode];
    [company setCompanyLogo:companyLogo];
    for (int i =0;i<[products count]; i++) {
        CoreProduct *product  = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:[self context]];
        [product setProductName:[[products objectAtIndex:i] productName]];
        [product setProductURL:[[products objectAtIndex:i] productURL]];
        [product setProductLogo:[[products objectAtIndex:i] productLogo]];
        [company addProdObject:product];
    }
    [self saveChanges];
}

-(void)readOrCreateCoreData
{
    [self initModelContext];
    self.companyList = [[[NSMutableArray alloc] init] autorelease];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"companyName MATCHES '.*'"];
    request.predicate = predicate;
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]
                                    initWithKey:@"companyName" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByName];
    
    NSEntityDescription *entity = [[self.model entitiesByName] objectForKey:@"Company"];
    request.entity = entity;
    
    NSError *error=nil;
    NSArray *fetch = [self.context executeFetchRequest:request error:&error];
    self.result = [[[NSMutableArray alloc]initWithArray:fetch] autorelease];
    NSLog(@"%ld",[self.result count]);
    if([self.result count]==0){
        //Write to Core Data
        [self getCompaniesAndProducts];
        for (int i=0; i<[self.companyList count]; i++){
            [self createCompany:[[self.companyList objectAtIndex:i] companyName]
                  withStockCode:[[self.companyList objectAtIndex:i] stockCode]
                           logo:[[self.companyList objectAtIndex:i] companyLogo]
                    productList:[[self.companyList objectAtIndex:i] products]];
        }
        [self saveChanges];
        NSArray *fetch = [self.context executeFetchRequest:request error:&error];
        self.result = [[[NSMutableArray alloc]initWithArray:fetch] autorelease];
    }else{
        // Read from Core data
        for (int i=0; i<[self.result count]; i++) {
            CoreCompany *tempCoreComp = [self.result objectAtIndex:i];
            Company *tempcomp = [[Company alloc] init];
            tempcomp.companyName = [tempCoreComp companyName];
            tempcomp.companyLogo = [tempCoreComp companyLogo];
            tempcomp.stockCode   = [tempCoreComp stockCode];
            tempcomp.products = [[[NSMutableArray alloc]init] autorelease];
            
            NSSortDescriptor *sortByProdName = [[NSSortDescriptor alloc]
                                                initWithKey:@"productName" ascending:YES];
            NSArray *prods = [tempCoreComp.prod sortedArrayUsingDescriptors:@[sortByProdName]];
            for(CoreProduct *tempCoreProd in prods){
                Product *tempprod = [[Product alloc] init];
                tempprod.productName = [tempCoreProd productName];
                tempprod.productLogo = [tempCoreProd productLogo];
                tempprod.productURL = [tempCoreProd productURL];
                [tempcomp.products addObject:tempprod];
                [tempprod release];
            }
            [self.companyList addObject:tempcomp];
            NSLog(@"CNAME = %@",[[self.companyList objectAtIndex:i] companyName]);
            [sortByProdName release];
            [tempcomp release];
            
        }
        [request release];
//        [sortByName release];
    }
}
-(void)saveChanges
{
    NSError *err = nil;
    BOOL successful = [[self context] save:&err];
    if(!successful)
    {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    NSLog(@"Data Saved");
}

-(void)deleteComp:(long)index
{
    NSManagedObject *comp = (NSManagedObject*)[self.result objectAtIndex:index];
    [self.context deleteObject:comp];
    [self.result removeObject:comp];
    NSError *deleteError = nil;
    if (![comp.managedObjectContext save:&deleteError]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
    }
    [self saveChanges];
}

-(void)updateCompany:(NSString*)company_Name withStockCode:(NSString*)stockCode logo:(NSString*)companyLogo andIndex:(long)index
{
    NSManagedObject *comp = (NSManagedObject *)[self.result objectAtIndex:index];
    [comp setValue:company_Name forKey:@"companyName"];
    [comp setValue:companyLogo forKey:@"companyLogo"];
    [comp setValue:stockCode forKey:@"stockCode"];
    [self saveChanges];
}

-(void)addCompany:(NSString*)company_Name withStockCode:(NSString*)stockCode logo:(NSString*)companyLogo
{
    CoreCompany *addComp = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.context];
    [addComp setValue:company_Name forKey:@"companyName"];
    [addComp setValue:stockCode forKey:@"stockCode"];
    [addComp setValue:companyLogo forKey:@"companyLogo"];
    [self saveChanges];
}

-(void)addProduct:(NSString*)product_Name withLogo:(NSString*)logo andUrl:(NSString*)url toCompanyID:(NSInteger *)index
{
    CoreCompany *tempCoreComp = [self.result objectAtIndex:(int)index];
    //NSLog(@"Company Clicked = %@ Name = %@\n",[tempCoreComp objectID],[tempCoreComp companyName]);
    CoreProduct *addProd = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.context];
    [addProd setValue:product_Name forKey:@"productName"];
    [addProd setValue:logo forKey:@"productLogo"];
    [addProd setValue:url forKey:@"productURL"];
    [tempCoreComp addProdObject:addProd];
    [self saveChanges];
}

-(void)deletProd:(long)index forCompanyIndex:(NSInteger *)companyIndex
{
    CoreCompany *comp = [self.result objectAtIndex:(int)companyIndex];
    NSManagedObject *prod = (NSManagedObject*)[[[comp prod] allObjects]objectAtIndex:(int)index];
    [self.context deleteObject:prod];
    [comp removeProdObject:(CoreProduct*)prod];
    [self saveChanges];
}

-(void)updateProduct:(NSString*)product_Name withLogo:(NSString*)product_logo url:(NSString*)prod_url andIndex:(NSInteger*)index forCompanyIndex:(NSInteger *)companyIndex
{
    CoreCompany *comp = [self.result objectAtIndex:(int)companyIndex];
    NSManagedObject *prod = (NSManagedObject*)[[[comp prod] allObjects]objectAtIndex:(int)index];
    [prod setValue:product_Name forKey:@"productName"];
    [prod setValue:product_logo forKey:@"productLogo"];
    [prod setValue:prod_url forKey:@"productURL"];
    [self saveChanges];
}

//-(void)moveCompanyCell:(NSIndexPath*)fromIndex to:(NSIndexPath*)toIndex{
//    CoreCompany *comp = [self.result objectAtIndex:(int)fromIndex];
//    [comp retain];
//    [self.result removeObjectAtIndex:(int)fromIndex];
//    [self.result insertObject:comp atIndex:(int)toIndex];
//    [comp release];
//    [self saveChanges];
//}

-(void)getCompaniesAndProducts
{
    /*------------------------------------- Hard-coded values here -------------------------------*/
    Company *apple =[[Company alloc] init];
    apple.companyName = @"Apple mobile devices";
    apple.companyLogo = @"apple.png";
    apple.stockCode = @"AAPL";
    Product *iPad =[[Product alloc] init];
    iPad.productName = @"iPad";
    iPad.productLogo = @"ipad.png";
    iPad.productURL = @"https://www.apple.com/ipad/";
    Product *iPod =[[Product alloc] init];
    iPod.productName = @"iPod Touch";
    iPod.productLogo = @"ipodtouch.png";
    iPod.productURL = @"https://www.apple.com/ipod-touch/";
    Product *iPhone =[[Product alloc] init];
    iPhone.productName = @"iPhone";
    iPhone.productLogo = @"iphone.png";
    iPhone.productURL = @"http://www.apple.com/iphone/";
    apple.products =  [[[NSMutableArray alloc] initWithObjects:iPad, iPod, iPhone, nil] autorelease];
    
    Company *samsung =[[Company alloc] init];
    samsung.companyName = @"Samsung mobile devices";
    samsung.companyLogo = @"samsung.png";
    samsung.stockCode = @"SSUN.DE";
    Product *galaxy =[[Product alloc] init];
    galaxy.productName = @"Galaxy S5";
    galaxy.productLogo = @"s5.png";
    galaxy.productURL = @"http://www.samsung.com/global/microsite/galaxys5/features.html";
    Product *note =[[Product alloc] init];
    note.productName = @"Galaxy Note";
    note.productLogo = @"note.png";
    note.productURL = @"https://www.samsung.com/us/mobile/galaxy-note/";
    Product *tab =[[Product alloc] init];
    tab.productName = @"Galaxy Tab";
    tab.productLogo = @"tab.png";
    tab.productURL = @"https://www.samsung.com/us/explore/tab-s2-features-and-specs/?cid=ppc-";
    samsung.products = [[[NSMutableArray alloc] initWithObjects:galaxy, note, tab, nil] autorelease];
    
    Company *htc =[[Company alloc] init];
    htc.companyName = @"HTC mobile devices";
    htc.companyLogo = @"htc.png";
    htc.stockCode= @"GOOG";
    Product *htcOne =[[Product alloc] init];
    htcOne.productName = @"HTC One M9";
    htcOne.productLogo = @"htcone.png";
    htcOne.productURL = @"https://www.htc.com/us/smartphones/htc-one-m9/";
    Product *nexus =[[Product alloc] init];
    nexus.productName = @"Google Nexus";
    nexus.productLogo = @"nexus.png";
    nexus.productURL = @"https://store.google.com/product/nexus_6p?utm_source=en-ha-na-sem&utm_medium=text&utm_content=skws&utm_campaign=nexus6p&gclid=CjwKEAjws7OwBRCn2Ome5tPP8gESJAAfopWsF1f3gGR_3ME1Ixcmv8sq_vO9pzHjJwS6Sf_ztXnn_hoCiRDw_wcB";
    Product *camera =[[Product alloc] init];
    camera.productName = @"RE Camera";
    camera.productLogo = @"recamera.png";
    camera.productURL = @"https://www.htc.com/us/re/re-camera/";
    htc.products = [[[NSMutableArray alloc] initWithObjects: htcOne, nexus, camera, nil] autorelease];
    
    Company *lg = [[Company alloc] init];
    lg.companyName = @"LG mobile devices";
    lg.companyLogo = @"lg.png";
    lg.stockCode = @"LGLG.DE";
    Product *g4 =[[Product alloc] init];
    g4.productName = @"LG G4";
    g4.productLogo = @"lgg4.png";
    g4.productURL = @"https://www.lg.com/us/mobile-phones/g4";
    Product *lgTab =[[Product alloc] init];
    lgTab.productName = @"LG Tablet";
    lgTab.productLogo = @"lgtablet.png";
    lgTab.productURL = @"https://www.lg.com/us/tablets";
    Product *watch =[[Product alloc] init];
    watch.productName = @"LG Watch";
    watch.productLogo = @"lgwatch.png";
    watch.productURL = @"https://www.lg.com/us/smart-watches/lg-W150-lg-watch-urbane";
    lg.products = [[[NSMutableArray alloc] initWithObjects: g4, lgTab, watch ,nil] autorelease];
    
    self.companyList = [NSMutableArray arrayWithArray:@[apple, samsung, htc, lg]];
    [apple release];
    [samsung release];
    [lg release];
    [htc release];
    [iPad release];
    [iPhone release];
    [iPod release];
    [note release];
    [galaxy release];
    [tab release];
    [htcOne release];
    [nexus release];
    [camera release];
    [watch release];
    [g4 release];
    [lgTab release];
}

-(void)updateStockPrices
{
    for (int i = 0; i < self.companyList.count; i++) {
        [self.companyList[i] setStockPrice:self.stockPrices[i]];
    }
}

-(void)dealloc
{
    [_companyList release];
    [_stockPrices release];
    [_dbPath release];
    [super dealloc];
}

@end
