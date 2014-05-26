
#import "WordsViewController.h"
#import "Word.h"
#import "WordsManager.h"
#import "DexWordViewController.h"
#import "Views/SettingsViewController.h"
#import <TSMessage.h>
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

@interface WordsViewController ()

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UIImageView* blurredImageView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIWebView* definitionWebView;

@end

@implementation WordsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.managedObjectContext == nil)
    {
        [self initManagedDocumentAndRefresh];
    }
    
    [self createUI];
}

- (void)createUI
{
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //UIImage* background = [UIImage imageNamed:@"theme.jpg"];
    
    //self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    //self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    //[self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    //[self.blurredImageView setImageToBlur:background blurRadius:1 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    CGFloat inset = 20;
    
    CGRect settingsFrame = CGRectMake(5,     // x
                                      inset, // y
                                      50,    // width
                                      44);   // height
    
    CGRect downloadFrame = CGRectMake(headerFrame.size.width - 55,  // x
                                     inset,  // y
                                     50,     // width
                                     44);    // height
    
    CGRect definitionFrame = CGRectMake(0,                                     // x
                                        inset + downloadFrame.size.height + 5, // y
                                        headerFrame.size.width,               // width
                                        self.screenHeight - settingsFrame.size.height - inset); // height
    
    UIView* header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    // Definition web view
    self.definitionWebView = [[UIWebView alloc] initWithFrame:definitionFrame];
    [header addSubview:self.definitionWebView];
    
    UIButton* settingsButton = [[UIButton alloc] initWithFrame:settingsFrame];
    [settingsButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    
    UIButton* refreshButton = [[UIButton alloc] initWithFrame:downloadFrame];
    [refreshButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshWords) forControlEvents:UIControlEventTouchUpInside];
    
    [header addSubview:settingsButton];
    [header addSubview:refreshButton];
}

- (void)displayLastWord
{
    Word* lastWord = [[WordsManager sharedInstance] lastWord];
    if (lastWord)
    {
        [self.definitionWebView loadHTMLString:lastWord.htmlDefinition baseURL:nil];
    }
}

- (void)openSettings
{
    SettingsViewController* svc = [[SettingsViewController alloc] init];
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)refreshWords
{
    void (^completionBlock)(BOOL) = ^(BOOL success)
                                    {
                                        if (success)
                                        {
                                            [TSMessage showNotificationWithTitle:@"Succes"
                                                                        subtitle:@"List a fost actualizata."
                                                                            type:TSMessageNotificationTypeSuccess];
                                        }
                                        else
                                        {
                                            [TSMessage showNotificationWithTitle:@"Atentie"
                                                                        subtitle:@"Posibil sa fi aparut o problema la actualizarea listei."
                                                                            type:TSMessageNotificationTypeWarning];
                                        }
                                        [self displayLastWord];
                                    };
    [[WordsManager sharedInstance] refreshInBackgroundIfNecessary:completionBlock];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[WordsManager sharedInstance] numberOfWords];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM"];
    
    Word* word = [[WordsManager sharedInstance] wordAtIndexPath:indexPath];

    cell.textLabel.text = word.title;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:word.day];
    
    [self delayContentTouches:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Word* word = [[WordsManager sharedInstance] wordAtIndexPath:indexPath];
    
    DexWordViewController* wordViewController = [[DexWordViewController alloc] init];
    wordViewController.word = word;

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
        
        [self displayLastWord];
        [[WordsManager sharedInstance] refreshInBackgroundIfNecessary:nil];
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
