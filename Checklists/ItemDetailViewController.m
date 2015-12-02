//
//  AddItemTableViewController.m
//  Checklists
//
//  Created by FLY.lxm on 9/22/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistItem.h"

@interface ItemDetailViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UISwitch *swtichControl;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;

@end

@implementation ItemDetailViewController
{
    NSDate *_dueDate;
    BOOL _datePickerVisiable;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneBarButton.enabled = NO;
    
    if (self.itemToEdit) {
        self.title = @"Edit Item";
        self.textField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
        
        self.swtichControl.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
//        self.dueDateLabel.text = [self.itemToEdit.dueDate descriptionWithLocale:[NSLocale systemLocale]];
    } else {
        self.swtichControl.on = NO;
        _dueDate = [NSDate date];
    }
    
    [self updateDueDateLabel];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark view updating methods

- (void)updateDueDateLabel {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateStyle:NSDateFormatterMediumStyle];
    [formater setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [formater stringFromDate:_dueDate];
}

- (void)showDatePicker {
    _datePickerVisiable = YES;
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker *)[datePickerCell viewWithTag:100];
    [datePicker setDate:_dueDate animated:NO];
}

- (void)hideDatePicker {
    _datePickerVisiable = NO;
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (BOOL) isDateRow:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        UITableViewCell *datePickerCell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
    
        if (datePickerCell == nil) {
            datePickerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            datePickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 216.0f)];
            datePicker.tag = 100;
            [datePickerCell.contentView addSubview:datePicker];
            
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return datePickerCell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 && _datePickerVisiable) {
        return 3;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 217.0f;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Table view delegate methods

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDateRow:indexPath]) {
        return indexPath;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textField becomeFirstResponder];
    if ([self isDateRow:indexPath]) {
        if (_datePickerVisiable) {
            [self hideDatePicker];
        } else {
            [self showDatePicker];
        }
    }
}

#pragma mark IBAction
-(IBAction)cancel {
    [self.delegate itemDetailViewControllerDidCancel:self];
    
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)done {
    if (self.itemToEdit) {
        self.itemToEdit.text = self.textField.text;
        
        self.itemToEdit.shouldRemind = self.swtichControl.on;
        self.itemToEdit.dueDate = _dueDate;
        [self.itemToEdit scheduleNotification];
        
        [self.delegate itemDetailViewController:self didFinishedEditingItem:self.itemToEdit];
        
    } else {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.textField.text;
        
        item.shouldRemind = self.swtichControl.on;
        item.dueDate = _dueDate;
        [item scheduleNotification];
        
        [self.delegate itemDetailViewController:self didFinishedAddingItem:item];
    }
    
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = [newText length] > 0;
    
    return YES;
}

@end
