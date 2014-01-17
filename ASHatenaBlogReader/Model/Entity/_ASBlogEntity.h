// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ASBlogEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct ASBlogEntityAttributes {
	__unsafe_unretained NSString *blogImageURL;
	__unsafe_unretained NSString *body;
	__unsafe_unretained NSString *pubDate;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *userID;
	__unsafe_unretained NSString *webURL;
} ASBlogEntityAttributes;

extern const struct ASBlogEntityRelationships {
} ASBlogEntityRelationships;

extern const struct ASBlogEntityFetchedProperties {
} ASBlogEntityFetchedProperties;









@interface ASBlogEntityID : NSManagedObjectID {}
@end

@interface _ASBlogEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ASBlogEntityID*)objectID;





@property (nonatomic, strong) NSString* blogImageURL;



//- (BOOL)validateBlogImageURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* body;



//- (BOOL)validateBody:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* pubDate;



//- (BOOL)validatePubDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userID;



//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* webURL;



//- (BOOL)validateWebURL:(id*)value_ error:(NSError**)error_;






@end

@interface _ASBlogEntity (CoreDataGeneratedAccessors)

@end

@interface _ASBlogEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBlogImageURL;
- (void)setPrimitiveBlogImageURL:(NSString*)value;




- (NSString*)primitiveBody;
- (void)setPrimitiveBody:(NSString*)value;




- (NSDate*)primitivePubDate;
- (void)setPrimitivePubDate:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUserID;
- (void)setPrimitiveUserID:(NSString*)value;




- (NSString*)primitiveWebURL;
- (void)setPrimitiveWebURL:(NSString*)value;




@end
