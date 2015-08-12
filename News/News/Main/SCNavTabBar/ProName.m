

#import "ProName.h"

@implementation ProName


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.proName = [dictionary objectForKey:@"省"];
        
        }
    return self;
}

@end
