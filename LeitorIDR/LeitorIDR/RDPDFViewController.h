//
//  RDPDFViewController.h
//  PDFViewer
//
//  Created by Radaee on 12-10-29.
//  Copyright (c) 2012年 Radaee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFView.h"
#import "PDFIOS.h"
#import "OutLineViewController.h"
#import <CoreData/CoreData.h>
#import "TextAnnotViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LivroResponse.h"

@class OutLineViewController;
@class PDFView;
@class PopupMenu;
@class PDFVThumb;
@class PDFV;
@interface RDPDFViewController : UIViewController <UISearchBarDelegate,saveTextAnnotDelegate>
{
    //GEAR
    MPMoviePlayerViewController *mpvc;
    //FINE
    PDFView *m_view;
    PDFVThumb *m_Thumbview;
    PDFDoc *m_doc;
    BOOL b_findStart;
    CGRect recttoolbar;
    NSString *findString;
    BOOL b_lock;
    OutLineViewController *outlineView;
    BOOL b_sigleTap;
    PopupMenu* popupMenu1;
    PopupMenu* popupMenu2;
    PDFPage *PDFpage;
    PDFAnnot *PDFannot;
    PDFV *pdf_view;
    NSString *nuri;
    float begin_x;
    float begin_y;
    float end_x;
    float end_y;
    bool m_bSel;
    int posx;
    int posy;
    TextAnnotViewController *textAnnotVC;
    NSMutableArray *tempfiles;
}
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong,nonatomic) UIToolbar *searchToolBar;
@property (strong,nonatomic) UIToolbar *drawLineToolBar;
@property (strong,nonatomic) UIToolbar *drawRectToolBar;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIBarButtonItem *lineButton;
@property (strong, nonatomic) IBOutlet UISearchBar* m_searchBar;
@property (strong,nonatomic)IBOutlet UISlider *sliderBar;
@property (strong,nonatomic)IBOutlet UILabel *pageNumLabel;
@property (assign, nonatomic)int pagecount;
@property (assign, nonatomic)int pagenow;
@property (assign,nonatomic) BOOL b_keyboard;
@property (assign,nonatomic) PopupMenu* popupMenu;
@property (nonatomic, retain) LivroResponse *livro;
- (IBAction)composeFile:(id) sender;
- (IBAction)searchView:(id) sender;
- (IBAction)drawLine:(id) sender;
- (IBAction)drawRect:(id) sender;
-(IBAction)drawEllipse:(id)sender;
- (IBAction)viewMenu:(id) sender;
-(IBAction)lockView:(id)sender;
-(IBAction)searchCancel:(id)sender;
-(IBAction)prevword:(id)sender;
-(IBAction)nextword:(id)sender;

-(IBAction)drawLineDone:(id)sender;
-(IBAction)drawLineCancel:(id)sender;

-(IBAction)drawRectDone:(id)sender;
-(IBAction)drawRectCancel:(id)sender;

-(IBAction)drawEllipseDone:(id)sender;
-(IBAction)drawEllipseCancel:(id)sender;

-(IBAction)sliderValueChanged:(id)sender;
-(IBAction)sliderDragUp:(id)sender;
-(void)backgroundTap;
-(int)PDFOpen:(NSString *)path :(NSString *)pwd;
-(int)PDFOpenPage:(NSString *)path :(int)pageno : (float)x :(float)y :(NSString *)pwd;
//for test
-(int)PDFopenMem : (void *)data : (int)data_size :(NSString *)pwd;
-(int)PDFOpenStream :(id<PDFStream>)stream :(NSString *)password;

//-(int)openStream:(id<PDFStream>)stream : (NSString *)password;
-(BOOL)PDFGoto:(int)pageno;
-(void)PDFClose;
-(void)initbar :(int) pageno;
- (BOOL)isPortrait;
-(void)popself;
-(void)PDFThumbNailinit:(int) pageno;

//GEAR
- (void)moviePlayedDidFinish:(NSNotification *)notification;
//END
@end
