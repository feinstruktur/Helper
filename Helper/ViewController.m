//
//  ViewController.m
//  Helper
//
//  Created by Sven A. Schmidt on 07/08/2013.
//  Copyright (c) 2013 Sven A. Schmidt. All rights reserved.
//

#import "ViewController.h"

#import "HelpOverlayView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIColor *mainColor = [UIColor whiteColor];
    
    HelpOverlayView *v = [[HelpOverlayView alloc] initWithFrame:CGRectMake(40, 40, 250, 350)];
    v.mainColor = mainColor;
    UITextView *t = [UITextView new];
    t.text = @"This is a longish text description of what's happening in this box.\n\n"
    "Throwing in a line break as well to get some more text in the box. See if this helps.";
    t.backgroundColor = [UIColor clearColor];
    t.textColor = mainColor;
    t.font = [UIFont systemFontOfSize:14];
    t.userInteractionEnabled = NO;
    v.descriptionView = t;
    [self.view addSubview:v];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
