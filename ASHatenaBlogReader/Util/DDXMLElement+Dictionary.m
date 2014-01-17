//
//  DDXMLElement+Dictionary.m
//  ASHatenaBlogReader
//
//  Created by sakahara on 2013/12/31.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "DDXMLElement+Dictionary.h"

NSString * const kTextNodeKey = @"text";

@implementation DDXMLElement (Dictionary)

- (NSDictionary *)convertDictionary
{
    NSMutableDictionary *elementDict = [NSMutableDictionary dictionary];
    
    // elementDictに属性をセット
    for (DDXMLNode *attribute in self.attributes) {
        elementDict[attribute.name] = attribute.stringValue;
    }
    
    // elementDictにネームスペースをセット
    for (DDXMLNode *namespace in self.namespaces) {
        elementDict[namespace.name] = namespace.stringValue;
    }
    
    if (self.childCount > 0) {
        // 子要素がある場合は子要素に対し再起的に+ dictionaryWithElement:メソッドを実行する。
        for (DDXMLNode *childNode in self.children) {
            if (childNode.kind == DDXMLElementKind) {
                DDXMLElement *childElement = (DDXMLElement *)childNode;
                
                NSString *childElementName = childElement.name;
                NSDictionary *childElementDict = [childElement convertDictionary];
                
                if (elementDict[childElementName] == nil) {
                    // elementDictにchildElementNameで指定された要素が存在しない場合、elementDictに要素を追加する
                    [elementDict addEntriesFromDictionary:childElementDict];
                } else if ([elementDict[childElementName] isKindOfClass:[NSArray class]]) {
                    // childElementNameで指定された要素が既存在しかつ配列の場合、その配列に子要素を追加する
                    NSMutableArray *items = [NSMutableArray arrayWithArray:elementDict[childElementName]];
                    [items addObject:childElementDict[childElementName]];
                    elementDict[childElementName] = [NSArray arrayWithArray:items];
                } else {
                    // childElementNameで指定された要素が既存在しかつ配列でない場合、新しく配列を生成して子要素を追加する
                    NSMutableArray *items = [NSMutableArray array];
                    [items addObject:elementDict[childElementName]];
                    [items addObject:childElementDict[childElementName]];
                    elementDict[childElementName] = [NSArray arrayWithArray:items];
                }
            } else if (childNode.stringValue != nil && childNode.stringValue.length > 0) {
                // テキストがあればセットする
                if (elementDict.count > 0) {
                    elementDict[kTextNodeKey] = childNode.stringValue;
                } else {
                    elementDict[self.name] = childNode.stringValue;
                }
            }
        }
    }
    
    NSDictionary *resultDict = nil;
    
    if (elementDict.count > 0) {
        if (elementDict[self.name]) {
            resultDict = [NSDictionary dictionaryWithDictionary:elementDict];
        } else {
            resultDict = [NSDictionary dictionaryWithObject:elementDict forKey:self.name];
        }
    }
    
    return resultDict;
}

@end
