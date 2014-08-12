//
//  ViewController.m
//  ToothpastesIHaveLovedAndAdored
//
//  Created by Nicolas Semenas on 11/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import "AdoredToothpastesViewController.h"
#import "ToothpastesTableViewController.h"

@interface AdoredToothpastesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * adoredToothpastes;
@property (weak, nonatomic) IBOutlet UITableView *toothpasteTableView;

@end

@implementation AdoredToothpastesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
    if (self.adoredToothpastes == nil){
        self.adoredToothpastes = [NSMutableArray new];

    }
}

-(IBAction)unwindFromToothpasteViewController:(UIStoryboardSegue *)segue{
    NSLog(@"Yeahhhh");
    
    ToothpastesTableViewController *tvc = segue.sourceViewController;
    
    NSString * toothpaste = [tvc adoredToothpaste];
    [self.adoredToothpastes addObject:toothpaste];
    
    // REFRESCA SOLO LA ULTIMA ROW, QUE ES LA QUE TIENE EL VALOR AGREGADO RECIENTEMENTE
    NSIndexPath *indexPath;
    indexPath = [NSIndexPath indexPathForRow:self.adoredToothpastes.count-1 inSection:0];
    [self.toothpasteTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self save];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.adoredToothpastes.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"] ;
    cell.textLabel.text = [self.adoredToothpastes objectAtIndex:indexPath.row];
    return  cell;
}

-(NSURL *)documentsDirectory{
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray *directories =  [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSLog(@"%@", directories.firstObject);
    return directories.firstObject;
    
}

-(void) load {
 
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"pastes1.plist"];
    self.adoredToothpastes = [NSMutableArray arrayWithContentsOfURL:plist];
}

- (void) save{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSURL * plist = [[self documentsDirectory]URLByAppendingPathComponent:@"pastes1.plist"];
    
    NSLog(@"%@", plist);
    [self.adoredToothpastes writeToURL:plist atomically:YES];
    [defaults setObject:[NSDate date] forKey:@"lastSaved"];
    [defaults synchronize];
}


@end
