
#import "DexWordViewController.h"

@interface DexWordViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *wordWebView;

@end

@implementation DexWordViewController

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
    
    [self.wordWebView loadHTMLString:self.word.htmlDefinition baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
