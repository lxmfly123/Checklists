//
//  IconPickerViewController.h
//  Checklists
//
//  Created by FLY.lxm on 10/5/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>

- (void)iconPicker:(IconPickerViewController *)iconPicker didPickIcon:
    (NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController

@property (nonatomic, weak) id<IconPickerViewControllerDelegate> delegate;

@end
