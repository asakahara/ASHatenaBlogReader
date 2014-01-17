// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASBlogEntity.m instead.

#import "_ASBlogEntity.h"

const struct ASBlogEntityAttributes ASBlogEntityAttributes = {
	.blogImageURL = @"blogImageURL",
	.body = @"body",
	.pubDate = @"pubDate",
	.title = @"title",
	.userID = @"userID",
	.webURL = @"webURL",
};

const struct ASBlogEntityRelationships ASBlogEntityRelationships = {
};

const struct ASBlogEntityFetchedProperties ASBlogEntityFetchedProperties = {
};

@implementation ASBlogEntityID
@end

@implementation _ASBlogEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Blog";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Blog" inManagedObjectContext:moc_];
}

- (ASBlogEntityID*)objectID {
	return (ASBlogEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic blogImageURL;






@dynamic body;






@dynamic pubDate;






@dynamic title;






@dynamic userID;






@dynamic webURL;











@end
