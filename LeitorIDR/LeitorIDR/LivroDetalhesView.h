//
//  LivroDetalhesView.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 25/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivroResponse.h"
#import "RegistrarDispositivoResponse.h"
#import "ConexaoRegistrarLivro.h"
#import "EstanteResponse.h"
#import "RDPDFViewController.h"


@class MFDocumentManager;


@interface LivroDetalhesView : UIViewController{
    IBOutlet UITextField *downloadField;
    IBOutlet UIProgressView *progressBar;
    IBOutlet UIActivityIndicatorView *loadingIndicator;
    IBOutlet UILabel *tituloLivro;
    LivroResponse *livroResponse;
    __weak IBOutlet UIImageView *fotoLivro;
    IBOutlet UIButton *abrirPdf;
    IBOutlet UIButton *downPdf;
}

@property (weak, nonatomic) IBOutlet UIImageView *fotoLivro;
@property (nonatomic, retain) LivroResponse *livroResponse;
@property (nonatomic, retain) RegistrarDispositivoResponse *registrarDispositivoResponse;
@property (nonatomic, retain) UILabel *tituloLivro;
@property (weak, nonatomic) IBOutlet UILabel *lblVersaoLivro;
@property (weak, nonatomic) IBOutlet UILabel *lblCodigoLoja;
-(IBAction)startDownload:(id)sender;
-(IBAction)actionOpenPlainDocument:(NSString *)nomeArq;
-(void)salvarIndiceXMLNoLivro:(NSString *) urlIndiceXMLLivro;
@end
