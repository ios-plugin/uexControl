//
//  PLGrowingTextView.h
//
//  Created by AppCan.
//
 
#import <UIKit/UIKit.h>

@class PLGrowingTextView;
@class PLTextViewInternal;

@protocol PLGrowingTextViewDelegate

@optional
- (BOOL)PLGrowingTextViewShouldBeginEditing:(PLGrowingTextView *)PLGrowingTextView;
- (BOOL)PLGrowingTextViewShouldEndEditing:(PLGrowingTextView *)PLGrowingTextView;

- (void)PLGrowingTextViewDidBeginEditing:(PLGrowingTextView *)PLGrowingTextView;
- (void)PLGrowingTextViewDidEndEditing:(PLGrowingTextView *)PLGrowingTextView;

- (BOOL)PLGrowingTextView:(PLGrowingTextView *)PLGrowingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)PLGrowingTextViewDidChange:(PLGrowingTextView *)PLGrowingTextView;

- (void)PLGrowingTextView:(PLGrowingTextView *)PLGrowingTextView willChangeHeight:(float)height;
- (void)PLGrowingTextView:(PLGrowingTextView *)PLGrowingTextView didChangeHeight:(float)height;

- (void)PLGrowingTextViewDidChangeSelection:(PLGrowingTextView *)PLGrowingTextView;
- (BOOL)PLGrowingTextViewShouldReturn:(PLGrowingTextView *)PLGrowingTextView;
@end

@interface PLGrowingTextView : UIView <UITextViewDelegate> {
	PLTextViewInternal *internalTextView;	
	
	int minHeight;
	int maxHeight;
	
	//class properties
	int maxNumberOfLines;
	int minNumberOfLines;
	
	BOOL animateHeightChange;
	
	//uitextview properties
	NSObject <PLGrowingTextViewDelegate> *__unsafe_unretained delegate;
	UITextAlignment textAlignment; 
	NSRange selectedRange;
	BOOL editable;
	UIDataDetectorTypes dataDetectorTypes;
	UIReturnKeyType returnKeyType;
    
    UIEdgeInsets contentInset;
}

//real class properties
@property int maxNumberOfLines;
@property int minNumberOfLines;
@property BOOL animateHeightChange;
@property  (nonatomic,assign)UITextView *internalTextView;	


//uitextview properties
@property(unsafe_unretained) NSObject<PLGrowingTextViewDelegate> *delegate;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIFont *font;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic) UITextAlignment textAlignment;    // default is UITextAlignmentLeft
@property(nonatomic) NSRange selectedRange;            // only ranges of length 0 are supported
@property(nonatomic,getter=isEditable) BOOL editable;
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_0);
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (assign) UIEdgeInsets contentInset;
@property(nonatomic) BOOL enablesReturnKeyAutomatically;

//uitextview methods
//need others? use .internalTextView
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)isFirstResponder;

- (BOOL)hasText;
- (void)scrollRangeToVisible:(NSRange)range;

@end
