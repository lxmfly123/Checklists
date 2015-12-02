//
//  DataModel.m
//  Checklists
//
//  Created by FLY.lxm on 10/2/15.
//  Copyright © 2015 FLY.lxm. All rights reserved.
//

#import "DataModel.h"
#import "Checklist.h"

@implementation DataModel

+ (NSInteger)nextItemID {
    NSInteger itemID = [[NSUserDefaults standardUserDefaults] integerForKey:@"ItemID"];
    [[NSUserDefaults standardUserDefaults] setInteger:itemID + 1 forKey:@"ItemID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return itemID;
}

- (id)init {
    if (self = [super init]) {
//        [self registerDefaults];
        [self loadChecklists];
        [self handleFirstTimeRun];
    }
    return self;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists"];
}

- (void)saveChecklists {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklists {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.lists = [unarchiver decodeObjectForKey:@"Checklists"];
        [unarchiver finishDecoding];
    } else {
        self.lists = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

- (void)registerDefaults {
    NSDictionary *dictionary = @{
                                 @"ChecklistIndex": @-1,
                                 @"FirstTime": @YES,
                                 @"ItemID": @0,
                                 };
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (NSInteger)indexOfSelectedChecklist {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChecklistIndex"];
}

- (void)setIndexOfSelectedChecklist: (NSInteger)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"ChecklistIndex"];
}

- (void)handleFirstTimeRun {
    BOOL isFirstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"];
    if (isFirstTime) {
        Checklist *checklist = [[Checklist alloc] initWithName:@"list"];
        [self.lists insertObject:checklist atIndex:0];
        [self setIndexOfSelectedChecklist:0];
        NSLog(@"Fisrt Run");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTime"];
    }
}

- (void)sortChecklists {
    [self.lists sortUsingSelector:@selector(compare:)];
}

@end
