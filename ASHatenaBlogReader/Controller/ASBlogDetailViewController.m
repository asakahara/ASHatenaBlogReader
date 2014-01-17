//
//  ASBlogDetailViewController.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASBlogDetailViewController.h"
#import "ASDateUtil.h"
#import "ASStringUtil.h"
#import "PBWebViewController.h"

@interface ASBlogDetailViewController () <NSLayoutManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *blogDetailCell;
@property (weak, nonatomic) IBOutlet UIButton *showWebButton;
@property (assign, nonatomic) CGFloat preferredWidth;

@end

@implementation ASBlogDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.titleLabel.text = self.blogEntity.title;
    self.dateLabel.text = [ASDateUtil formatDate:self.blogEntity.pubDate formatString:@"yyyy/MM/dd HH:mm"];
    self.idLabel.text = [NSString stringWithFormat:@"id:%@", self.blogEntity.userID];

    // コンテンツの行間を調整
    self.bodyLabel.attributedText = [ASStringUtil stringWithLineSpacing:
                                     self.blogEntity.body lineSpacing:10.0];
    
    self.preferredWidth = self.bodyLabel.frame.size.width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.blogDetailCell.contentView setNeedsLayout];
    [self.blogDetailCell.contentView layoutIfNeeded];
    
    CGFloat rowHeight = self.showWebButton.frame.origin.y + self.showWebButton.frame.size.height + 30;
    
    NSLog(@"rowHeight: %f", rowHeight);
    
    return rowHeight;
}

- (void)updateLabelPreferredMaxLayoutWidthToCurrentWidth:(UILabel *)label
{
    label.preferredMaxLayoutWidth = [label alignmentRectForFrame:label.frame].size.width;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 横画面にした際にラベルの横幅が縦画面のサイズのままになってしまうため、
    // preferredMaxLayoutWidthを画面サイズに併せて調整する
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.bodyLabel];
    [self updateLabelPreferredMaxLayoutWidthToCurrentWidth:self.titleLabel];
    
    CGFloat currentPreferredWidth = [self.bodyLabel alignmentRectForFrame:self.bodyLabel.frame].size.width;
    
    // 前回のpreferredMaxLayoutWidthと異なる場合、画面の向きが変更されたと判断してcellの高さを再調整するためリロードする
    if (self.preferredWidth != currentPreferredWidth) {
        [self.tableView reloadData];
    }
    
    self.preferredWidth = currentPreferredWidth;
    
    [self.view layoutSubviews];
}

- (IBAction)showWebPage:(id)sender
{
    PBWebViewController *webViewController = [[PBWebViewController alloc] init];
    webViewController.URL = [NSURL URLWithString:self.blogEntity.webURL];
    
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
