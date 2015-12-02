//
//  ViewController.h
//  Checklists
//
//  Created by FLY.lxm on 9/20/15.
//  Copyright (c) 2015 FLY.lxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@class Checklist;

@interface ChecklistViewController : UITableViewController <ItemDetailViewControllerDelegate>

@property (nonatomic, weak) Checklist *checklist;

@end

