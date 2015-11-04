//
//  UrlViewController.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/2/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "UrlViewController.h"

@interface UrlViewController ()

@end

@implementation UrlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *req = [NSURLRequest requestWithURL:self.myURL];
    _wkWeb = [[[WKWebView alloc] initWithFrame:self.view.frame]autorelease];
    [_wkWeb loadRequest:req];
    _wkWeb.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                              self.view.frame.size.width, self.view.frame.size.height);
    self.view = _wkWeb;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setURL:(NSString *)url
{
    self.myURL = [NSURL URLWithString:url];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)dealloc
{
    [_myURL release];
    [super dealloc];
}

@end
