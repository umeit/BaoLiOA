//
//  BLAttachPreviewViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-12-9.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLAttachPreviewViewController.h"

@interface BLAttachPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BLAttachPreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSURL *fileURL = [NSURL fileURLWithPath:self.filePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
