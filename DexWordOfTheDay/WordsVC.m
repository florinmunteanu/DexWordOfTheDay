//
//  WordsVC.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 15/05/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "WordsVC.h"
#import "WordsManager.h"

@interface WordsVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WordsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.tableView.dataSource = self;
    //self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[WordsManager sharedInstance] numberOfWords];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    Word* word = [[WordsManager sharedInstance] wordAtIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    //NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"dd-MM"];
    
    //Word *word = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = word.title;// @"Test";//word.title;
    cell.detailTextLabel.text = @"AAA";// [dateFormatter stringFromDate:word.day];
    
    return cell;
}

#pragma mark - Close bar button

- (IBAction)closeViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Managed object context

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        [WordsManager sharedInstance].managedObjectContext = managedObjectContext;
    }
}

@end
