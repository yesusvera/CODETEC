//
//  ConnectionIbracon.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 02/01/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "ConexaoRegistrarDispositivo.h"
#import "AFHTTPRequestOperationManager.h"
#import "EstantesController.h"

@implementation ConexaoRegistrarDispositivo


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"response"]){
        registrarLivroResponse = [[RegistrarLivroResposta alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(!valorElementoAtual)
    {
        valorElementoAtual = [[NSMutableString alloc]initWithString:string];
    }
    else
    {
        //[valorElementoAtual appendString:string];
        valorElementoAtual = [[NSMutableString alloc]initWithString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"response"]){
        return;
    } else if([elementName isEqualToString:@"codCliente"]){
        [registrarLivroResponse setCodCliente:valorElementoAtual];
    }else if([elementName isEqualToString:@"codDispositivo"]){
        [registrarLivroResponse setCodDispositivo:valorElementoAtual];
    }else if([elementName isEqualToString:@"status"]){
        [registrarLivroResponse setStatus:valorElementoAtual];
    }else if([elementName isEqualToString:@"appVersion"]){
        [registrarLivroResponse setAppVersion:valorElementoAtual];
    }else if([elementName isEqualToString:@"erro"]){
        [registrarLivroResponse setErro:valorElementoAtual];
    }else if([elementName isEqualToString:@"msgErro"]){
        [registrarLivroResponse setMsgErro:valorElementoAtual];
    }
    
    valorElementoAtual = nil;
    
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



-(void)registrarDispositivo:(NSString *)_url indicadorCarregando:(UIActivityIndicatorView *)indicadorAtividade controller:(UIViewController *)controlador documento:(NSString *) documento senha:(NSString *) senha{
   
    //BUSCA LOCAL DO XML
    NSString *estante = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"Registrar.xml"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:estante];
    NSString *corpoXML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", corpoXML);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSLog(@"%@", parser);
    [parser setDelegate:self];
    
    if(![parser parse]){
        NSLog(@"Erro ao realizar o parse");
    }else{
        NSLog(@"Ok Parse");
    }

    
    EstantesController *estanteController = [[EstantesController alloc] init];
    [estanteController setRegistrarLivroResponse:registrarLivroResponse];
    [estanteController setTxtDocumento : documento];
    [estanteController setTxtSenha : senha];
    [controlador.navigationController pushViewController:estanteController animated:YES];
    
    
//    
//    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
//    networkQueue.maxConcurrentOperationCount = 5;
//    
//    NSLog(@"%@", _url);
//    
//    NSURL *url = [NSURL URLWithString:_url];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    NSLog(@"%@", operation);
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", respostaXML);
//        
//        [indicadorAtividade stopAnimating];
//        indicadorAtividade.hidden = YES;
//        
//        //FAZENDO O PARSE XML
//        NSData *respDataXML = [respostaXML dataUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"%@", respostaXML);
//        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
//        [parser setDelegate:self];
//        
//        if(![parser parse]){
//            NSLog(@"Erro ao realizar o parse");
//        }else{
//            NSLog(@"Ok Parse");
//        }
//        
//        
//        NSString *mensagemAlerta = registrarLivroResponse.status;
//        if(![registrarLivroResponse.erro isEqualToString:@"0"]){
//            mensagemAlerta = [mensagemAlerta stringByAppendingString:@" - "];
//            mensagemAlerta = [mensagemAlerta stringByAppendingString:registrarLivroResponse.msgErro];
//        }
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registro "
//                                                        message:mensagemAlerta
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil
//                              
//                              ];
//        
//        [alert show];
//        
//        
//        //REDIRECIONANDO PARA AS ESTANTES
//        if([registrarLivroResponse.erro isEqualToString:@"0"] & [[registrarLivroResponse.status lowercaseString] isEqualToString:@"ativado"]){
//            EstantesController *estanteController = [[EstantesController alloc] init];
//            [estanteController setRegistrarLivroResponse:registrarLivroResponse];
//            [estanteController setTxtDocumento : documento];
//            [estanteController setTxtSenha : senha];
//            [controlador.navigationController pushViewController:estanteController animated:YES];
//            
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
//        
//        UIAlertView *alertError = [
//                                   [UIAlertView alloc] initWithTitle:@"Erro"
//                                   message:error.description
//                                   delegate:nil
//                                   cancelButtonTitle:@"Visto"
//                                   otherButtonTitles:nil
//                                   ];
//        
//        
//        [alertError show];
//        
//        [indicadorAtividade stopAnimating];
//        indicadorAtividade.hidden = YES;
//        
//    }];
//    
//    indicadorAtividade.hidden = NO;
//    [indicadorAtividade startAnimating];
//    
//    
//    [networkQueue addOperation:operation];
}


@end
