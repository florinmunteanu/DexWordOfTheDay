
#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end
