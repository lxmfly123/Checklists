//
//  ListDetailViewController.m
//  Checklists
//
//  Created by FLY.lxm on 9/27/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import "ListDetailViewController.h"
#import "Checklist.h"

@interface ListDetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ListDetailViewController
{
    NSString *_iconName;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _iconName = @"Folder";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_checklistToEdit != nil) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checklistToEdit.name;
        self.doneBarButton.enabled = YES;
        _iconName = _checklistToEdit.iconName;
    }
    
    self.iconImageView.image = [UIImage imageNamed:_iconName];
    self.textLabel.text = _iconName;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (IBAction)cancle {
    [self.delegate listDetailViewControlllerDidCancle:self];

}

- (IBAction)done {
    if (self.checklistToEdit == nil) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = self.textField.text;
        checklist.iconName = _iconName;
        
        [self.delegate listDetailViewControlller:self didFinishAddingChecklist:checklist];
    } else {
        self.checklistToEdit.name = self.textField.text;
        self.checklistToEdit.iconName = _iconName;
        [self.delegate listDetailViewControlller:self didFinishEditingChecklist:self.checklistToEdit];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return indexPath;
    } else {
        return nil;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newString length] > 0);
    return YES;
}

#pragma mark - IconPickerViewController Delegate Methods

- (void)iconPicker:(IconPickerViewController *)iconPicker didPickIcon:(NSString *)iconName {
    _iconName = iconName;
    self.iconImageView.image = [UIImage imageNamed:_iconName];
    self.textLabel.text = _iconName;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    IconPickerViewController *controller = segue.destinationViewController;
    controller.delegate = self;
}

@end
