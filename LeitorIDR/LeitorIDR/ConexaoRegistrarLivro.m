//
//  ConexaoRegistrarLivro.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 06/03/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "ConexaoRegistrarLivro.h"
#import "AFHTTPRequestOperationManager.h"

@implementation ConexaoRegistrarLivro
@synthesize registrarLivroResponse;

//-(id)init{
//    self = [super init];
//    if(self){
//        registrarLivroResponse = [[RegistrarLivroResponse alloc]init];
//    }
//    
//    return self;
//}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"response"]){
        //return;
        registrarLivroResponse = [[RegistrarLivroResponse alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(!valorElementoAtual)
    {
        valorElementoAtual = [[NSMutableString alloc]initWithString:string];
    }
    else
    {
        [valorElementoAtual appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"response"] || [elementName isEqualToString:@"livro"]){
        return;
    } else if([elementName isEqualToString:@"codigolivro"]){
        [registrarLivroResponse setCodLivro:valorElementoAtual];
    }else if([elementName isEqualToString:@"status"]){
        [registrarLivroResponse setStatus:valorElementoAtual];
    }else if([elementName isEqualToString:@"erro"]){
        [registrarLivroResponse setErro:valorElementoAtual];
    }else if([elementName isEqualToString:@"msgErro"]){
        [registrarLivroResponse setMsgErro:valorElementoAtual];
    }
    
    valorElementoAtual = nil;
    
}

-(void)registrarLivroBaixado:(RegistrarDispositivoResponse *) registrarDispositivoResponse comLivroResponse:(LivroResponse *) livroResponse{
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    
    NSURL *url = [NSURL URLWithString:[self montarUrlParaRegistroLivro:registrarDispositivoResponse comLivroResponse:livroResponse]];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSLog(@"%@", operation);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", respostaXML);
        
        //FAZENDO O PARSE XML
        NSData *respDataXML = [respostaXML dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", respostaXML);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
        [parser setDelegate:self];
        
        if(![parser parse]){
            NSLog(@"Erro ao realizar o parse");
        }else{
            NSLog(@"Ok Parse");
        }
        
        
        NSString *mensagemAlerta = registrarLivroResponse.status;
        if(![registrarLivroResponse.erro isEqualToString:@"0"]){
            mensagemAlerta = [mensagemAlerta stringByAppendingString:@" - "];
            mensagemAlerta = [mensagemAlerta stringByAppendingString:registrarLivroResponse.msgErro];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Não foi possível registrar o livro no portal"
                                                            message:mensagemAlerta
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil
                                  
                                  ];
            
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
        
        UIAlertView *alertError = [
                                   [UIAlertView alloc] initWithTitle:@"Erro ao registrar livro no portal."
                                   message:error.description
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil
                                   ];
        
        [alertError show];
        
        
    }];
   
    [networkQueue addOperation:operation];
}

- (NSString *)montarUrlParaRegistroLivro:(RegistrarDispositivoResponse *) registrarDispositivoResponse comLivroResponse:(LivroResponse *) livroResponse{
    
    NSString *urlRegistrarLivro = @"http://www.ibracon.com.br/idr/ws/ws_registrar_livro.php?";
    
    urlRegistrarLivro = [[urlRegistrarLivro stringByAppendingString:@"cliente="] stringByAppendingString: [self urlEncodeUsingEncoding:registrarDispositivoResponse.codCliente]];
    
    urlRegistrarLivro = [[urlRegistrarLivro stringByAppendingString:@"&documento="] stringByAppendingString: [self urlEncodeUsingEncoding:registrarDispositivoResponse.dadosCliente.documento]];
    
    urlRegistrarLivro = [[urlRegistrarLivro stringByAppendingString:@"&dispositivo="] stringByAppendingString: [self urlEncodeUsingEncoding:registrarDispositivoResponse.codDispositivo]];
    
    urlRegistrarLivro = [[urlRegistrarLivro stringByAppendingString:@"&produto="] stringByAppendingString: [self urlEncodeUsingEncoding:livroResponse.codigolivro]];
    
    urlRegistrarLivro = [[urlRegistrarLivro stringByAppendingString:@"&keyword="] stringByAppendingString: [self urlEncodeUsingEncoding:registrarDispositivoResponse.dadosCliente.palavraChave]];
    
    urlRegistrarLivro = [[urlRegistrarLivro stringByAppendingString:@"&senha="] stringByAppendingString: [self urlEncodeUsingEncoding:registrarDispositivoResponse.dadosCliente.senha]];
    
    return urlRegistrarLivro;
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
