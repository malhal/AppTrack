//
//  MasterViewController.m
//  AppTrackClient
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <AppUsageKit/AppUsageKit.h>


#define PREFIX MH
#define PASTER(x,y) x ## $ ## y
#define EVALUATOR(x,y) PASTER(x,y)

#ifdef PREFIX
#define ADD_PREFIX(name) EVALUATOR(PREFIX, name)
#else
#define ADD_PREFIX(name) name
#endif

@interface ADD_PREFIX(ATMalc) : NSObject

#define PREFIX_test ADD_PREFIX(test)
-(void)PREFIX_test;

@end

@implementation ADD_PREFIX(ATMalc)

-(void)PREFIX_test;{
    
    NSLog(@"Test");
}

@end

@interface MasterViewController ()

@property (nonatomic) NSMutableArray<AUKObject*> *objects;
@property AUKStore* store;



@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    //self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.store = [[AUKStore alloc] init];
    
    [self reload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    //AT$MH_Malc
    ADD_PREFIX(ATMalc)* i = [[ADD_PREFIX(ATMalc) alloc] init];
    [i PREFIX_test];
}

-(NSMutableArray*)objects{
    if(!_objects){
        _objects = [NSMutableArray array];
    }
    return _objects;
}

-(void)reload{
    NSPredicate* predicate; // only get new data.
   
    AUKUsage* firstObject = (AUKUsage*)self.objects.firstObject;
    if(firstObject){
        predicate = [NSPredicate predicateWithFormat:@"startDate > %@", firstObject.startDate];
    }
    AUKObjectType* objectType = [AUKObjectType objectTypeForIdentifier:AUKObjectTypeIdentifierUsage];
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];

// Uncomment for Lifecycle, and comment above code, also edit table cell code.
/*
    ATLifecycle* firstObject = (ATLifecycle*)self.objects.firstObject;
    if(firstObject){
        predicate = [NSPredicate predicateWithFormat:@"date > %@", firstObject.date];
    }
    AUKObjectType* objectType = [AUKObjectType objectTypeForIdentifier:AUKObjectTypeIdentifierLifecycle];
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
*/
    
    AUKQuery* query = [[AUKQuery alloc] initWithObjectType:objectType predicate:predicate limit:AUKObjectQueryNoLimit sortDescriptors:@[sort] resultsHandler:^(AUKQuery * _Nonnull query, NSArray<__kindof AUKObject *> * _Nullable results, NSError * _Nullable error) {
        if(error){
            NSLog(@"error %@", error);
            return;
        }
        NSLog(@"%ld results", (unsigned long) results.count);
        dispatch_async(dispatch_get_main_queue(), ^{

            NSMutableArray *indexPaths = [NSMutableArray array];
            for (int i = 0; i < results.count; i++){
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                
                //NSLog(@"%@", results[i]);
                
            }
            [self.objects insertObjects:results atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, results.count)]];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }];
    [self.store executeQuery:query];
    
    // demo query of apps
    //[self queryApps];
}

-(void)queryApps{
    AUKObjectType* appObjectType = [AUKObjectType objectTypeForIdentifier:AUKObjectTypeIdentifierApp];
    AUKQuery* query = [[AUKQuery alloc] initWithObjectType:appObjectType predicate:nil limit:AUKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(AUKQuery * _Nonnull query, NSArray<__kindof AUKObject *> * _Nullable results, NSError * _Nullable error) {
        if(error){
            NSLog(@"error %@", error);
            return;
        }
        NSLog(@"%@", results);
    }];
    [self.store executeQuery:query];
}

-(void)applicationDidBecomeActive:(NSNotification*)notification{
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AUKObject *object = self.objects[indexPath.row];
        //DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    AUKUsage *object = (AUKUsage *)self.objects[indexPath.row];
    cell.textLabel.text = object.bundleIdentifier;
    
    static NSDateFormatter* df = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterShortStyle;
        df.timeStyle = NSDateFormatterMediumStyle;
    });
    cell.detailTextLabel.text = [df stringFromDate:object.startDate];
    
//    ATLifecycle *object = (ATLifecycle *)self.objects[indexPath.row];
//    cell.textLabel.text = object.bundleIdentifier;
//    cell.detailTextLabel.text = [df stringFromDate:object.date];
    
    return cell;
}

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/

@end
