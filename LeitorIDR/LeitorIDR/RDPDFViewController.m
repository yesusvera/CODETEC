#import "RDPDFViewController.h"

@interface RDPDFViewController ()


@end

@implementation RDPDFViewController
- (int)PDFOpen:(NSString *)path withPassword:(NSString *)pwd
{
    //    [self PDFClose];
    //    const char *cpath = [path UTF8String];
    //    PDF_ERR err = 0;
    //    const char *password = [pwd UTF8String];
    //    m_doc = Document_open(cpath, password, &err);
    //
    //    if( m_doc == NULL )
    //    {
    //        switch( err )
    //        {
    //            case err_password:
    //                return 2;
    //                break;
    //            default: return 0;
    //        }
    //    }
    //
    //    CGRect rect = [[UIScreen mainScreen]bounds];
    //
    //    float hi = self.navigationController.navigationBar.bounds.size.height;
    //    m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-20-hi)];
    //    [m_view vOpen:m_doc:self];
    //    [self.view addSubview:m_view];
    //    return 1;
    
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
    
    m_view = [[PDFView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-20-self.navigationController.navigationBar.bounds.size.height)];
    [m_view vOpen:m_doc :self];
    [self.view addSubview:m_view];
    return 1;
    
}

- (void)PDFClose
{
    //    if( m_view != nil )
    //    {
    //        [m_view vClose];
    //        [m_view removeFromSuperview];
    //        Document_close(m_doc);
    //    }
    
    if( m_view != nil )
    {
        [m_view vClose];
        [m_view removeFromSuperview];
        m_view = NULL;
    }
    m_doc = NULL;
}

- (void)OnPageChanged :(int)pageno{}
- (void)OnLongPressed:(float)x :(float)y{}
- (void)OnSingleTapped:(float)x :(float)y :(NSString *)text{}
- (void)OnTouchDown: (float)x :(float)y{}
- (void)OnTouchUp:(float)x :(float)y{}
- (void)OnSelEnd:(float)x1 :(float)y1 :(float)x2 :(float)y2{}
- (void)OnOpenURL:(NSString*)url{}
- (void)OnFound:(bool)found{}
- (void)OnMovie:(NSString *)fileName{}
- (void)OnSound:(NSString *)fileName{}

@end