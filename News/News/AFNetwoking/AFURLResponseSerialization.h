

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@protocol AFURLResponseSerialization <NSObject, NSSecureCoding, NSCopying>


- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error;

@end

#pragma mark -


@interface AFHTTPResponseSerializer : NSObject <AFURLResponseSerialization>

- (instancetype) init;


@property (nonatomic, assign) NSStringEncoding stringEncoding;


+ (instancetype)serializer;


@property (nonatomic, copy) NSIndexSet *acceptableStatusCodes;


@property (nonatomic, copy) NSSet *acceptableContentTypes;


- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError *__autoreleasing *)error;

@end

#pragma mark -



@interface AFJSONResponseSerializer : AFHTTPResponseSerializer

- (instancetype) init;


@property (nonatomic, assign) NSJSONReadingOptions readingOptions;


@property (nonatomic, assign) BOOL removesKeysWithNullValues;


+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end

#pragma mark -


@interface AFXMLParserResponseSerializer : AFHTTPResponseSerializer

@end

#pragma mark -

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED


@interface AFXMLDocumentResponseSerializer : AFHTTPResponseSerializer

- (instancetype) init;


@property (nonatomic, assign) NSUInteger options;


+ (instancetype)serializerWithXMLDocumentOptions:(NSUInteger)mask;

@end

#endif

#pragma mark -


@interface AFPropertyListResponseSerializer : AFHTTPResponseSerializer

- (instancetype) init;


@property (nonatomic, assign) NSPropertyListFormat format;


@property (nonatomic, assign) NSPropertyListReadOptions readOptions;


+ (instancetype)serializerWithFormat:(NSPropertyListFormat)format
                         readOptions:(NSPropertyListReadOptions)readOptions;

@end

#pragma mark -

@interface AFImageResponseSerializer : AFHTTPResponseSerializer

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

@property (nonatomic, assign) CGFloat imageScale;


@property (nonatomic, assign) BOOL automaticallyInflatesResponseImage;
#endif

@end

#pragma mark -


@interface AFCompoundResponseSerializer : AFHTTPResponseSerializer

@property (readonly, nonatomic, copy) NSArray *responseSerializers;


+ (instancetype)compoundSerializerWithResponseSerializers:(NSArray *)responseSerializers;

@end

extern NSString * const AFURLResponseSerializationErrorDomain;


extern NSString * const AFNetworkingOperationFailingURLResponseErrorKey;

extern NSString * const AFNetworkingOperationFailingURLResponseDataErrorKey;


