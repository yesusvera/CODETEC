//
//  RDPDFViewController.m
//  PDFViewer
//
//  Created by Radaee on 12-10-29.
//  Copyright (c) 2012年 Radaee. All rights reserved.
//

#import "RDPDFViewController.h"
#import "PopupMenu.h"
#import "PDFVThumb.h"
@interface RDPDFViewController ()


@end

@implementation RDPDFViewController
@synthesize m_searchBar;
@synthesize drawLineToolBar;
@synthesize drawRectToolBar;
@synthesize toolBar;
@synthesize searchToolBar;
@synthesize window = _window;
@synthesize lineButton;
@synthesize sliderBar;
@synthesize pageNumLabel;
@synthesize pagenow;
@synthesize pagecount;
@synthesize  b_keyboard;

extern int g_PDF_ViewMode;
extern float g_Ink_Width;
extern float g_swipe_speed;
extern float g_swipe_distance;
extern int g_render_quality;
extern bool g_DarkMode;
extern bool  g_CaseSensitive;
extern bool g_MatchWholeWord;
extern bool g_sel_right;
extern bool g_ScreenAwake;
extern int g_render_quality;
extern NSUserDefaults *userDefaults;
extern int bookMarkNum;
extern NSMutableString *pdfName;
extern NSMutableString *pdfPath;
extern uint g_ink_color;
extern uint g_rect_color;
extern uint g_ellipse_color;
bool b_outline;
extern uint annotOvalColor;
- (void)createToolbarItems
{
    //toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"view_search.png"] style:UIBarStyleBlackOpaque target:self action:@selector(searchView:)];
    searchButton.width =30;
    UIBarButtonItem *lineButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_line.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawLine:)];
    lineButton.width =30;
    
    UIBarButtonItem *rectButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_rect.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawRect:)];
    rectButton.width =30;
    UIBarButtonItem *addBookMarkButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_mark.png"] style:UIBarStyleBlackOpaque target:self action:@selector(composeFile:)];
    addBookMarkButton.width = 30;
    UIBarButtonItem *viewMenuButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"view_menu.png"] style:UIBarStyleBlackOpaque target:self action:@selector(viewMenu:)];
    viewMenuButton.width =30;
    UIBarButtonItem *ellipseButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_ellipse.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawEllipse:)];
    ellipseButton.width =30;
    //UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    /*UIBarButtonItem *lockButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lock.png"] style:UIBarStyleBlackOpaque target:self action:@selector(lockView:)];
    lockButton.width = 30;
   */
    NSArray *toolbarItem = [[NSArray alloc]initWithObjects:searchButton,lineButton,rectButton,viewMenuButton,addBookMarkButton,ellipseButton,nil];
    [self.toolBar setItems:toolbarItem animated:NO];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self = [super initWithNibName:nil bundle:nil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    b_outline = false;
    b_findStart = NO;
    findString = nil;
    b_lock = NO;
    b_sigleTap =false;
    b_keyboard = false;
    popupMenu1 = [[PopupMenu alloc] init];
    tempfiles = [[NSMutableArray alloc]init];
    
    PopupMenuItem *item1 = [PopupMenuItem itemWithTitle:@"Copy" image:nil target:self action:@selector(Copy:)];
    item1.width = 40;
    
    PopupMenuItem *item2 = [PopupMenuItem itemWithTitle:@"Mark" image:nil target:self action:@selector(Mark:)];
    item1.width = 40;
    
    PopupMenuItem *item3 = [PopupMenuItem itemWithTitle:@"STO" image:nil target:self action:@selector(StrikeOut:)];
    item2.width =40;
    PopupMenuItem *item4 = [PopupMenuItem itemWithTitle:@"HL" image:nil target:self action:@selector(HighLight:)];
    item3.width=40;
    PopupMenuItem *item5 = [PopupMenuItem itemWithTitle:@"UDL" image:nil target:self action:@selector(UnderLine:)];
    item4.width =40;
    PopupMenuItem *item6 = [PopupMenuItem itemWithTitle:@"TA" image:nil target:self action:@selector(TextAnnot:)];
    item6.width = 40;
    //选择转到
    popupMenu1.items = [NSArray arrayWithObjects:item1,item5,item4,item3,item6,nil];

    m_bSel = false;
}
-(void)viewWillAppear:(BOOL)animated 
{
    
    toolBar = [UIToolbar new];
    [toolBar sizeToFit];
	//CGFloat toolbarHeight = [toolBar frame].size.height;
    b_findStart = NO;
	//CGRect mainViewBounds = self.view.bounds;
	[self createToolbarItems];
    self.navigationItem.titleView =toolBar;
    
    //GEAR
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayedDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //END
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(!b_outline)
    {
        [m_Thumbview vClose];
        [m_view vClose];
    }
    //delete temp files
    for(int i=0; i<[tempfiles count];i++)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[tempfiles objectAtIndex:i] error:nil];
        [tempfiles removeObjectAtIndex:i];
    }
    //GEAR
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //END
}

