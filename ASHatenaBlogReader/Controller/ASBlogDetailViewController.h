//
//  ASBlogDetailViewController.h
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBlogEntity.h"

@interface ASBlogDetailViewController : UITableViewController

@property (nonatomic, strong) ASBlogEntity *blogEntity;

@end
