//
//  Checklist.m
//  Checklists
//
//  Created by FLY.lxm on 9/25/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import "Checklist.h"
#import "ChecklistItem.h"

@implementation Checklist

- (id)init {
    if (self=[super init]) {
        _items = [[NSMutableArray alloc] initWithCapacity:20];
        _iconName = @"Appointments";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.iconName = [aDecoder decodeObjectForKey:@"IconName"];
    }
    return self;
}

- (id)initWithName:(NSString *)name {
    if (self = [self init]) {
        self.name = name;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
}

- (NSInteger)countOfUnfinishedItems {
    __block NSInteger count = 0;
    [self.items enumerateObjectsUsingBlock:^(ChecklistItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (item.checked == NO) {
            ++count;
        }
    }];
    return count;
}

- (NSComparisonResult)compare:(Checklist *)otherChecklist {
    return [self.name localizedStandardCompare: otherChecklist.name];
}

@end
