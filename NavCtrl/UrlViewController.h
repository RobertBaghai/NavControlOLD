//
//  UrlViewController.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/2/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
#import "ChildViewController.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface UrlViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIView *UrlView;


@property (retain, nonatomic) IBOutlet UIWebView *webView;


-(void)setURL:(NSString *)url;

@property (retain, nonatomic) NSURL *myURL;
@property (retain,nonatomic) WKWebView *wkWeb;


@end
