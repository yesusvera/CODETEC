//
//  LivroDetalhesView.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 25/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "LivroDetalhesView.h"
#import "AFHTTPRequestOperation.h"
#import "ConexaoRegistrarLivro.h"
#import "ConexaoBuscarEstante.h"
#import "MFDocumentManager.h"
#import "ReaderViewController.h"

@interface LivroDetalhesView ()

@end

@implementation LivroDetalhesView
@synthesize livroResponse, tituloLivro,fotoLivro,estanteResponse;


// METODO PARA ESCONDER A LOGO DO FASTPDFKIT, SO FUNCIONA COM LICENÇA PAGA.
//- (void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    [self.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
//        if ([view isKindOfClass:[UIImageView class]]) {
//            view.hidden = YES;
//        }
//    }];
//}

// Função que abre o PDF pelo caminho especificado
-(IBAction)actionOpenPlainDocument:(id)sender{
    
    /** Set document name */
    // RENOMEANDO TEMPORARIAMENTE DE .IDR PARA .PDF
    NSString *documentName = [[livroResponse.arquivo.lastPathComponent stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@".idr" withString:@".pdf"];
    
    /** Get temporary directory to save thumbnails */
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    /** Set thumbnails path */
    NSString *thumbnailsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",documentName]];
    
    /** Get document from the App Bundle IDR*/
    NSURL *documentUrl = [NSURL fileURLWithPath:thumbnailsPath isDirectory:NO];
    
    /** Instancing the documentManager */
	MFDocumentManager *documentManager = [[MFDocumentManager alloc]initWithFileUrl:documentUrl];
    
	/** Instancing the readerViewController */
    ReaderViewController *pdfViewController = [[ReaderViewController alloc]initWithDocumentManager:documentManager];
    
    /** Set resources folder on the manager */
    documentManager.resourceFolder = thumbnailsPath;
    
    /** Set document id for thumbnail generation */
    pdfViewController.documentId = documentName;
	/** Present the pdf on screen in a modal view */
    
    [self presentViewController:pdfViewController animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    progressBar.hidden = YES;
    loadingIndicator.hidden = YES;
    abrirPdf.hidden = YES;
    if(livroResponse){
        self.title = @"Detalhes";
        if ([[UIImage alloc] initWithData:
            [[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:self.livroResponse.foto]] ] && ![livroResponse.tipoLivro isEqualToString:@"baixados"]) {
            self.fotoLivro.image = [[UIImage alloc] initWithData:
                                    [[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:self.livroResponse.foto]] ];
            self.tituloLivro.text = livroResponse.titulo;
        }else if([livroResponse.tipoLivro isEqualToString:@"baixados"]){
            self.fotoLivro.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfFile: [self downloadSavePathFor:self.livroResponse.foto.lastPathComponent]]];
            downPdf.hidden = YES;
            abrirPdf.hidden = NO;
            self.tituloLivro.text = livroResponse.titulo;
        }else{
            downPdf.hidden = YES;
            abrirPdf.hidden = YES;
            self.tituloLivro.text = @"";
        }
        livroResponse.arquivo = [livroResponse.arquivo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)startDownload:(id)sender{
   
    
    [self downloadDoLivro:livroResponse.arquivo];
    
    [self downloadFotoDoLivro:livroResponse.foto];
    
    ConexaoRegistrarLivro *conexaoRegistrarLivro = [[ConexaoRegistrarLivro alloc]init];
    [conexaoRegistrarLivro registrarLivroBaixado:self.registroDispositivoResponse comLivroResponse:livroResponse];
    // Falta sobrepor a estante e manter o vaor do registrarLivroResponse
    //if([conexaoRegistrarLivro.registrarLivroResponse.erro isEqualToString:@"0"]){
        ConexaoBuscarEstante *conexaoBuscarEstante = [[ConexaoBuscarEstante alloc]init];
        self.estanteResponse = [conexaoBuscarEstante conectarObterEstanteLocal:self.registroDispositivoResponse];
    //}
}


-(void) downloadDoLivro:(NSString *) urlLivroParaBaixar{
    NSURL *urlLivro = [NSURL URLWithString:urlLivroParaBaixar];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlLivro];
    NSString *saveFilename = [self downloadSavePathFor:urlLivro.lastPathComponent];
    
    NSLog(@"Salvando o arquivo em %@", saveFilename);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:saveFilename append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, NSHTTPURLResponse *response) {
        [loadingIndicator stopAnimating];
        loadingIndicator.hidden = YES;
        
        progressBar.hidden = YES;
        loadingIndicator.hidden = YES;
        downPdf.hidden = YES;
        abrirPdf.hidden = NO;
        
        [self showMessage:@"Download finalizado com sucesso!"];
        
        
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [self showMessage:
         [NSString stringWithFormat:@"Error no download: %@", [error localizedDescription]]];
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger read, long long totalRead, long long totalExpected) {
        progressBar.progress = (float)totalRead / (float)totalExpected;
    }];
    
    progressBar.hidden = NO;
    loadingIndicator.hidden = NO;
    
    [loadingIndicator startAnimating];
    
    [operation start];
}


-(void) downloadFotoDoLivro:(NSString *) urlFotoLivro{
    //DOWNLOAD DA FOTO DO LIVRO
    NSURL *urlFoto = [NSURL URLWithString:urlFotoLivro];
    NSURLRequest *requestFoto = [NSURLRequest requestWithURL:urlFoto];
    NSString *saveFilenameFoto = [self downloadSavePathFor:urlFoto.lastPathComponent];
    
    NSLog(@"Salvando o arquivo em %@", saveFilenameFoto);
    
    AFHTTPRequestOperation *operationFoto = [[AFHTTPRequestOperation alloc] initWithRequest:requestFoto];
    
    operationFoto.outputStream = [NSOutputStream outputStreamToFileAtPath:saveFilenameFoto append:NO];
    
    [operationFoto setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, NSHTTPURLResponse *response) {
        
        
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [self showMessage:
         [NSString stringWithFormat:@"Error no download da foto: %@", [error localizedDescription]]];
    }];
    
    [operationFoto start];
}

-(NSString *) downloadSavePathFor:(NSString *) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:filename];
}

-(void) showMessage: (NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:message delegate:nil cancelButtonTitle:@"Cancelar" otherButtonTitles:@"OK" , nil];
    
    [alert show];
    
}

-(NSString *)urlEncodeUsingEncoding:(NSString *)unencodedString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)unencodedString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}


@end
