

#import "ButtonView.h"

@implementation ButtonView




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target  = target;
    self.action = action;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //让外部传入的对象 去 执行 外部传入的方法；
    [self.target performSelector:self.action withObject:@"123"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
