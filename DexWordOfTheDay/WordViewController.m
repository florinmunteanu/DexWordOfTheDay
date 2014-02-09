//
//  WordViewController.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 10/12/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "WordViewController.h"
#import "Word.h"

@interface WordViewController ()

@end

@implementation WordViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"title == %@" argumentArray:@[self.wordTitle]];
 
    NSError* error = nil;
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
    else
    {
        if (result && result.count == 1)
        {
            //Word* word = result[0];
            //self.wordDefinitionTextView.text = word.definition;
            //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dexonline.ro/cuvantul-zilei/2013/12/16"]]];
            NSString* html = [result[0] htmlDefinition];
            [self.webView loadHTMLString:html baseURL:nil];
        }
    }
}

@end
