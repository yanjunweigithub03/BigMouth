

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, INSSearchBarState)
{
	
	
	INSSearchBarStateNormal = 0,
	
	
	
	INSSearchBarStateSearchBarVisible,

	INSSearchBarStateSearchBarHasContent,

	
	INSSearchBarStateTransitioning
};

@class INSSearchBar;


@protocol INSSearchBarDelegate <NSObject>

@optional
- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar;



- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState;


- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState;


- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar;



- (void)searchBarTextDidChange:(INSSearchBar *)searchBar;

@end

/**
 *  An animating search bar.
 */

@interface INSSearchBar : UIView

/**
 *  The current state of the search bar.
 */

@property (nonatomic, readonly) INSSearchBarState state;

/**
 *  The text field used for entering search queries. Visible only when search is active.
 */

@property (nonatomic, readonly) UITextField *searchField;

/**
 *  The (optional) delegate is responsible for providing values necessary for state change animations of the search bar. @see INSSearchBarDelegate.
 */

@property (nonatomic, weak) id<INSSearchBarDelegate>	delegate;

@end
