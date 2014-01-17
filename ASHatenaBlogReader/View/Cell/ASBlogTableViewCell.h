//
//  ASBlogTableViewCell.h
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBlogEntity.h"

@interface ASBlogTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *idLabel;
@property (nonatomic, weak) IBOutlet UILabel *publishDateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *blogImageView;

- (void)setupWithEntity:(ASBlogEntity *)entity;

@end
