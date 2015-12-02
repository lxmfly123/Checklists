//
//  AddItemTableViewController.h
//  Checklists
//
//  Created by FLY.lxm on 9/22/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;
@class ChecklistItem;

@protocol ItemDetailViewControllerDelegate <NSObject>

-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller;
-(void)itemDetailViewController: (ItemDetailViewController *)controller didFinishedAddingItem: (ChecklistItem *)item;
-(void)itemDetailViewController: (ItemDetailViewController *)controller didFinishedEditingItem: (ChecklistItem *)item;

@end

@interface ItemDetailViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) id <ItemDetailViewControllerDelegate> delegate;
@property (nonatomic, weak) ChecklistItem *itemToEdit;

-(IBAction)done;
-(IBAction)cancel;

@end
