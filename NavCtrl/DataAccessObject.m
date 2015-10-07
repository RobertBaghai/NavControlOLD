//
//  DataAccessObject.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/7/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "DataAccessObject.h"

@implementation DataAccessObject

-(void)getCompaniesAndProducts{

Company *apple =[[Company alloc] init];
apple.companyName = @"Apple mobile devices";
apple.companyLogo = @"apple.png";

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


apple.products =  [[NSMutableArray alloc] initWithObjects:iPad,iPod, iPhone, nil];


Company *samsung =[[Company alloc] init];
samsung.companyName = @"Samsung mobile devices";
samsung.companyLogo = @"samsung.png";


Product *galaxy =[[Product alloc] init];
galaxy.productName = @"Galaxy S5";
galaxy.productLogo = @"s5.png";
galaxy.productURL = @"https://www.cricketwireless.com/cell-phones/smartphones/samsung-galaxy-s5.html";

Product *note =[[Product alloc] init];
note.productName = @"Galaxy Note";
note.productLogo = @"note.png";
note.productURL = @"https://www.samsung.com/us/mobile/galaxy-note/";

Product *tab =[[Product alloc] init];
tab.productName = @"Galaxy Tab";
tab.productLogo = @"tab.png";
tab.productURL = @"https://www.samsung.com/us/explore/tab-s2-features-and-specs/?cid=ppc-";

samsung.products = [[NSMutableArray alloc] initWithObjects:galaxy, note, tab, nil];


Company *htc =[[Company alloc] init];
htc.companyName = @"HTC mobile devices";
htc.companyLogo = @"htc.png";

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

htc.products = [[NSMutableArray alloc] initWithObjects: htcOne, nexus, camera, nil];


Company *lg = [[Company alloc] init];
lg.companyName = @"LG mobile devices";
lg.companyLogo = @"lg.png";

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

lg.products = [[NSMutableArray alloc] initWithObjects: g4, lgTab, watch ,nil];


self.companyList = [NSMutableArray arrayWithArray:@[apple, samsung, htc, lg]];
    
}

@end
