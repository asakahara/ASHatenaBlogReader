//
//  ASBlogTableViewCell.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASBlogTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ASDateUtil.h"

@implementation ASBlogTableViewCell

- (void)setupWithEntity:(ASBlogEntity *)entity
{
    // タイトル
    self.titleLabel.text = entity.title;
    if (entity.userID.length > 0) {
        // ユーザーID
        self.idLabel.text = [NSString stringWithFormat:@"id:%@", entity.userID];
    }
    // 投稿日
    self.publishDateLabel.text = [ASDateUtil formatDate:entity.pubDate formatString:@"MM/dd"];
    // ブログ画像
    if (entity.blogImageURL.length > 0) {
        [self.blogImageView setImageWithURL:[NSURL URLWithString:entity.blogImageURL]];
    } else {
        self.blogImageView.image = nil;
    }
}

@end
