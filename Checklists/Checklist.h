//
//  Checklist.h
//  Checklists
//
//  Created by FLY.lxm on 9/25/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checklist : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *iconName;

- (id)initWithName:(NSString *)name;
- (NSInteger)countOfUnfinishedItems;

@end
