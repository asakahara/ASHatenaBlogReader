//
//  ASStringUtil.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2014/01/01.
//  Copyright (c) 2014年 Mocology. All rights reserved.
//

#import "ASStringUtil.h"

@implementation ASStringUtil

+ (NSAttributedString *)stringWithLineSpacing:(NSString *)string lineSpacing:(CGFloat)lineSpacing
{
    // パラグラフスタイルにlineHeightをセット
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.lineSpacing = lineSpacing;
    
    // NSAttributedStringを生成してパラグラフスタイルをセット
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]
                                                 initWithString:string];
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:paragrahStyle
                           range:NSMakeRange(0, attributedText.length)];
    
    return attributedText;
}

@end
