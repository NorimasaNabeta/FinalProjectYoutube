//
//  FinalProjectsYouTubeViewController.m
//  FinalProjectsViewer
//
//  Created by Norimasa Nabeta on 2012/08/31.
//  Copyright (c) 2012 Norimasa Nabeta. All rights reserved.
//

#import "FinalProjectsYouTubeViewController.h"

@interface FinalProjectsYouTubeViewController ()
@end

@implementation FinalProjectsYouTubeViewController
@synthesize webView;
@synthesize student=_student;

//
// http://stackoverflow.com/questions/6283079/iphone-uiwebview-embed-youtube-video
//
- (void) reloadContent
{
    NSString *embedHTML2 = @"<html><head><style type=\"text/css\">\
    body { background-color: transparent;color: transparent;}</style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"http://www.youtube.com/watch?v=%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString *youtube=[self.student objectForKey:@"youtube"];

    // NSLog(@"width=%g height=%g", self.view.frame.size.width, self.view.frame.size.height);
    NSString *html = [NSString stringWithFormat:embedHTML2, youtube,
                      self.view.frame.size.width, self.view.frame.size.height];
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://youtube.com"]];
}

- (void) setStudent:(NSDictionary *)student
{
    if (_student != student) {
        _student=student;
    }
    self.title = [_student objectForKey:@"name"];
    [self reloadContent];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self reloadContent];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
