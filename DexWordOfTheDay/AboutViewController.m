//
//  AboutViewController.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 07/12/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)navigateToIcon8Url:(id)sender
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://icons8.com"]];
}

@end
