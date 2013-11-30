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

@interface WordsCDTVC ()

@end

@implementation WordsCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
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
                  [self refresh];
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

- (IBAction)refresh
{
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
