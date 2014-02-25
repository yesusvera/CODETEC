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
@synthesize listaDeLivrosParaBaixar, listaDeLivrosBaixados, listaDeLivrosDeDireito;

BOOL isBaixados;
BOOL isParaBaixar;
BOOL isDeDireito;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"response"]){
        return;
    }
    if ([elementName  isEqualToString:@"baixados"]){
        listaDeLivrosBaixados = [[NSMutableArray alloc]init];
        isBaixados = YES;
        isParaBaixar = NO;
        isDeDireito = NO;
    }else if ([elementName isEqualToString:@"parabaixar"]){
        listaDeLivrosParaBaixar = [[NSMutableArray alloc]init];
        isParaBaixar = YES;
        isDeDireito = NO;
        isBaixados = NO;
    }else if ([elementName isEqualToString:@"dedireito"]){
        listaDeLivrosDeDireito = [[NSMutableArray alloc]init];
        isDeDireito = YES;
        isParaBaixar = NO;
        isBaixados = NO;
    }else if ([elementName isEqualToString:@"livro"]){
        livro = [[LivroResponse alloc]init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if(!valorNoAtual)
    {
        valorNoAtual = [[NSMutableString alloc]initWithString:string];

    }else{
        [valorNoAtual appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"response"] || [elementName isEqualToString:@"baixados"] || [elementName isEqualToString:@"parabaixar"] || [elementName isEqualToString:@"dedireito"]){
        return;
    }
    if([elementName isEqualToString:@"livro"] && isParaBaixar){
        [listaDeLivrosParaBaixar addObject:livro];
        livro = nil;
    }else if([elementName isEqualToString:@"livro"] && isBaixados){
        [listaDeLivrosBaixados addObject:livro];
        livro = nil;
    }else if([elementName isEqualToString:@"livro"] && isDeDireito){
        [listaDeLivrosDeDireito addObject:livro];
        livro = nil;
    }else if([elementName isEqualToString:@"erro"]){
        erro = valorNoAtual;
    }else if([elementName isEqualToString:@"msgErro"]){
        msgErro = valorNoAtual;
    }else
        [livro setValue:valorNoAtual forKey:elementName];
    
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
    
//    NSString *estante = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"EstanteIbracon.xml"];
//
//    NSData *data = [[NSData alloc] initWithContentsOfFile:estante];
//    NSString *corpoXML = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", corpoXML);
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
//    NSLog(@"%@", parser);
//    [parser setDelegate:self];
//    
//    if(![parser parse]){
//        NSLog(@"Erro ao realizar o parse");
//    }else{
//        NSLog(@"Ok Parse");
//    }

    
// DESCOMENTAR QUANDO USAR O WEBSERVICE
    
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    NSLog(@"%@", _url);

    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
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
    
    //indicadorAtividade.hidden = NO;
    //[indicadorAtividade startAnimating];
    
    [networkQueue addOperation:operation];
}


@end
