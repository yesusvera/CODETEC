//
//  LivroDetalhesView.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 25/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "LivroDetalhesView.h"
#import "AFHTTPRequestOperation.h"

@interface LivroDetalhesView ()

@end

@implementation LivroDetalhesView
@synthesize livroResponse, tituloLivro,fotoLivro;

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
    
    if(livroResponse){
        self.title = @"Detalhes";
        self.fotoLivro.image = [[UIImage alloc] initWithData:
                                [[NSData alloc]initWithContentsOfURL: [NSURL URLWithString:self.livroResponse.foto]] ];
        self.tituloLivro.text = livroResponse.titulo;
        downloadField.text = [livroResponse.arquivo stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)startDownload:(id)sender{
    NSURL *url = [NSURL URLWithString:downloadField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSString *saveFilename = [self downloadSavePathFor:url.lastPathComponent];
    
    NSLog(@"Salvando =o arquivo em %@", saveFilename);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:saveFilename append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, NSHTTPURLResponse *response) {
        [loadingIndicator stopAnimating];
        loadingIndicator.hidden = YES;
        
        progressBar.hidden = YES;
        loadingIndicator.hidden = YES;
        
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

-(NSString *) downloadSavePathFor:(NSString *) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:filename];
}

-(void) showMessage: (NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"OK" , nil];
    
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
