//
//  ObterEstanteResponse.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 19/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "ObterEstanteIbracon.h"
#import "AFHTTPRequestOperationManager.h"

@implementation ObterEstanteIbracon
@synthesize erro, msgErro, listaDeLivrosParaBaixar, listaDeLivrosBaixados, listaDeLivrosDeDireito;
BOOL *isParaBaixar;
bool *isBaixados;
bool *isDeDireito;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"response"]){
        return;
    }else if ([elementName  isEqualToString:@"parabaixar"]){
        isParaBaixar : YES;
        listaDeLivrosParaBaixar = [[NSMutableArray alloc]init];
        isBaixados = NO;
        isDeDireito = NO;
    }else if ([elementName isEqualToString:@"baixados"]){
        isBaixados : YES;
        listaDeLivrosBaixados = [[NSMutableArray alloc]init];
        isDeDireito = NO;
        isParaBaixar = NO;
    }else if ([elementName isEqualToString:@"dedireito"]){
        isDeDireito:YES;
        listaDeLivrosDeDireito = [[NSMutableArray alloc]init];
        isParaBaixar = NO;
        isBaixados = NO;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if([valorNoAtual isEqualToString:@"livro"])
    {
        valorNoAtual = [[NSMutableString alloc]initWithString:string];
    }
    else
    {
        [valorNoAtual appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"response"]){
        return;
    }else if([elementName isEqualToString:@"livro"] && isParaBaixar){
        [listaDeLivrosParaBaixar addObject:valorNoAtual];
    }else if([elementName isEqualToString:@"livro"] && isBaixados){
        [listaDeLivrosBaixados addObject:valorNoAtual];
    }else if([elementName isEqualToString:@"livro"] && isDeDireito){
        [listaDeLivrosDeDireito addObject:valorNoAtual];
    }else if([elementName isEqualToString:@"erro"]){
        erro = valorNoAtual;
    }else if([elementName isEqualToString:@"msgErro"]){
        msgErro = valorNoAtual;
    }
    
    valorNoAtual = nil;
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




-(void)conectarObterEstante:(NSString *)_url{
    //NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    //networkQueue.maxConcurrentOperationCount = 5;
    NSLog(@"%@", _url);

    NSURL *url = [NSURL URLWithString:_url];
    //NSLog(@"%@", networkQueue);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSLog(@"%@", request);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSLog(@"%@", operation);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", respostaXML);
        
        //[indicadorAtividade stopAnimating];
        //indicadorAtividade.hidden = YES;
        
        //FAZENDO O PARSE XML
        NSData *respDataXML = [respostaXML dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
        [parser setDelegate:self];
        
        if(![parser parse]){
            NSLog(@"Erro ao realizar o parse");
        }else{
            NSLog(@"Ok Parse");
        }
        
        
//        NSString *mensagemAlerta;
//        if(![erro isEqualToString:@"0"]){
//            mensagemAlerta = [mensagemAlerta stringByAppendingString:msgErro];
//        }
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registro "
//                                                        message:mensagemAlerta
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil
//                              
//                              ];
//        
//        [alert show];
        
        
        //REDIRECIONANDO PARA AS ESTANTES
        //        if([registrarLivroResponse.erro isEqualToString:@"0"] & [[registrarLivroResponse.status lowercaseString] isEqualToString:@"ativado"]){
        //            EstantesController *estanteController = [[EstantesController alloc] init];
        //            [estanteController setRegistrarLivroResponse:registrarLivroResponse];
        //            [controlador.navigationController pushViewController:estanteController animated:YES];
        //
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
        
        UIAlertView *alertError = [
                                   [UIAlertView alloc] initWithTitle:@"Erro"
                                   message:error.description
                                   delegate:nil
                                   cancelButtonTitle:@"Visto"
                                   otherButtonTitles:nil
                                   ];
        
        
        [alertError show];
        
        //        [indicadorAtividade stopAnimating];
        //        indicadorAtividade.hidden = YES;
        
    }];
    
    //    indicadorAtividade.hidden = NO;
    //    [indicadorAtividade startAnimating];
    
    [operation start];
    //[networkQueue addOperation:operation];
}


@end
