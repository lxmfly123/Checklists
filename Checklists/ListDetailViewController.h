//
//  ListDetailViewController.h
//  Checklists
//
//  Created by FLY.lxm on 9/27/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconPickerViewController.h"

@class ListDetailViewController;
@class Checklist;

@protocol ListViewControllerDelegate <NSObject>

- (void)listDetailViewControlllerDidCancle:(ListDetailViewController *)viewController;
- (void)listDetailViewControlller:(ListDetailViewController *)viewController didFinishAddingChecklist:(Checklist *)checklist;
- (void)listDetailViewControlller:(ListDetailViewController *)viewController didFinishEditingChecklist:(Checklist *)checklist;

@end

@interface ListDetailViewController : UITableViewController <UITextFieldDelegate, IconPickerViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneBarButton;

@property (nonatomic, weak) id<ListViewControllerDelegate> delegate;
@property (nonatomic, weak) Checklist* checklistToEdit;

- (IBAction)cancle;
- (IBAction)done;

@end
