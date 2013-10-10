//
//  WebViewController.m
//  MustacheBash
//
//  Created by Konstantin Sokolinskyi on 2/23/12.
//  Copyright (c) 2012 Bright Newt. All rights reserved.
//

#import "WebViewController.h"


@interface WebViewController ()

@property (strong, nonatomic) UIWebView* webView;
@property (strong, nonatomic) UIToolbar *bottomToolbar;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

- (void)createBottomToolbar;
- (void)loadPageForUrl: (NSURL*)url;

- (void)back: (id)sender;
- (void)refresh: (id)sender;
- (void)stop: (id)sender;
- (void)forward: (id)sender;
- (void)openSafari: (id)sender;


@end


@implementation WebViewController


@synthesize url = _url;
@synthesize webView = _webView;
@synthesize bottomToolbar = _bottomToolbar;
@synthesize delegate = _delegate;
@synthesize spinner = _spinner;


- (void)loadView
{
	[super loadView];
	self.view = [[UIView alloc] initWithFrame: self.navigationController.view.frame];
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                  target: self.delegate
                                                  action: @selector(cancelWebViewController:)];
    [self createBottomToolbar];
    
    CGRect webViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.bottomToolbar.frame.size.height);
	self.webView = [[UIWebView alloc] initWithFrame: webViewFrame];
	self.webView.delegate = self;
	self.webView.scalesPageToFit = YES;
	self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	[self.view addSubview: self.webView];
    
    [self loadPageForUrl: self.url];
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    debug(@"WebView: did unload");
    
    self.webView = nil;
    self.bottomToolbar = nil;
    self.spinner = nil;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)loadPageForUrl: (NSURL*)url
{
    debug(@"load url: %@", url);
	[self.webView loadRequest: [NSURLRequest requestWithURL: self.url]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (UIInterfaceOrientationPortrait == interfaceOrientation);
    } else {
        return YES;
    }
}


- (void)createBottomToolbar
{
    CGFloat height = 44;
    
    self.bottomToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake( 0,
                                                                      self.view.frame.size.height - 1 * height,
                                                                      self.view.frame.size.width,
                                                                      height)];
    [self.view addSubview: self.bottomToolbar];
    self.bottomToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRewind 
                                                                                target: self
                                                                                action: @selector(back:)];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh
                                                                                   target: self
                                                                                   action: @selector(refresh:)];
    
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemStop 
                                                                                target: self
                                                                                action: @selector(stop:)];
    
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward 
                                                                                   target: self
                                                                                   action: @selector(forward:)];
    
    UIBarButtonItem *safariButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction 
                                                                                  target: self
                                                                                  action: @selector(openSafari:)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                            target: nil
                                                                            action: nil];
    
    [self.bottomToolbar setItems: [NSArray arrayWithObjects: spacer, backButton, spacer, refreshButton, spacer, safariButton, spacer, stopButton, spacer, forwardButton, spacer, nil]
                        animated: YES];
}


- (void)back: (id)sender
{
    [self.webView goBack];
}


- (void)refresh: (id)sender
{
    [self.webView reload];
}


- (void)stop: (id)sender
{
    [self.webView stopLoading];
    [self.spinner stopAnimating];
}


- (void)forward: (id)sender
{
    [self.webView goForward];
}


- (void)openSafari: (id)sender
{
    [[UIApplication sharedApplication] openURL: self.url];
}


#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad: (UIWebView*)webView
{
    debug(@"did START load");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // CREATE spinner
    if ( nil == self.spinner ) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 30, 30)];
        self.spinner.center = webView.center;
        [self.spinner setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
        [self.view addSubview: self.spinner];
    }
    
    [self.spinner startAnimating];
}


- (void)webViewDidFinishLoad: (UIWebView*)webView
{
    debug(@"did FINISH load");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.spinner stopAnimating];
}


- (void)webView: (UIWebView*)webView didFailLoadWithError: (NSError*)error
{
    debug(@"did FAIL load");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ( NSURLErrorDomain == [error domain] && -999 != [error code] ) {
        NSString *title;
        NSString *message;
        
        if ( [error domain] == NSURLErrorDomain ) {
            title = NSLocalizedString(@"Network error", @"Web-view error - alert title");
            
            if ([error code] == NSURLErrorNotConnectedToInternet)
                message = NSLocalizedString(@"Looks like there is no internet access. Please check your internet connection and mobile settings or try later", "Web-view error - alert text");
            else
                message = NSLocalizedString(@"Failed connecting to the server. Please try later", "Web-view error - alert text");
        }
        else {	
            title   = NSLocalizedString(@"Internal error", @"Web-view error - alert title");
            message = NSLocalizedString(@"Something unexpected has happened", @"Web-view error - alert text");
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                        message: message
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString( @"Dismiss", @"")
                                              otherButtonTitles: nil];
        [alert show];
    }
}


- (BOOL)webView: (UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType
{
    debug(@"should start load: %@", request);
	return YES;
}


@end
