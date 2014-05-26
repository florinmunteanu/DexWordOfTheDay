
#import "SettingsViewController.h"
#import "WordsManager.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Setting";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self setIcon8Cell:cell];
    }
    //else if (indexPath.section == 0 && indexPath.row == 1)
    //{
    //    [self setDeleteDataCell:cell];
    //}
    
    [self delayContentTouches:cell];
    
    return cell;
}

- (void)setIcon8Cell:(UITableViewCell *)cell
{
    cell.textLabel.text = @"Iconite furnizate de icon8";
    
    UIButton* icon8Link = [UIButton buttonWithType:UIButtonTypeSystem];
    icon8Link.frame = CGRectMake(0.0f, 0.0f, 60.0f, 25.0f);
    [icon8Link setTitle:@"Link"
               forState:UIControlStateNormal];
    [icon8Link addTarget:self
                  action:@selector(openLinkToIcon8)
        forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = icon8Link;
}

- (void)setDeleteDataCell:(UITableViewCell *)cell
{
    UIButton* deleteAllWordsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteAllWordsButton.frame = cell.bounds;
    deleteAllWordsButton.backgroundColor = [UIColor redColor];
    
    [deleteAllWordsButton setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateNormal];
    [deleteAllWordsButton setTitle:@"Sterge toate datele"
                          forState:UIControlStateNormal];
    [deleteAllWordsButton addTarget:self
                             action:@selector(deleteAllData)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:deleteAllWordsButton];
}

- (void)deleteAllData
{
    [[WordsManager sharedInstance] deleteAllWords];
}

- (void)openLinkToIcon8
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://icons8.com"]];
}

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
