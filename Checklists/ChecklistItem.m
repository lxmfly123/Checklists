//
//  ChecklistItem.m
//  Checklists
//
//  Created by FLY.lxm on 9/21/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"
#import "AppDelegate.h"

@implementation ChecklistItem

-(id)init {
    if (self = [super init]) {
        self.itemID = [DataModel nextItemID];
        return self;
    }
    
    return self;
}

- (void)dealloc {
    if ([self notificationForThisItem] != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:[self notificationForThisItem]];
    }
}

//
//-(id)initWithText: (NSString *)text {
//    if (self = [super init]) {
//        _text = text;
//        return self;
//    }
//    _text = text;
//    return self;
//}

- (void)toggleChecked {
    self.checked = !self.checked;
}

- (UILocalNotification *)generateNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = self.dueDate;
    notification.alertBody = self.text;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = @{@"ItemID": @(self.itemID)};
    notification.category = @"INVITE_CATEGORY";
//    notification.applicationIconBadgeNumber = 10;
    
    UIMutableUserNotificationAction *acceptAction =
    [[UIMutableUserNotificationAction alloc] init];
    
    /**** 1 设置 Action ****/
    
    // Define an ID string to be passed back to your app when you handle the action
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    
    // Localized string displayed in the action button
    acceptAction.title = @"Accept";
    
    // If you need to show UI, choose foreground
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    
    // Destructive actions display in red
    acceptAction.destructive = NO;
    
    // Set whether the action requires the user to authenticate
    acceptAction.authenticationRequired = NO;
    
    /**** 2 设置 Action Category ****/
    
    // First create the category
    UIMutableUserNotificationCategory *inviteCategory =
    [[UIMutableUserNotificationCategory alloc] init];
    
    // Identifier to include in your push payload and local notification
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    // Add the actions to the category and set the action context
    [inviteCategory setActions:@[acceptAction]
                    forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to present in a minimal context
    [inviteCategory setActions:@[acceptAction]
                    forContext:UIUserNotificationActionContextMinimal];
    
    UIApplication *application = [UIApplication sharedApplication];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [application registerUserNotificationSettings:settings];
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:categories]];
    
    return notification;
}

- (UILocalNotification *)notificationForThisItem {
    NSArray *allNotification = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in allNotification) {
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        NSLog(@"Item: %@", number);
        if (number != nil && [number integerValue] == self.itemID) {
            return notification;
        }
    }
    return nil;
}

- (BOOL)isNotificationValid:(UILocalNotification *)notification {
    return [self.dueDate compare:notification.fireDate] != NSOrderedAscending;
}

- (BOOL)isNotificationChanged:(UILocalNotification *)notification {
    return [self.dueDate compare:notification.fireDate] != NSOrderedSame;
}

- (void)scheduleNotification {
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        if (!self.shouldRemind) {
            NSLog(@"取消原来的提醒");
            [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
        } else if ([self isNotificationChanged:existingNotification] && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
            // 如果改变了提醒日期且日期有效，则取消原来的提醒，增加新提醒。
            NSLog(@"取消原来的提醒，增加新提醒");
            [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
            [[UIApplication sharedApplication] scheduleLocalNotification:[self generateNotification]];
        } // 如果改变了提醒日期且日期无效，则什么也不做。
    } else if (self.shouldRemind) {
        if ([self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
            [[UIApplication sharedApplication] scheduleLocalNotification:[self generateNotification]];
        }
    }
    
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedDescending) {
//        [[UIApplication sharedApplication] scheduleLocalNotification:[self notificationForItem: (ChecklistItem *)item]];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemID forKey:@"ItemID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeObjectForKey:@"ShouldRemind"];
        self.itemID = [aDecoder decodeIntegerForKey:@"ItemID"];
    }
    return self;
}

@end

