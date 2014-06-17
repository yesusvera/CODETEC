//
//  RDPDFViewController.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 14/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFIOS.h"
#import "PDFView.h"
#import <CoreData/CoreData.h>
@class PDFV;
@class PDFView;

@interface RDPDFViewController : UIViewController {
    
    PDFView *m_view;
    //PDF_DOC m_doc;
    PDFDoc *m_doc;
}

-(int)PDFOpen:(NSString *)path withPassword:(NSString *)pwd;
@end