-(void)composeFile:(id)sender
{

    
    int pageno = 0;
    struct PDFV_POS pos;
    [m_view vGetPos:&pos];
    pageno = pos.pageno;
    float x = pos.x;
    float y = pos.y;
    NSString *tempFile; 
    NSString *tempName;
    tempName = [pdfName substringToIndex:pdfName.length-4];
    tempFile = [tempName stringByAppendingFormat:@"%d%@",pageno,@".bookmark"];
    NSString *tempPath;
    tempPath = [pdfPath stringByAppendingFormat:pdfName];
    NSString *fileContent = [NSString stringWithFormat:@"%@,%@,%d,%f,%f",tempPath,tempName,pageno,x,y];
    NSString *BookMarkDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *bookMarkFile = [BookMarkDir stringByAppendingPathComponent:tempFile];
    if(![[NSFileManager defaultManager]fileExistsAtPath:bookMarkFile])
    {
        [[NSFileManager defaultManager]createFileAtPath:bookMarkFile contents:nil attributes:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:bookMarkFile];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[fileContent dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"Add BookMark Success!", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2  delegate:self cancelButtonTitle:str3 otherButtonTitles:nil, nil];
        
        [alter show];
    }
    else {
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"BookMark Already Exist", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:str3 otherButtonTitles:nil, nil];
        [alter show];
    }
    
    

  // [m_view saveAs];

    
}
- (IBAction)searchView:(id) sender
{
    searchToolBar = [UIToolbar new];
    [searchToolBar sizeToFit];
    //searchToolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *nextbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"right_arrow.png"] style:UIBarStyleBlackOpaque target:self action:@selector(nextword:)];
    nextbutton.width =30;
    UIBarButtonItem *prevbutton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left_arrow.png"] style:UIBarStyleBlackOpaque target:self action:@selector(prevword:)];
    prevbutton.width =30;
    UIBarButtonItem *cancelbtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_remove.png"] style:UIBarStyleBlackOpaque target:self action:@selector(searchCancel:)];
    cancelbtn.width =30;

    NSArray *toolbarItem = [[NSArray alloc]initWithObjects:prevbutton,nextbutton,cancelbtn,nil];
    [self.searchToolBar setItems:toolbarItem animated:NO];
    self.navigationItem.titleView =searchToolBar;

    
    CGRect boundsc = [[UIScreen mainScreen]bounds];
    int cwidth = boundsc.size.width;
    NSString *iosversion =[[UIDevice currentDevice]systemVersion];
    if([[iosversion substringToIndex:1] isEqualToString:@"7"])
    {
        float hi = self.navigationController.navigationBar.bounds.size.height;
        m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, hi+20, cwidth, 41)];
    }
    else
    {
        m_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, cwidth, 41)];
    }
    m_searchBar.delegate = self;
    m_searchBar.barStyle =UIBarStyleBlackTranslucent;
    m_searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    m_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_searchBar.placeholder = @"Pesquisar";
    m_searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:m_searchBar];
    
}
- (IBAction)drawLine:(id) sender
{
  
    if(![m_view vInkStart])
    {
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"This Document is readonly", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:str3 otherButtonTitles:nil,nil];
        [alter show];
        return;
    }
    
    drawLineToolBar = [UIToolbar new];
    [drawLineToolBar sizeToFit];
    drawLineToolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *drawLineDoneBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_done.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawLineDone:)];
    drawLineDoneBtn.width =30;
    UIBarButtonItem *drawLineCancelBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_remove.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawLineCancel:)];
    drawLineCancelBtn.width =30;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    
    NSArray *toolbarItem = [[NSArray alloc]initWithObjects:drawLineDoneBtn,spacer,drawLineCancelBtn,nil];
    [self.drawLineToolBar setItems:toolbarItem animated:NO];
    self.navigationItem.titleView =drawLineToolBar;
}
-(IBAction)drawLineDone:(id)sender
{
    [m_view vInkEnd];
    [drawLineToolBar removeFromSuperview];
    self.navigationItem.titleView =toolBar;
}
-(IBAction)drawLineCancel:(id)sender
{
    [drawLineToolBar removeFromSuperview];
    self.navigationItem.titleView =toolBar;
    [m_view vInkCancel];
}

