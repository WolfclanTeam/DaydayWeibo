//
//  KZJShareScopeTableController.m
//  DayDayWeibo
//
//  Created by apple on 14-10-25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJShareScopeTableController.h"

@interface KZJShareScopeTableController ()
@property (strong, nonatomic) IBOutlet UITableView *scopeTableView;

@end

@implementation KZJShareScopeTableController
@synthesize scopeVisibleBlock;
- (void)viewDidLoad
{
    [super viewDidLoad];
    scopeArr = @[@"对所有人可见",@"仅自己可见",@"对好友圈可见"];
    
     userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults arrayForKey:@"zljImageScopeArr"])
    {
        NSArray *arr =[userDefaults arrayForKey:@"zljImageScopeArr"];
        imageScopeArr = [NSMutableArray arrayWithArray:arr];
    }
    else
    {
        imageScopeArr = [[NSMutableArray alloc] initWithObjects:@"compose_guide_check_box_right@2x",@"compose_guide_check_box_number@2x",@"compose_guide_check_box_number@2x", nil];
    }
   
    
    
    UIView *bacView = [[UIView alloc] init];
    bacView.backgroundColor = [UIColor clearColor];
    [self.scopeTableView setTableFooterView:bacView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
}
-(void)backMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    return [scopeArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = [scopeArr objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[imageScopeArr objectAtIndex:indexPath.row]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    imageScopeArr = [[NSMutableArray alloc] initWithObjects:@"compose_guide_check_box_number@2x",@"compose_guide_check_box_number@2x",@"compose_guide_check_box_number@2x", nil];
    [self.scopeTableView reloadData];
    cell.imageView.image = [UIImage imageNamed:@"compose_guide_check_box_right@2x"];
    [imageScopeArr replaceObjectAtIndex:indexPath.row withObject:@"compose_guide_check_box_right@2x"];

    
    [userDefaults setObject:imageScopeArr forKey:@"zljImageScopeArr"];
    [userDefaults synchronize];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.scopeVisibleBlock)
    {
        
        self.scopeVisibleBlock([scopeArr objectAtIndex:indexPath.row],indexPath.row);
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
