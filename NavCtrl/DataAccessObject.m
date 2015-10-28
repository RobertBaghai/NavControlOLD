//
//  DataAccessObject.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/7/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "DataAccessObject.h"


@implementation DataAccessObject
{
    sqlite3 *companyListDB;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t cp_singleton_once_token;
    static DataAccessObject *sharedInstance;
    dispatch_once(&cp_singleton_once_token, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(int)fetchPosition{
    NSString *maxPos = nil;
    int max_pos = 0;
    NSString *selectDB = [NSString stringWithFormat:@"select MAX(c_position) from Company"];
    NSLog(@"%@",selectDB);
    sqlite3_stmt *statement;
    [maxPos retain];
    const char *query_sql = [selectDB UTF8String];
    if (sqlite3_prepare(companyListDB, query_sql, -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement)== SQLITE_ROW)
        {
            const unsigned char *str = sqlite3_column_text(statement, 0);
            NSLog(@"%s",str);
            if (str == NULL) {
                max_pos = 1;
            }else{
                maxPos = [[[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)] autorelease];
                max_pos = [maxPos intValue]+1;
            }
        }
    }
    
    
    return max_pos;
}

-(void)findOrCopyDB{
    self.companyList = [[[NSMutableArray alloc] init] autorelease];
    [self.companyList removeAllObjects];
    
    NSString *dbName = @"NavControllerDataBase.db";
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    self.dbPath =[[[NSString alloc] initWithString:[docPath stringByAppendingPathComponent:dbName]] autorelease];
    NSLog(@"%@",self.dbPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    sqlite3_stmt *statement;
    sqlite3_stmt *statement_products;
    
    // Checking if database exists in Doc Directory
    if (![fileManager fileExistsAtPath:self.dbPath]) {
        //if database does not exist...copy databased from bundle to Doc Directory
        NSString *appDBBundlePath = [[NSBundle mainBundle] pathForResource:@"NavControllerDataBase" ofType:@"db"];
        NSLog(@"App Bundle Path - %@",appDBBundlePath);
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:appDBBundlePath toPath:self.dbPath error:&error];
        if(error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
            UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    //then open the database and read from it
    const char *dbPath = [self.dbPath UTF8String];
    
    if(sqlite3_open(dbPath, &companyListDB) == SQLITE_OK)
    {
        Company *comp = nil;
        Product *prod = nil;
        NSLog(@"Database opened successfully!!");
        NSString *selectDB = [NSString stringWithFormat:@"SELECT * FROM Company ORDER BY c_position"];
        const char *query_sql = [selectDB UTF8String];
        if (sqlite3_prepare(companyListDB, query_sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement)== SQLITE_ROW)
            {
                NSString *comp_id = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 0)];
                NSString *name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 1)];
                NSString *logo = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *stock_code = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                comp = [[Company alloc] init];
                comp.companyName = name;
                comp.companyLogo = logo;
                comp.stockCode = stock_code;
                comp.companyID = comp_id;
                comp.products = [[[NSMutableArray alloc] init] autorelease];
                NSLog(@"Company ID - %d",[comp_id intValue]);
                //Fetching Products for each Company
                int c_id = [comp_id intValue];
                NSString *selectProducts = [NSString stringWithFormat:@"SELECT * FROM Product WHERE company_id = %d ORDER BY p_position",c_id];
                const char *query_sql_Two = [selectProducts UTF8String];
                
                if (sqlite3_prepare(companyListDB, query_sql_Two, -1, &statement_products, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement_products)== SQLITE_ROW)
                    {
                        NSString *prod_id = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement_products, 0)];
                        NSString *p_name = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement_products, 1)];
                        NSString *p_logo = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement_products, 2)];
                        NSString *p_url = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement_products, 3)];
                        
                        prod = [[Product alloc] init];
                        prod.productName = p_name;
                        prod.productLogo = p_logo;
                        prod.productURL = p_url;
                        prod.productID = prod_id;
                        [comp.products addObject:prod];
                        
                        [prod release];
                        [prod_id release];
                        [p_name release];
                        [p_logo release];
                        [p_url release];
                    }
                }
                [self.companyList addObject:comp];
                [comp release];
                [comp_id release];
                [name release];
                [logo release];
                [stock_code release];
            }
            NSLog(@" %@", self.companyList);
        }
        sqlite3_close(companyListDB);
    }
    for (int i = 0; i<[self.companyList count]; i++) {
        NSLog(@"Products for Company = %@ \nProducts = %@\n\n",[[self.companyList objectAtIndex:i] companyName],[[self.companyList objectAtIndex:i] products]);
    }
//    [_dbPath release];
}


-(void)deleteData:(NSString *)deleteQuery
{
    char *error;
    if (sqlite3_exec(companyListDB, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"Your data has been deleted");
    }
}