- (IBAction)drawRect:(id) sender
{
    
    if(![m_view vRectStart])    
    {
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"This Document is readonly", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:str3 otherButtonTitles:nil,nil];
        [alter show];
        return;
    }
    
    drawRectToolBar = [UIToolbar new];
    [drawRectToolBar sizeToFit];
    drawRectToolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *drawLineDoneBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_done.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawRectDone:)];
    drawLineDoneBtn.width =30;
    UIBarButtonItem *drawLineCancelBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_remove.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawRectCancel:)];
    drawLineCancelBtn.width =30;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    
    NSArray *toolbarItem = [[NSArray alloc]initWithObjects:drawLineDoneBtn,spacer,drawLineCancelBtn,nil];
    [self.drawRectToolBar setItems:toolbarItem animated:NO];
    self.navigationItem.titleView =drawRectToolBar;
}
-(IBAction)drawRectDone:(id)sender
{
    
    [m_view vRectEnd];
    [drawRectToolBar removeFromSuperview];
    self.navigationItem.titleView =toolBar;
}
-(IBAction)drawRectCancel:(id)sender
{
    [drawRectToolBar removeFromSuperview];
    self.navigationItem.titleView =toolBar;
    [m_view vRectCancel];
}
- (IBAction)drawEllipse:(id) sender
{
    
    if(![m_view vEllipseStart])
    {
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"This Document is readonly", @"Localizable");
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:str3 otherButtonTitles:nil,nil];
        [alter show];
        return;
    }
    
    drawRectToolBar = [UIToolbar new];
    [drawRectToolBar sizeToFit];
    drawRectToolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *drawLineDoneBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_done.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawEllipseDone:)];
    drawLineDoneBtn.width =30;
    UIBarButtonItem *drawLineCancelBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_remove.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawEllipseCancel:)];
    drawLineCancelBtn.width =30;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    
    NSArray *toolbarItem = [[NSArray alloc]initWithObjects:drawLineDoneBtn,spacer,drawLineCancelBtn,nil];
    [self.drawRectToolBar setItems:toolbarItem animated:NO];
    self.navigationItem.titleView =drawRectToolBar;
}
-(IBAction)drawEllipseDone:(id)sender
{
    
    [m_view vEllipseEnd];
    [drawRectToolBar removeFromSuperview];
    self.navigationItem.titleView =toolBar;
}
-(IBAction)drawEllipseCancel:(id)sender
{
    [drawRectToolBar removeFromSuperview];
    self.navigationItem.titleView =toolBar;
    [m_view vEllipseCancel];
}
- (IBAction)viewMenu:(id) sender
{
    
    b_outline =true;
    PDFOutline *root = [m_doc rootOutline];
    if( root )
    {
        outlineView = [[OutLineViewController alloc] initWithNibName:@"OutLineViewController" bundle:nil];
        //First parameter is root node
        [outlineView setList:m_doc :NULL :root];
        UINavigationController *nav = self.navigationController;
        outlineView.hidesBottomBarWhenPushed = YES;
        [outlineView setJump:self];
        [nav pushViewController:outlineView animated:YES];
    }
 
        
}
-(IBAction)lockView:(id)sender
{
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"view_search.png"] style:UIBarStyleBlackOpaque target:self action:@selector(searchView:)];
    searchButton.width =30;
    UIBarButtonItem *lineButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_line.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawLine:)];
    lineButton.width =30;
    
    UIBarButtonItem *rectButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"annot_rect.png"] style:UIBarStyleBlackOpaque target:self action:@selector(drawRect:)];
    rectButton.width =30;
    UIBarButtonItem *addBookMarkButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_mark.png"] style:UIBarStyleBlackOpaque target:self action:@selector(composeFile:)];
    addBookMarkButton.width = 30;
    UIBarButtonItem *viewMenuButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"view_menu.png"] style:UIBarStyleBlackOpaque target:self action:@selector(viewMenu:)];
    viewMenuButton.width =30;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    UIBarButtonItem *lockButton;
    if(b_lock)
    {
    
        lockButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lock.png"] style:UIBarStyleBlackOpaque target:self action:@selector(lockView:)];
    }
    else {
        lockButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lock.png"] style:UIBarStyleBlackTranslucent target:self action:@selector(lockView:)];        }
    
    lockButton.width = 30;
    
    NSArray *toolbarItem = [[NSArray alloc]initWithObjects:searchButton,spacer,lineButton, spacer,rectButton,spacer,viewMenuButton,spacer,addBookMarkButton,spacer,lockButton,nil];
    [self.toolBar setItems:toolbarItem animated:NO];
    self.navigationItem.titleView =toolBar;
    b_lock = !b_lock;
    [m_view vLockSide:b_lock];
}

