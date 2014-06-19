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
#import "GLB.h"
#import "SCSQLite.h"

@interface LivroDetalhesView ()

@end

@implementation LivroDetalhesView
NSMutableString *pdfName;
NSMutableString *pdfPath;
NSString *pdfFullPath;
int g_PDF_ViewMode = 0 ;
float g_Ink_Width = 2.0f;
float g_rect_Width = 2.0f;
float g_swipe_speed = 0.15f;
float g_swipe_distance=1.0f;
int g_render_quality = 1;
bool g_CaseSensitive = false;
bool g_MatchWholeWord = false;
bool g_DarkMode = false;
bool g_sel_right= false;
bool g_ScreenAwake = false;
uint g_ink_color = 0xFF000000;
uint g_rect_color = 0xFF000000;
NSUserDefaults *userDefaults;
@synthesize livroResponse, tituloLivro,fotoLivro,registrarDispositivoResponse;

// Função que abre o PDF pelo caminho especificado
-(IBAction)actionOpenPlainDocument:(id)sender{
    
    [self loadSettingsWithDefaults];
    
    RDPDFViewController *m_pdf;
    if( m_pdf == nil )
    {
        m_pdf = [[RDPDFViewController alloc] initWithNibName:@"RDPDFViewController"bundle:nil];
    }

    NSString *documentName = [livroResponse.arquivomobile.lastPathComponent stringByRemovingPercentEncoding];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

    NSString *fullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",documentName]];

    NSLog(@"Abrindo o arquivo: %@",fullPath);
    
    int result = [m_pdf PDFOpen:fullPath:@"ibracon%2014"];
    
    if(result == 1)
    {
        //m_pdf.hidesBottomBarWhenPushed = YES;
        //[self.navigationController pushViewController:m_pdf animated:YES];
        
        UINavigationController *nav = self.navigationController;
        m_pdf.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:m_pdf animated:YES];
        int pageno =1;
        // [m_pdf initbar:pageno];
        [m_pdf PDFThumbNailinit:pageno];
    }
}

- (void)loadSettingsWithDefaults
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    g_CaseSensitive = [userDefaults boolForKey:@"CaseSensitive"];
    g_MatchWholeWord = [userDefaults boolForKey:@"MatchWholeWord"];
    
    g_ScreenAwake = [userDefaults boolForKey:@"KeepScreenAwake"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:g_ScreenAwake];
    
    g_MatchWholeWord = [userDefaults floatForKey:@"MatchWholeWord"];
    g_CaseSensitive = [userDefaults floatForKey:@"CaseSensitive"];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    g_render_quality = [userDefaults integerForKey:@"RenderQuality"];
    if(g_render_quality == 0)
    {
        g_render_quality =1;
    }
    renderQuality = g_render_quality;
    
    defView = [userDefaults integerForKey:@"ViewMode"];
    g_ink_color = [userDefaults integerForKey:@"InkColor"];
    if(g_ink_color ==0)
    {
        g_ink_color =0xFF000000;
    }
    g_rect_color = [userDefaults integerForKey:@"RectColor"];
    if(g_rect_color==0)
    {
        g_rect_color =0xFF000000;
    }
    annotUnderlineColor = [userDefaults integerForKey:@"UnderlineColor"];
    if (annotUnderlineColor == 0) {
        annotUnderlineColor = 0xFF000000;
    }
    annotStrikeoutColor = [userDefaults integerForKey:@"StrikeoutColor"];
    if (annotStrikeoutColor == 0) {
        annotStrikeoutColor = 0xFF000000;
    }
    annotHighlightColor = [userDefaults integerForKey:@"HighlightColor"];
    if(annotHighlightColor ==0)
    {
        annotHighlightColor =0xFFFFFF00;
    }
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
    
    progressBar.hidden      = YES;
    loadingIndicator.hidden = YES;
    abrirPdf.hidden         = YES;
    if(livroResponse){
        self.title = @"Livro";
        if ([[UIImage alloc] initWithData:
            [[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:self.livroResponse.foto]] ] && ![livroResponse.tipoLivro isEqualToString:@"baixados"]) {
            
            self.fotoLivro.image = [[UIImage alloc] initWithData:
                                    [[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:self.livroResponse.foto]] ];
            
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
        
        self.tituloLivro.text = livroResponse.titulo;
        self.lblCodigoLoja.text = livroResponse.codigoloja;
        self.lblVersaoLivro.text = livroResponse.versao;

        livroResponse.arquivo = [livroResponse.arquivo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        //RETIRAR DEPOIS YESUS
       // downPdf.hidden = YES;
       // abrirPdf.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)startDownload:(id)sender{
    [self downloadFotoDoLivro:livroResponse.foto];
    [self downloadArquivo:livroResponse.arquivomobile];
    //[self downloadArquivo:livroResponse.indiceXML];
    
      }


-(void) downloadArquivo:(NSString *) urlLivroParaBaixar{
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
        
        //SALVANDO O LIVRO BAIXADO NO BANCO DE DADOS
        livroResponse.arquivomobile = saveFilename;
        
        /* Registro no portal do livro baixado */
        ConexaoRegistrarLivro *conexaoRegistrarLivro = [[ConexaoRegistrarLivro alloc]init];
        [conexaoRegistrarLivro registrarLivroBaixado:registrarDispositivoResponse comLivroResponse:livroResponse];
        
//        [GLB showMessage:@"Download finalizado com sucesso!"];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [GLB showMessage:
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
    NSURL *urlFoto = [NSURL URLWithString:urlFotoLivro];
    NSURLRequest *requestFoto = [NSURLRequest requestWithURL:urlFoto];
    NSString *saveFilenameFoto = [self downloadSavePathFor:urlFoto.lastPathComponent];
    
    NSLog(@"Salvando o arquivo em %@", saveFilenameFoto);
    
    AFHTTPRequestOperation *operationFoto = [[AFHTTPRequestOperation alloc] initWithRequest:requestFoto];
    
    operationFoto.outputStream = [NSOutputStream outputStreamToFileAtPath:saveFilenameFoto append:NO];
    
    [operationFoto setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, NSHTTPURLResponse *response) {
        //Salvando o path da foto no banco de dados
        livroResponse.foto = saveFilenameFoto;
        
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [GLB showMessage:
         [NSString stringWithFormat:@"Error no download da foto: %@", [error localizedDescription]]];
    }];
    
    [operationFoto start];
}

-(NSString *) downloadSavePathFor:(NSString *) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:filename];
}

- (BOOL)salvarAtualizarLivroBaixado:(LivroResponse *) livroBaixado{
    
    BOOL isSave = [SCSQLite executeSQL:@"insert into usuarios (codigoLivro, titulo, versao, codigoLoja, foto, arquivo, arquivomobile, indiceXML, tipoLivro) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", livroBaixado.codigolivro, livroBaixado.titulo, livroBaixado.versao, livroBaixado.codigoloja, livroBaixado.foto, livroBaixado.arquivo, livroBaixado.arquivomobile, livroBaixado.indiceXML, livroBaixado.tipoLivro];
    
    if (isSave) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }//else{
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro..." message:@"Erro ao salvar registro" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
       // [alert show];
    //}
    return isSave;
}


@end
