//
//  DataModel.h
//  Checklists
//
//  Created by FLY.lxm on 10/2/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong)NSMutableArray *lists;

+ (NSInteger)nextItemID;

- (void)saveChecklists;
- (void)sortChecklists;

- (NSInteger)indexOfSelectedChecklist;
- (void)setIndexOfSelectedChecklist:(NSInteger)index;

@end
