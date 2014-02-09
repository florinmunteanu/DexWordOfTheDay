//
//  WordViewController.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 10/12/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) NSString* wordTitle;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
