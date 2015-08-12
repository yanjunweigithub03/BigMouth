

#import <UIKit/UIKit.h>

@interface ButtonView : UIView

//要指向方法的对象
@property(nonatomic, assign)id target;
//指定要执行的方法；
@property(nonatomic, assign)SEL action;

- (void)addTarget:(id)target action:(SEL)action;

@end