- (void)viewDidUnload
{
    NSLog(@"PDFView Unload");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOrientation" object:nil];
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect rect =[[UIScreen mainScreen]bounds];
    if ([self isPortrait])
    {
        if (rect.size.height < rect.size.width) {
            
            float height = rect.size.height;
            rect.size.height = rect.size.width;
            rect.size.width = height;
        }
    }
    else
    {
        if (rect.size.height > rect.size.width) {
            
            float height = rect.size.height;
            rect.size.height = rect.size.width;
            rect.size.width = height;
        }
    }
    
    [m_view setFrame:rect];
    [m_view sizeThatFits:rect.size];
    [self.toolBar sizeToFit];
    
    CGRect boundsc = [[UIScreen mainScreen]bounds];
    int cwidth = boundsc.size.width;
    int cheight = boundsc.size.height;
    
    if ([self isPortrait]) {
        if (cwidth > cheight) {
            cwidth = cheight;
            cheight = boundsc.size.width;
        }
    }
    else
    {
        if (cwidth < cheight) {
            cwidth = cheight;
            cheight = boundsc.size.width;
        }
    }
    float hi = self.navigationController.navigationBar.bounds.size.height;
    NSString *iosversion =[[UIDevice currentDevice]systemVersion];
    if([[iosversion substringToIndex:1] isEqualToString:@"7"])
    {
        [m_Thumbview setFrame:CGRectMake(0, cheight-50, cwidth, 50)];
        [m_Thumbview sizeThatFits:CGRectMake(0, cheight-50, cwidth, 50).size];
        [m_searchBar setFrame:CGRectMake(0,hi+20,cwidth,41)];
    }
    else
    {
        [m_Thumbview setFrame:CGRectMake(0, cheight-hi-50-20, cwidth, 50)];
        [m_Thumbview sizeThatFits:CGRectMake(0, cheight-hi-50-20, cwidth, 50).size];
        [m_searchBar setFrame:CGRectMake(0, 0, cwidth, 41)];
    }
   [m_Thumbview refresh];
}
- (IBAction)sliderAction:(id)sender
{
	//UISlider* durationSlider = sender;
}

-(int)PDFOpen:(NSString *)path : (NSString *)pwd
{
    
    [self PDFClose];
    PDF_ERR err = 0;
    m_doc = [[PDFDoc alloc] init];
    err = [m_doc open:path :pwd];
    
    switch( err )
    {
    case err_ok:
        break;
    case err_password:
        return 2;
        break;
    default: return 0;
    }
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    //GEAR
    if (![self isPortrait] && rect.size.width < rect.size.height) {
        float height = rect.size.height;
        rect.size.height = rect.size.width;
        rect.size.width = height;
    }
    //END
    float hi = self.navigationController.navigationBar.bounds.size.height;
    NSString *iosversion =[[UIDevice currentDevice]systemVersion];
    
    if([iosversion integerValue]>=7)
    {
        m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    }
    else
    {
        m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-20-44)];
    }
    [m_view vOpen:m_doc: self];
    pagecount =[m_doc pageCount];
    [self.view addSubview:m_view];
    m_bSel = false;
    return 1;
}
-(int)PDFOpenStream:(id<PDFStream>)stream :(NSString *)password
{
    [self PDFClose];
    PDF_ERR err = 0;
    m_doc = [[PDFDoc alloc] init];
   // err = [m_doc open:path :pwd];
    err = [m_doc openStream:stream :password];
    switch( err )
    {
        case err_ok:
            break;
        case err_password:
            return 2;
            break;
        default: return 0;
    }
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    //GEAR
    if (![self isPortrait] && rect.size.width < rect.size.height) {
        float height = rect.size.height;
        rect.size.height = rect.size.width;
        rect.size.width = height;
    }
    //END
    float hi = self.navigationController.navigationBar.bounds.size.height;
    NSString *iosversion =[[UIDevice currentDevice]systemVersion];
    
    if([iosversion integerValue]>=7)
    {
        m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    }
    else
    {
        m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-20-44)];
    }
    [m_view vOpen:m_doc: self];
    pagecount =[m_doc pageCount];
    [self.view addSubview:m_view];
    m_bSel = false;
    return 1;
}

