//
//  AllListsViewController.m
//  Checklists
//
//  Created by FLY.lxm on 9/24/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import "AllListsViewController.h"
#import "Checklist.h"
#import "ChecklistViewController.h"
#import "ChecklistItem.h"
#import "DataModel.h"

@interface AllListsViewController ()

@end

@implementation AllListsViewController
//{
//    NSMutableArray *_lists;
//}

//- (id) initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        _lists = [[NSMutableArray alloc] initWithCapacity:20];
//        
//        Checklist *list;
//        
//        list = [[Checklist alloc] init];
//        list.name = @"Birthdays";
//        [_lists addObject:list];
//        
//        list = [[Checklist alloc] init];
//        list.name = @"Groceries";
//        [_lists addObject:list];
//        
//        list = [[Checklist alloc] init];
//        list.name = @"Cool Apps";
//        [_lists addObject:list];
//        
//        list = [[Checklist alloc] init];
//        list.name = @"To-Do";
//        [_lists addObject:list];
//        
//        
//        for (Checklist *checklist in _lists) {
//            ChecklistItem *item = [[ChecklistItem alloc] init];
//            item.text = [NSString stringWithFormat:@"Item for %@",checklist.name];
//            [checklist.items addObject:item];
//        }
//
//    }
//    
//    return self;
//}

//- (NSString *)documentsDirectory {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths firstObject];
//    
//    return documentsDirectory;
//}
//
//- (NSString *)dataFilePath {
//    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
//}
//
//- (void)saveChecklists {
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:_lists forKey:@"Checklists"];
//    [archiver finishEncoding];
//    [data writeToFile:[self dataFilePath] atomically:YES];
//}
//
//- (void)loadChecklist {
//    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
//        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
//        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//        _lists = [unarchiver decodeObjectForKey:@"Checklists"];
//        [unarchiver finishDecoding];
//    } else {
//        _lists = [[NSMutableArray alloc] initWithCapacity:20];
//    }
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    NSInteger index = [self.dataModal indexOfSelectedChecklist];
    
    if (index >= 0 && index < [self.dataModal.lists count]) {
        [self performSegueWithIdentifier:@"ShowChecklist" sender:self.dataModal.lists[index]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
        ChecklistViewController *controller = segue.destinationViewController;
        controller.checklist = sender;
    } else if ([segue.identifier isEqualToString:@"AddChecklist"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
        controller.doneBarButton. enabled = NO;
        controller.delegate = self;
        controller.checklistToEdit = nil;
    }
}

#pragma mark UINavigationController Delegate Method

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [self.dataModal setIndexOfSelectedChecklist:-1];
    }
}

#pragma mark Table view delegate

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    ListDetailViewController *controller = (ListDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
    Checklist *checklist = self.dataModal.lists[indexPath.row];
    controller.checklistToEdit = checklist;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataModal.lists count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataModal.lists removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    Checklist *list = self.dataModal.lists[indexPath.row];
    cell.textLabel.text = list.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.imageView.image = [UIImage imageNamed:list.iconName];
    NSInteger count = [list countOfUnfinishedItems];
    NSString *labelText;
    if (count == 0) {
        labelText = @"全部完成";
    } else if (count > 0) {
        labelText = [[NSString alloc] initWithFormat:@"还有 %ld 个未完成事项", [list countOfUnfinishedItems]];
    }
    cell.detailTextLabel.text = labelText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Checklist *checklist = self.dataModal.lists[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"ChecklistIndex"];
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ListViewControllerDelegate methods

- (void)listDetailViewControlllerDidCancle:(ListDetailViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewControlller:(ListDetailViewController *)viewController didFinishAddingChecklist:(Checklist *)checklist {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.dataModal.lists insertObject:checklist atIndex:indexPath.row];
    
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.dataModal sortChecklists];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewControlller:(ListDetailViewController *)viewController didFinishEditingChecklist:(Checklist *)checklist {
//    NSInteger index = [self.dataModal.lists indexOfObject:checklist];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.textLabel.text = checklist.name;
    
    [self.dataModal sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
