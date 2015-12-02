//
//  ViewController.m
//  Checklists
//
//  Created by FLY.lxm on 9/20/15.
//  Copyright (c) 2015 FLY.lxm. All rights reserved.
//

#import "ChecklistViewController.h"
#import "ChecklistItem.h"
#import "Checklist.h"

@interface ChecklistViewController ()

@end

@implementation ChecklistViewController
//{
//    NSArray *rowArray;
//    NSMutableArray *_items;
//}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadSavedChecklistItems];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _checklist.name;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Do any additional setup after loading the view, typically from a nib.
//    _items = [[NSMutableArray alloc] initWithCapacity:100];
//    for (int i = 0; i<100; i++) {
//        [_items addObject: @"0"];
//    }
//    rowArray = @[
//                   @"good",
//                   @"morning",
//                   @"Mr.",
//                   @"Sunshine",
//                   @"Bye",
//                   ];
//    [rowArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        for (int i = 0; i < 100/[rowArray count]; i++) {
//            ChecklistItem *item = [[ChecklistItem alloc] init];
//            item.text = (NSString *)obj;
//            _items[5 * i + idx] = item;
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark logic

-(void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item {
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
}

-(void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item {
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = [NSString stringWithFormat:@"%ld %@", item.itemID, item.text];
}

-(void)addItem:(ChecklistItem *)item atRow:(NSUInteger)row {
    [self.checklist.items insertObject:item atIndex:row];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
//    NSLog(@"%@",documentDirectory);
    return documentDirectory;
}

- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"checklist.plist"];
}

- (void) saveChecklistItems {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.checklist.items forKey:@"ChecklistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void) loadSavedChecklistItems {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.checklist.items = [unArchiver decodeObjectForKey:@"ChecklistItems"];
        [unArchiver finishDecoding];
    } else {
        self.checklist.items = [[NSMutableArray alloc] initWithCapacity:10];
    }

}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *navigationController = segue.destinationViewController;
    ItemDetailViewController *addItemViewControllr = (ItemDetailViewController *)navigationController.topViewController;
    addItemViewControllr.delegate = self;
    
    if ([segue.identifier isEqualToString:@"Add Item"]) {
        addItemViewControllr.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Edit Item"]) {
        addItemViewControllr.delegate = self;
        addItemViewControllr.itemToEdit = self.checklist.items[[self.tableView indexPathForCell:sender].row];
    }
}

#pragma mark - Data Source Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.checklist.items removeObjectAtIndex:indexPath.row];
//    [self saveChecklistItems];
    
    NSArray *indexPaths = @[indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.checklist.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];
//    ChecklistItem *item = _items[indexPath.row];
    ChecklistItem *item = [self.checklist.items objectAtIndex:indexPath.row];
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    cell.showsReorderControl = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
}

#pragma mark TableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    ChecklistItem *item = _items;
    ChecklistItem *item = [self.checklist.items objectAtIndex:indexPath.row];
    
    [item toggleChecked];
    
//    [self saveChecklistItems];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark AddItemViewControllerDelegate Methods

-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller {
//    [self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishedAddingItem:(ChecklistItem *)item {
//    [self addItem:item atRow:[_items count]]
    [self addItem:item atRow:0];
//    [self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishedEditingItem:(ChecklistItem *)item {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.checklist.items indexOfObject:item] inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureTextForCell:cell withChecklistItem:item];
//    [self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