-(int)PDFopenMem : (void *)data : (int)data_size :(NSString *)pwd
{
    [self PDFClose];
    PDF_ERR err = 0;
    m_doc = [[PDFDoc alloc] init];
    err = [m_doc openMem:data :data_size :pwd];
    switch( err )
    {
        case err_ok:
        break;
        case err_password:
        return 2;
        break;
        default: return 0;
    }
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    //GEAR
    if (![self isPortrait] && rect.size.width < rect.size.height) {
        float height = rect.size.height;
        rect.size.height = rect.size.width;
        rect.size.width = height;
    }
    //END
    float hi = self.navigationController.navigationBar.bounds.size.height;
    NSString *iosversion =[[UIDevice currentDevice]systemVersion];
    
    if([iosversion integerValue]>=7)
    {
        m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    }
    else
    {
        m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-20-44)];
    }
    [m_view vOpen:m_doc: self];
    pagecount =[m_doc pageCount];
    [self.view addSubview:m_view];
    m_bSel = false;
    return 1;
}


-(void)PDFThumbNailinit:(int)pageno
{
   
    CGRect boundsc = [[UIScreen mainScreen]bounds];
    if (![self isPortrait] && boundsc.size.width < boundsc.size.height) {
        float height = boundsc.size.height;
        boundsc.size.height = boundsc.size.width;
        boundsc.size.width = height;
    }
    
    int cwidth = boundsc.size.width;
    int cheight = boundsc.size.height;
    
    
    float hi = self.navigationController.navigationBar.bounds.size.height;
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    //m_Thumbview = [[PDFVThumb alloc] initWithFrame:CGRectMake(0, cheight-hi-50-20, cwidth, 50)];
    //根据iosversion判断
    NSString *iosversion =[[UIDevice currentDevice]systemVersion];
    if([[iosversion substringToIndex:1] isEqualToString:@"7"])
    {
        m_Thumbview = [[PDFVThumb alloc] initWithFrame:CGRectMake(0, cheight-50, cwidth, 50)];
        pageNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+hi+1, 65, 30)];
    }
    else{
        m_Thumbview = [[PDFVThumb alloc] initWithFrame:CGRectMake(0, cheight-hi-50-20, cwidth, 50)];
        pageNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65, 30)];
    }
    [m_Thumbview vOpenThumb:m_doc];
    //[m_Thumbview sizeThatFits:CGRectMake(0, cheight-180, cwidth, 110).size];
    [self.view addSubview:m_Thumbview];
    
    pagenow = pageno;
     

    
    pageNumLabel.backgroundColor = [UIColor colorWithRed:1.5 green:1.5 blue:1.5 alpha:0.2];
    
    pageNumLabel.textColor = [UIColor whiteColor];
    pageNumLabel.adjustsFontSizeToFitWidth = YES;
    pageNumLabel.textAlignment= UITextAlignmentCenter;
    pageNumLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    pageNumLabel.layer.cornerRadius = 10;
    NSString *pagestr = [[NSString alloc]initWithFormat:@"%d/",pagecount];
    pagestr = [pagestr stringByAppendingFormat:@"%d",pagecount];    
    pageNumLabel.text = pagestr;
    pageNumLabel.font = [UIFont boldSystemFontOfSize:16];
    pageNumLabel.shadowColor = [UIColor grayColor];
    pageNumLabel.shadowOffset = CGSizeMake(1.0,1.0);
    [self.view addSubview:pageNumLabel];
    //pageNumLabel.setNeedsDisplay;
    [m_Thumbview vSetDelegate:self];
    [pageNumLabel setHidden:NO];
    
}


