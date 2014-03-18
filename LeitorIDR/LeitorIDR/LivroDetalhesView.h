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
    EstanteResponse *estanteResponse;
}

@property (weak, nonatomic) IBOutlet UIImageView *fotoLivro;
-(IBAction)startDownload:(id)sender;
@property (nonatomic, retain) LivroResponse *livroResponse;
@property (nonatomic, retain) RegistrarDispositivoResponse *registroDispositivoResponse;
@property (nonatomic, retain) EstanteResponse *estanteResponse;
@property (nonatomic, retain) UILabel *tituloLivro;
-(IBAction)actionOpenPlainDocument:(NSString *)nomeArq;
@end
