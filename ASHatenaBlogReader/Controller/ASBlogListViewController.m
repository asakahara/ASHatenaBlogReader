//
//  ASListBlogViewController.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASBlogListViewController.h"
#import "ASBlogManager.h"
#import "ASBlogTableViewCell.h"
#import "ASBlogDetailViewController.h"

static NSString *kCellIdentifier = @"BlogCell";

@interface ASBlogListViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *blogs;

@end

@implementation ASBlogListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[ASBlogManager sharedManager] addObserver:self
                                          forKeyPath:@"blogs"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAction:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self refreshAction:nil];
}

- (void)dealloc
{
    [[ASBlogManager sharedManager] removeObserver:self forKeyPath:@"blogs"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [ASBlogManager sharedManager] && [keyPath isEqualToString:@"blogs"]) {
        // 配列が変更された場所のインデックス.
        NSIndexSet *indexSet = change[NSKeyValueChangeIndexesKey];
        // 変更の種類.
        NSKeyValueChange changeKind = (NSKeyValueChange)[change[NSKeyValueChangeKindKey] integerValue];
        
        // 配列に詰め替え.
        NSMutableArray *indexPaths = [NSMutableArray array];
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }];
        
        [self.tableView beginUpdates];
        if (changeKind == NSKeyValueChangeInsertion) {
            // 新規追加
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if (changeKind == NSKeyValueChangeRemoval) {
            // 削除
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if (changeKind == NSKeyValueChangeReplacement) {
            // 更新
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ASBlogManager sharedManager].blogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASBlogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    ASBlogEntity *entity = [ASBlogManager sharedManager].blogs[(NSUInteger) indexPath.row];
    [cell setupWithEntity:entity];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AKOpenBlogSegue"]) {
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
        ASBlogEntity *blog = [ASBlogManager sharedManager].blogs[selected.row];
        
        ASBlogDetailViewController *controller = segue.destinationViewController;
        controller.blogEntity = blog;
    }
}

#pragma mark - Action method

- (void)refreshAction:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    // 表示するデータが無い場合、DBから取得して配列に追加
    if ([ASBlogManager sharedManager].blogs.count == 0) {
        [[ASBlogManager sharedManager] loadAllBlogs];
    }
    
    __weak typeof(self) weakSelf = self;
    [[ASBlogManager sharedManager] reloadBlogsWithBlock:^(NSError *error) {
        
        if (error) {
            NSLog(@"error: %@", error);
        }
        
        [weakSelf.refreshControl endRefreshing];
    }];
}

@end
