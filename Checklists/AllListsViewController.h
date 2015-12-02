//
//  AllListsViewController.h
//  Checklists
//
//  Created by FLY.lxm on 9/24/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDetailViewController.h"

@class DataModel;

@interface AllListsViewController : UITableViewController <ListViewControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong)DataModel *dataModal;

@end
