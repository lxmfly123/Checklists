//
//  ChecklistItem.h
//  Checklists
//
//  Created by FLY.lxm on 9/21/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject <NSCoding>

@property(nonatomic, copy) NSString *text;
@property(nonatomic, assign) BOOL checked;
@property(nonatomic, copy) NSDate *dueDate;
@property (nonatomic, assign) BOOL shouldRemind;
@property (nonatomic, assign) NSInteger itemID;

- (void) toggleChecked;
- (void) scheduleNotification;

@end
