//
//  DocumentViewController.h
//  FastPDFKitTest
//
//  Created by Nicolò Tosi on 8/25/10.
//  Copyright 2010 MobFarm S.r.l. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MFDocumentViewController.h"
#import "MFDocumentViewControllerDelegate.h"
#import "BookmarkViewControllerDelegate.h"
#import "SearchViewControllerDelegate.h"
#import "MiniSearchViewControllerDelegate.h"
#import "OutlineViewControllerDelegate.h"
#import "TextDisplayViewControllerDelegate.h"
#import "MediaPlayer/MediaPlayer.h"

@class BookmarkViewController;
@class SearchViewController;
@class TextDisplayViewController;
@class SearchManager;
@class MiniSearchView;
@class MFTextItem;

#define FPK_REUSABLE_VIEW_NONE 0
#define FPK_REUSABLE_VIEW_SEARCH 1
#define FPK_REUSABLE_VIEW_TEXT 2
#define FPK_REUSABLE_VIEW_OUTLINE 3
#define FPK_REUSABLE_VIEW_BOOKMARK 4

#define FPK_SEARCH_VIEW_MODE_MINI 0
#define FPK_SEARCH_VIEW_MODE_FULL 1

@interface ReaderViewController : MFDocumentViewController <MFDocumentViewControllerDelegate,UIPopoverControllerDelegate,TextDisplayViewControllerDelegate,SearchViewControllerDelegate,BookmarkViewControllerDelegate,OutlineViewControllerDelegate,MiniSearchViewControllerDelegate> {
	
	UILabel * numberOfPageTitleToolbar;
	UILabel * pageNumLabel;
	
	id senderText;
	id senderSearch;
    
	UIToolbar * rollawayToolbar;
    
    CGFloat toolbarHeight;
	CGFloat thumbSliderViewBorderWidth;
	CGFloat thumbSliderViewHeight;
	
	// Child view controllers
    
	SearchViewController * searchViewController;
	SearchManager * searchManager;
	MiniSearchView * miniSearchView;
	TextDisplayViewController * textDisplayViewController;
	    
	UIPopoverController *reusablePopover;   // This is a single popover controller that will be used to display alternate content view controller
    NSUInteger currentReusableView;         // This flag is used to keep track of what alternate controller is displayed to the user
    NSUInteger currentSearchViewMode;       // This flag keep track of which search view is currently in use, full or mini
    
    // Button content for bar button items

    UIButton *changeModeButton;
	UIButton *zoomLockButton;
	UIButton *changeDirectionButton;
	UIButton *changeLeadButton;
    
    // Bar button items
    
    UIBarButtonItem *changeModeBarButtonItem;
	UIBarButtonItem *zoomLockBarButtonItem;
	UIBarButtonItem *changeDirectionBarButtonItem;
	UIBarButtonItem *changeLeadBarButtonItem;
	UIBarButtonItem *searchBarButtonItem;
    
    // Flags
    
    BOOL willFollowLink;
    BOOL hudHidden; // General HUD visible flag
	BOOL multimediaVisible;
    BOOL pdfOpen;
	BOOL thumbsViewVisible;
    BOOL waitingForTextInput;
    
    // Cached images for dynamic interface elements
	
	UIImage * imgModeSingle;
	UIImage * imgModeDouble;
    UIImage * imgModeOverflow;
	
	UIImage * imgZoomLock;
	UIImage * imgZoomUnlock;
	
	UIImage * imgl2r;
	UIImage * imgr2l;
	
	UIImage * imgLeadRight;
	UIImage * imgLeadLeft;
    
    UIImage * imgDismiss;
    UIImage * imgBookmark;
    UIImage * imgSearch;
    UIImage * imgOutline;
    UIImage * imgText;
    
    void (^dismissBlock) ();
}

/**
 This block will be executed inside the actionDismiss action. If not defined,
 the ReaderViewController will try to guesstimate the appropriate action.
 */
@property (nonatomic, copy) void (^dismissBlock) ();

@property (nonatomic,retain) UIButton *changeModeButton;
@property (nonatomic,retain) UIButton *zoomLockButton;
@property (nonatomic,retain) UIButton *changeDirectionButton;
@property (nonatomic,retain) UIButton *changeLeadButton;

@property (nonatomic,retain) UIImage * imgModeSingle;
@property (nonatomic,retain) UIImage * imgModeDouble;
@property (nonatomic,retain) UIImage * imgZoomLock;
@property (nonatomic,retain) UIImage * imgZoomUnlock;
@property (nonatomic,retain) UIImage * imgl2r;
@property (nonatomic,retain) UIImage * imgr2l;
@property (nonatomic,retain) UIImage * imgLeadRight;
@property (nonatomic,retain) UIImage * imgLeadLeft;
@property (nonatomic,retain) UIImage * imgModeOverflow;
@property (nonatomic,retain) UIImage * imgDismiss;
@property (nonatomic,retain) UIImage * imgBookmark;
@property (nonatomic,retain) UIImage * imgSearch;
@property (nonatomic,retain) UIImage * imgOutline;
@property (nonatomic,retain) UIImage * imgText;
@property (nonatomic, readwrite) CGFloat toolbarHeight;

-(void)updatePageNumberLabel;

-(void)showToolbar;
-(void)hideToolbar;

@property (nonatomic, retain) UIToolbar * rollawayToolbar;
@property (nonatomic, retain) UILabel * pageNumLabel;

@property (nonatomic, retain) UIBarButtonItem * searchBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * changeModeBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * zoomLockBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * changeDirectionBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * changeLeadBarButtonItem;

@property (nonatomic, retain) UIBarButtonItem * bookmarkBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * textBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * numberOfPageTitleBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * dismissBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem * outlineBarButtonItem;

@property (nonatomic, retain) UILabel * numberOfPageTitleToolbar;

@property (nonatomic, retain) SearchViewController * searchViewController;
@property (nonatomic, retain) SearchManager * searchManager;
@property (nonatomic, retain) MiniSearchView * miniSearchView;
@property (nonatomic, retain) TextDisplayViewController * textDisplayViewController;

@property (nonatomic, readwrite, getter = isMultimediaVisible) BOOL multimediaVisible;

@property (nonatomic, retain) UIPopoverController * reusablePopover;

@property (copy, nonatomic, readwrite) NSString * pageLabelFormat;

-(void)dismissAlternateViewController;
-(void)playVideo:(NSString *)path local:(BOOL)isLocal;
-(void)playAudio:(NSString *)path local:(BOOL)isLocal;
-(void)showWebView:(NSString *)path local:(BOOL)isLocal;

@end
