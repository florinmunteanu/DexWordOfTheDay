//
//  WordsCDTVC.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 9/3/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "WordsCDTVC.h"
#import "RssParser.h"
#import "Word.h"
#import "Word+Dex.h"
#import "WordViewController.h"
#import <SystemConfiguration/SCNetworkReachability.h>

@interface WordsCDTVC ()

@end

@implementation WordsCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.managedObjectContext == nil)
    {
        [self initManagedDocumentAndRefresh];
    }
}

- (void)initManagedDocumentAndRefresh
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"WordsDocument"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]] == NO)
    {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success){
              if (success == YES)
              {
                  self.managedObjectContext = document.managedObjectContext;
                  [self refreshData];
              }
          }];
    }
    else if (document.documentState == UIDocumentStateClosed)
    {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success == YES)
            {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    }
    else
    {
        self.managedObjectContext = document.managedObjectContext;
    }
}

- (void)refreshData
{
    //[self displayWarning:@"Atentie"];
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("RSS Fetch", NULL);
    dispatch_async(fetchQ, ^{
                                NSError *error = nil;
                                NSURL *rssUrl = [[NSURL alloc] initWithString:@"http://dexonline.ro/rss/cuvantul-zilei"];
                                NSString *content = [[NSString alloc] initWithContentsOfURL:rssUrl encoding:NSUTF8StringEncoding error:&error];
        
                                if (error == nil)
                                {
                                   RssParser* parser = [[RssParser alloc] init];
                                   NSArray* rssWords = [parser parseContent:content];
                                   [self saveRssWordsInDatabase:rssWords];
                                }
                                else
                                {
                                    
                                }
                            });
}

- (BOOL)checkInternetConnectivity
{
    //NSURL *url = [[NSURL alloc] initWithString:@"www.google.com"];
    //NSString *host = [url host];
    //SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
    return TRUE;
}

- (void)displayWarning:(NSString *)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

- (void)saveRssWordsInDatabase:(NSArray *)rssWords
{
    [self.managedObjectContext performBlock:
        ^{
            for (RssWord *rssWord in rssWords)
            {
                [Word fromRssWord:rssWord inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(),
                      ^{
                          [self.refreshControl endRefreshing];
                       });
         }
    ];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:NO]];
        request.predicate = nil; // all words
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    }
    else
    {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Word"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"dd-MM"];
    
    Word *word = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = word.title;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:word.day];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowWord"])
    {
        if ([segue.destinationViewController isKindOfClass:[WordViewController class]])
        {
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
            
            WordViewController* wvc = (WordViewController *)segue.destinationViewController;
            wvc.managedObjectContext = self.managedObjectContext;
            wvc.wordTitle = cell.textLabel.text;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