-(void)initbar :(int) pageno
{
    CGRect boundsc = [[UIScreen mainScreen]bounds];
    if (![self isPortrait] && boundsc.size.width < boundsc.size.height) {
        float height = boundsc.size.height;
        boundsc.size.height = boundsc.size.width;
        boundsc.size.width = height;
    }
    
    int cwidth = boundsc.size.width;
    int cheight = boundsc.size.height;
    
    sliderBar = [[UISlider alloc]initWithFrame:CGRectMake(20, cheight-100, cwidth-30, 10)];
    pagecount = [m_doc pageCount];
    sliderBar.maximumValue = pagecount; //The Biggest Page Number
    sliderBar.minimumValue = 1;//The Littlest Page Number
    [self.view addSubview:sliderBar];
    [sliderBar setHidden:NO];
    [sliderBar addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [sliderBar addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)PDFGoto:(int)pageno
{
    [m_view vGoto:pageno];
}

-(int)PDFOpenPage:(NSString *)path :(int)pageno :(float)x :(float)y :(NSString *)pwd
{
   
    PDF_ERR err = 0;
    err = [m_doc open:path :pwd];
    switch( err )
    {
    case err_ok:
        break;
    case err_password:
        return 2;
        break;
    default: return 0;
    }

    CGRect rect = [[UIScreen mainScreen]bounds];
    //GEAR
    if (![self isPortrait] && rect.size.width < rect.size.height) {
        float height = rect.size.height;
        rect.size.height = rect.size.width;
        rect.size.width = height;
    }
    //END
    m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-20-self.navigationController.navigationBar.bounds.size.height)];
    [m_view vOpenPage:m_doc :pageno :x :y :self];
    pagecount = [m_doc pageCount];
    [self.view addSubview:m_view];
    return 1;
}
-(IBAction)sliderValueChanged:(id)sender
{
    pagenow = (int)round(sliderBar.value);
    NSString *pagestr = [[NSString alloc]initWithFormat:@"%d/",pagenow];
    pagestr = [pagestr stringByAppendingFormat:@"%d",pagecount];
    pageNumLabel.text = pagestr;
    
}
-(IBAction)sliderDragUp:(id)sender
{
    pagenow = (int)round(sliderBar.value);
    [m_view vGoto:pagenow - 1];
    NSString *pagestr = [[NSString alloc]initWithFormat:@"%d/",pagenow];
    pagestr = [pagestr stringByAppendingFormat:@"%d",pagecount];
}

-(void)PDFClose
{
    if( m_view != nil )
    {
        [m_view vClose];
        [m_view removeFromSuperview];
        m_view = NULL;
    }
    m_doc = NULL;
}
//Add Call Search API
- (void)searchBarSearchButtonClicked:(UISearchBar *)m_SearchBar
{
    float hi = self.navigationController.navigationBar.bounds.size.height;
    NSString *iosversion =[[UIDevice currentDevice]systemVersion];
    CGRect boundsc = [[UIScreen mainScreen]bounds];
    int cwidth = boundsc.size.width;
    if([[iosversion substringToIndex:1] isEqualToString:@"7"])
    {
        [m_searchBar setFrame:CGRectMake(0,hi+20,cwidth,41)];
    }
    else
    {
        [m_searchBar setFrame:CGRectMake(0,0,cwidth,41)];
    }
    NSString *text = m_SearchBar.text;
    [m_SearchBar resignFirstResponder];
    if (m_SearchBar.text.length >40)
    {
        return ;
    }
    if(!b_findStart)
    {
        findString =text;
        [m_view vFindStart:text :g_CaseSensitive :g_MatchWholeWord];
        b_findStart = YES;
        [m_view vFind:1];
    }
    else if(text != nil && text.length > 0)
    {
        bool stringCmp =false;
        if( findString != NULL )
        {
            if(g_CaseSensitive == true)
                stringCmp=[text compare:findString] == NSOrderedSame;
            else
                stringCmp=[text caseInsensitiveCompare:findString] == NSOrderedSame;
        }
        if( !stringCmp )
        {
            [m_view vFindStart:text :g_CaseSensitive :g_MatchWholeWord];
            findString =text;
        }
        [m_view vFind:1];
    }
}
-(IBAction)prevword:(id)sender
{
    NSString *text = m_searchBar.text;
    [m_searchBar resignFirstResponder];
    if (m_searchBar.text.length >40)
    {
        return ;
    }
    if(!b_findStart)
    {
        findString =text;
        [m_view vFindStart:text :g_CaseSensitive :g_MatchWholeWord];
        b_findStart = YES;
        [m_view vFind:-1];
    }
    else if(text != nil && text.length > 0)
    {
        bool stringCmp =false;
        if( findString != NULL )
        {
            if(g_CaseSensitive == true)
                stringCmp=[text compare:findString] == NSOrderedSame;
            else
                stringCmp=[text caseInsensitiveCompare:findString] == NSOrderedSame;
        }
        if( !stringCmp )
        {
            [m_view vFindStart:text :g_CaseSensitive :g_MatchWholeWord];
            findString =text;
        }
        [m_view vFind:-1];
    }
}