-(void)addData:(NSString *)addQuery
{
    char *error;
    if(sqlite3_exec(companyListDB, [addQuery UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"Data added");
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Add" message:@"Your data has been added" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

-(void)moveData:(NSString *)moveQuery
{
    char *error;
    if(sqlite3_exec(companyListDB, [moveQuery UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"UPDATE after Moving ..");
    }
}

-(void)editData:(NSString *)editQuery
{
    char *error;
    if(sqlite3_exec(companyListDB, [editQuery UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"Data Edited");
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Edit" message:@"Your data has been edited" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

//-(void)getCompaniesAndProducts{
//
//    Company *apple =[[Company alloc] init];
//    apple.companyName = @"Apple mobile devices";
//    apple.companyLogo = @"apple.png";
//    apple.stockCode = @"AAPL";
//
//    Product *iPad =[[Product alloc] init];
//    iPad.productName = @"iPad";
//    iPad.productLogo = @"ipad.png";
//    iPad.productURL = @"https://www.apple.com/ipad/";
//
//    Product *iPod =[[Product alloc] init];
//    iPod.productName = @"iPod Touch";
//    iPod.productLogo = @"ipodtouch.png";
//    iPod.productURL = @"https://www.apple.com/ipod-touch/";
//
//    Product *iPhone =[[Product alloc] init];
//    iPhone.productName = @"iPhone";
//    iPhone.productLogo = @"iphone.png";
//    iPhone.productURL = @"http://www.apple.com/iphone/";
//
//
//    apple.products =  [[NSMutableArray alloc] initWithObjects:iPad, iPod, iPhone, nil];
//
//
//    Company *samsung =[[Company alloc] init];
//    samsung.companyName = @"Samsung mobile devices";
//    samsung.companyLogo = @"samsung.png";
//    samsung.stockCode = @"SSUN.DE";
//
//
//    Product *galaxy =[[Product alloc] init];
//    galaxy.productName = @"Galaxy S5";
//    galaxy.productLogo = @"s5.png";
//    galaxy.productURL = @"http://www.samsung.com/global/microsite/galaxys5/features.html";
//
//    Product *note =[[Product alloc] init];
//    note.productName = @"Galaxy Note";
//    note.productLogo = @"note.png";
//    note.productURL = @"https://www.samsung.com/us/mobile/galaxy-note/";
//
//    Product *tab =[[Product alloc] init];
//    tab.productName = @"Galaxy Tab";
//    tab.productLogo = @"tab.png";
//    tab.productURL = @"https://www.samsung.com/us/explore/tab-s2-features-and-specs/?cid=ppc-";
//
//    samsung.products = [[NSMutableArray alloc] initWithObjects:galaxy, note, tab, nil];
//
//
//    Company *htc =[[Company alloc] init];
//    htc.companyName = @"HTC mobile devices";
//    htc.companyLogo = @"htc.png";
//    htc.stockCode= @"GOOG";
//
//
//    Product *htcOne =[[Product alloc] init];
//    htcOne.productName = @"HTC One M9";
//    htcOne.productLogo = @"htcone.png";
//    htcOne.productURL = @"https://www.htc.com/us/smartphones/htc-one-m9/";
//
//
//    Product *nexus =[[Product alloc] init];
//    nexus.productName = @"Google Nexus";
//    nexus.productLogo = @"nexus.png";
//    nexus.productURL = @"https://store.google.com/product/nexus_6p?utm_source=en-ha-na-sem&utm_medium=text&utm_content=skws&utm_campaign=nexus6p&gclid=CjwKEAjws7OwBRCn2Ome5tPP8gESJAAfopWsF1f3gGR_3ME1Ixcmv8sq_vO9pzHjJwS6Sf_ztXnn_hoCiRDw_wcB";
//
//    Product *camera =[[Product alloc] init];
//    camera.productName = @"RE Camera";
//    camera.productLogo = @"recamera.png";
//    camera.productURL = @"https://www.htc.com/us/re/re-camera/";
//
//    htc.products = [[NSMutableArray alloc] initWithObjects: htcOne, nexus, camera, nil];
//
//
//    Company *lg = [[Company alloc] init];
//    lg.companyName = @"LG mobile devices";
//    lg.companyLogo = @"lg.png";
//    lg.stockCode = @"LGLG.DE";
//
//
//    Product *g4 =[[Product alloc] init];
//    g4.productName = @"LG G4";
//    g4.productLogo = @"lgg4.png";
//    g4.productURL = @"https://www.lg.com/us/mobile-phones/g4";
//
//    Product *lgTab =[[Product alloc] init];
//    lgTab.productName = @"LG Tablet";
//    lgTab.productLogo = @"lgtablet.png";
//    lgTab.productURL = @"https://www.lg.com/us/tablets";
//
//    Product *watch =[[Product alloc] init];
//    watch.productName = @"LG Watch";
//    watch.productLogo = @"lgwatch.png";
//    watch.productURL = @"https://www.lg.com/us/smart-watches/lg-W150-lg-watch-urbane";
//
//    lg.products = [[NSMutableArray alloc] initWithObjects: g4, lgTab, watch ,nil];
//
//
//    self.companyList = [NSMutableArray arrayWithArray:@[apple, samsung, htc, lg]];

//    [self findOrCopyDB];
//}

-(void)updateStockPrices {
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
