
#import "WordsViewController.h"
#import "Word.h"
#import "WordsManager.h"
#import "WordsCDTVC.h"
#import "WordsVC.h"
#import "DexWordViewController.h"
#import "Views/SettingsViewController.h"
#import <TSMessage.h>
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

@interface WordsViewController ()

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

//@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UIImageView* blurredImageView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation WordsViewController

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
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor redColor];
    
    if (self.managedObjectContext == nil)
    {
        [self initManagedDocumentAndRefresh];
    }
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIImage* background = [UIImage imageNamed:@"theme.jpg"];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:1 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    //[self.tableView beginUpdates];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    CGFloat inset = 20;
    
    CGFloat definitionHeight = 110;
    CGFloat dateHeight = 40;
    CGFloat wordHeight = 30;
    
    CGRect dateFrame = CGRectMake(inset,                                // x
                                  headerFrame.size.height - dateHeight, // y
                                  headerFrame.size.width - (2 * inset), // width
                                  dateHeight);                          // height
    
    CGRect definitionFrame = CGRectMake(inset,                                                      // x
                                        headerFrame.size.height - (definitionHeight + dateHeight),  // y
                                        headerFrame.size.width - (2 * inset),                       // width
                                        definitionHeight);                                          // height
    CGRect wordFrame = CGRectMake(inset,                                 // x
                                  definitionFrame.origin.y - wordHeight, // y
                                  headerFrame.size.width - (2 * inset),  // width
                                  wordHeight);                           // height
    
    CGRect settingsFrame = CGRectMake(inset, // x
                                      inset, // y
                                      100,   // width
                                      44);   // height
    
    UIView* header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    // Word label
    UILabel* wordLabel = [[UILabel alloc] initWithFrame:wordFrame];
    wordLabel.backgroundColor = [UIColor clearColor];
    wordLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    wordLabel.textColor = [UIColor redColor];
    wordLabel.text = @"word";
    [header addSubview:wordLabel];
    
    // Definition label
    UILabel* definitionLabel = [[UILabel alloc] initWithFrame:definitionFrame];
    definitionLabel.backgroundColor = [UIColor clearColor];
    definitionLabel.textColor = [UIColor redColor];
    definitionLabel.numberOfLines = 0; // A value of 0 means no limit
    definitionLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
    definitionLabel.text = @"definition";
    [header addSubview:definitionLabel];
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor redColor];
    dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    dateLabel.text = @"date";
    [header addSubview:dateLabel];
    
    UIButton* settingsButton = [[UIButton alloc] initWithFrame:settingsFrame];
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    
    
    [header addSubview:settingsButton];
}

- (void)openSettings
{
   WordsVC* svc = [[WordsVC alloc] init];
    //[svc refreshData];
    //svc.managedObjectContext = self.managedObjectContext;
   [self presentViewController:svc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//[[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[WordsManager sharedInstance] numberOfWords];//[[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    //cell.textLabel.textColor = [UIColor blackColor];
    //cell.detailTextLabel.textColor = [UIColor blackColor];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM"];
    
    Word* word = [[WordsManager sharedInstance] wordAtIndexPath:indexPath];
    //Word *word = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = word.title;//@"Test";//word.title;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:word.day];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.acc
    
    //UIButton* deleteAllSongsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //deleteAllSongsButton.frame = cell.bounds;
    //deleteAllSongsButton.backgroundColor = [UIColor redColor];
    
    //[deleteAllSongsButton setTitleColor:[UIColor whiteColor]
    //                           forState:UIControlStateNormal];
    //[deleteAllSongsButton setTitle:@"Delete all data"
    //                      forState:UIControlStateNormal];
    //[deleteAllSongsButton addTarget:self
    //                         action:@selector(deleteAllData)
    //               forControlEvents:UIControlEventTouchUpInside];
    
    //[cell.contentView addSubview:deleteAllSongsButton];
    
    //[autoPlaySwitch addTarget:self
    //                   action:@selector(setAutoStart:)
    //         forControlEvents:UIControlEventValueChanged];
    
    [self delayContentTouches:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Word* word = [[WordsManager sharedInstance] wordAtIndexPath:indexPath];
    
    DexWordViewController* wordViewController = [[DexWordViewController alloc] init];
    wordViewController.word = word;
    //WordsVC* wordViewController = [[WordsVC alloc] init];
    [self presentViewController:wordViewController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    
    CGFloat percent = MIN(position / height, 1.0);
    
    self.blurredImageView.alpha = percent;
}

#pragma mark - Core Data

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
                  //[self refresh];
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

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        [WordsManager sharedInstance].managedObjectContext = managedObjectContext;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
}

#pragma mark - Delay content touches

- (void)delayContentTouches:(UITableViewCell *)cell
{
    //http://stackoverflow.com/questions/19256996/uibutton-not-showing-highlight-on-tap-in-ios7
    
    // https://developer.apple.com/library/ios/documentation/uikit/reference/uiscrollview_class/Reference/UIScrollView.html#//apple_ref/occ/instp/UIScrollView/delaysContentTouches
    // delaysContentTouches
    // A Boolean value that determines whether the scroll view delays the handling of touch-down gestures.
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches = NO;
            break;
        }
    }
}

@end