-(IBAction)nextword:(id)sender
{
    NSString *text = m_searchBar.text;
    [m_searchBar resignFirstResponder];
    int len = text.length;
    if (m_searchBar.text.length >40)
    {
        return ;
    }
    if(!b_findStart)
    {
        findString =text;
        [m_view vFindStart:text :g_CaseSensitive :g_MatchWholeWord];
        b_findStart = YES;
        [m_view vFind:1];
    }
    else if(text != nil && text.length > 0)
    {
        bool stringCmp =false;
        if( findString != NULL )
        {
            if(g_CaseSensitive == true)
                stringCmp=[text compare:findString] == NSOrderedSame;
            else
                stringCmp=[text caseInsensitiveCompare:findString] == NSOrderedSame;
        }
        if( !stringCmp )
        {
            [m_view vFindStart:text :g_CaseSensitive :g_MatchWholeWord];
            findString =text;
        }
        [m_view vFind:1];
    }
}

-(IBAction)searchCancel:(id)sender
{
    [m_searchBar resignFirstResponder];
    [m_searchBar removeFromSuperview];
        self.navigationItem.titleView =toolBar;
    findString = nil;
    [m_view vFindEnd];
    b_findStart = NO;
    m_searchBar = NULL;
}

- (void)OnPageChanged:(int)pageno
{
    //struct PDFV_POS pos;
    //[m_view vGetPos:&pos];
    //GEAR
    //pageno = pos.pageno + 1;
    //END
    //float x = pos.x;
    //float y = pos.y;
    //if(pageno == pagecount -1) pageno = pagecount;
    [m_Thumbview vGoto:pageno];
    pageno++;
   // sliderBar.value = pageno;
    NSString *pagestr = [[NSString alloc]initWithFormat:@"%d/",pageno];
    pagestr = [pagestr stringByAppendingFormat:@"%d",pagecount];
    pageNumLabel.text = pagestr;
    

}
-(void)PDFVThumbOnPageClicked:(int)pageno
{
    [m_view vGoto:pageno];
}

-(void)OnSelEnd: (float)x1 :(float)y1 :(float)x2 :(float)y2
{
    float scale = [[UIScreen mainScreen] scale];
    if (m_bSel) {
        NSString *s = [m_view vSelGetText]; //图片文档不弹出
        if(s)
        {
            [popupMenu1 showInView:m_view atPoint:CGPointMake(x1/scale, y1/scale)];//popup a menu.
            posx = (int)x2;
            posy = (int)y2;
        }
        
    }
}

-(void)OnLongPressed:(float)x :(float)y
{
    [m_view vSelStart];//start to select
    m_bSel = true;
}

-(void)OnFound:(bool)found
{
    /*
    if( !found )//todo: show alert dialog
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waring" message:@"Find Over" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
   */
}

-(void)OnSingleTapped:(float)x :(float)y :(NSString *)text
{
    [m_searchBar resignFirstResponder];
    //根据iosversion判断
    NSString *iosversion =[[UIDevice currentDevice]systemVersion];
    if([[iosversion substringToIndex:1] isEqualToString:@"7"])
    {
        //ios7版本
        if(m_Thumbview.hidden)
        {
            m_Thumbview.hidden = NO;
            [self.pageNumLabel setHidden:false];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [m_searchBar setHidden:NO];
        }
        else
        {
            m_Thumbview.hidden =YES;
            [self.pageNumLabel setHidden:true];
           //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
           [[UIApplication sharedApplication] setStatusBarHidden:YES];
           // BOOL navBarState = [self.navigationController isNavigationBarHidden];
            //Set the navigationBarHidden to the opposite of the current state.
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [m_searchBar resignFirstResponder];
            [m_searchBar setHidden:YES];
            //[self.navigationController setToolbarHidden:!navBarState animated:YES];
            
        }
        b_outline = true;
        m_bSel = false;
        [m_view vSelEnd];
    }
    else
    {
        if(m_Thumbview.hidden)
        {
            m_Thumbview.hidden = NO;
            [self.pageNumLabel setHidden:false];
        }
        else
        {
            m_Thumbview.hidden =YES;
            [self.pageNumLabel setHidden:true];
        }
        b_outline = true;
        m_bSel = false;
        [m_view vSelEnd];
    }
    
    if([text length]>0)
    {
        textAnnotVC = [[TextAnnotViewController alloc]init];
        [textAnnotVC setPos_x:posx];
        [textAnnotVC setDelegate:self];
        [textAnnotVC setPos_y:posy];
        [textAnnotVC setText:text];
        textAnnotVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UINavigationController *navController = [[UINavigationController alloc]
                                                 initWithRootViewController:textAnnotVC];
        [navController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentModalViewController:navController animated:YES];
    }
    
}

-(void)OnTouchDown: (float)x :(float)y;
{
    [popupMenu1 dismiss];
    [popupMenu2 dismiss];
    if(m_bSel)
    {
        m_bSel = false;
        [m_view vSelEnd];
    }
}
-(void)OnTouchUp: (float)x :(float)y 
{
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)m_searchBar
{
    b_keyboard = true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)isPortrait
{
    return ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait ||
            [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown);
}

//PopupView action
- (void)OnOpenURL:(NSString*)url
{
    if( url )//open URI
    {
        nuri = url;
        NSString *str1=NSLocalizedString(@"Alert", @"Localizable");
        NSString *str2=NSLocalizedString(@"Do you want to open:", @"Localizable");
        NSString *message = [str2 stringByAppendingFormat:url];
        NSString *str3=NSLocalizedString(@"OK", @"Localizable");
        NSString *str4=NSLocalizedString(@"Cancel", @"Localizable");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:str1 message:message delegate:self cancelButtonTitle:str3 otherButtonTitles:str4, nil];
        [alter show];
        return;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:nuri]];
    }
}
-(void)Mark :(id)sender
{
    [popupMenu1 dismiss];
    [popupMenu2 showInView:m_view atPoint:CGPointMake(end_x/2, end_y/2)];
}
-(void)Copy :(id)sender
{
    
    NSString* s = [m_view vSelGetText];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = s;
    //NSLog(@"%@",s);
    [popupMenu1 dismiss];
    if(m_bSel)
    {
        m_bSel = false;
        [m_view vSelEnd];
    }
}
-(void)StrikeOut :(id)sender
{
    //2删除线
    [m_view vSelMarkup:annotUnderlineColor :2];
    [popupMenu1 dismiss];
    if(m_bSel)
    {
        m_bSel = false;
        [m_view vSelEnd];
    }
}

-(void)HighLight :(id)sender
{
    //0高亮
    [m_view vSelMarkup:annotUnderlineColor :0];
    [popupMenu1 dismiss];
    if(m_bSel)
    {
        m_bSel = false;
        [m_view vSelEnd];
    }
}
-(void)UnderLine :(id)sender
{
     //1下划线
    [m_view vSelMarkup:annotUnderlineColor :1];
    [popupMenu1 dismiss];
    if(m_bSel)
    {
        m_bSel = false;
        [m_view vSelEnd];
    }
}
-(void)TextAnnot :(id)sender
{
    
    m_bSel = false;
    b_outline = true;
    [m_view vSelEnd];
    NSString* text = [m_view vGetTextAnnot:posx :posy];
    textAnnotVC = [[TextAnnotViewController alloc]init];
    [textAnnotVC setPos_x:posx];
    [textAnnotVC setDelegate:self];
    [textAnnotVC setPos_y:posy];
    [textAnnotVC setText:text];
    textAnnotVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:textAnnotVC];
    
    [navController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentModalViewController:navController animated:YES];
}
-(void)OnSaveTextAnnot:(NSString *)textAnnot
{
    [m_view vAddTextAnnot:posx :posy :textAnnot];
}
//This is a delegate function ,when tap the media annot in pdf file
//will generate a temp file,fileName is temp media path
- (void)OnMovie:(NSString *)fileName
{
    [tempfiles addObject:fileName];
 //GEAR
    NSURL *urlPath = [NSURL fileURLWithPath:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:urlPath];
        mpvc.view.frame = self.view.bounds;
        mpvc.modalPresentationStyle = UIModalPresentationFormSheet;

        [self presentMoviePlayerViewControllerAnimated:mpvc];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find media file" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
//END
}

//GEAR
- (void)moviePlayedDidFinish:(NSNotification *)notification
{
    //movie player exit with error
    if ([[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue] == MPMovieFinishReasonPlaybackError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unsupported format" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
//END
    
- (void)OnSound:(NSString *)fileName
{
    [tempfiles addObject:fileName];
    
    //
    //open media file
    //
}
//End PopupView action
@end
