//
//  ObterEstanteResponse.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 19/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "ConexaoEstante.h"
#import "AFHTTPRequestOperationManager.h"


@implementation ConexaoEstante

@synthesize estanteResponse;

BOOL isBaixados;
BOOL isParaBaixar;
BOOL isDeDireito;


-(id)init{
    self = [super init];
    if(self){
        estanteResponse = [[EstanteResponse alloc]init];
    }

    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"response"]){
        return;
    }
    if ([elementName  isEqualToString:@"baixados"]){
        estanteResponse.listaDeLivrosBaixados = [[NSMutableArray alloc]init];
        isBaixados = YES;
        isParaBaixar = NO;
        isDeDireito = NO;
        if(!estanteResponse.listaDeLivros){
            estanteResponse.listaDeLivros = [[NSMutableArray alloc]init];
        }
    }else if ([elementName isEqualToString:@"parabaixar"]){
        estanteResponse.listaDeLivrosParaBaixar = [[NSMutableArray alloc]init];
        isParaBaixar = YES;
        isDeDireito = NO;
        isBaixados = NO;
        if(!estanteResponse.listaDeLivros){
            estanteResponse.listaDeLivros = [[NSMutableArray alloc]init];
        }
    }else if ([elementName isEqualToString:@"dedireito"]){
        estanteResponse.listaDeLivrosDeDireito = [[NSMutableArray alloc]init];
        isDeDireito = YES;
        isParaBaixar = NO;
        isBaixados = NO;
        if(!estanteResponse.listaDeLivros){
            estanteResponse.listaDeLivros = [[NSMutableArray alloc]init];
        }
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
        [estanteResponse.listaDeLivrosParaBaixar  addObject:livro];
        [estanteResponse.listaDeLivros  addObject:livro];
        livro = nil;
    }else if([elementName isEqualToString:@"livro"] && isBaixados){
        [estanteResponse.listaDeLivrosBaixados addObject:livro];
        [estanteResponse.listaDeLivros  addObject:livro];
        livro = nil;
    }else if([elementName isEqualToString:@"livro"] && isDeDireito){
        [estanteResponse.listaDeLivrosDeDireito addObject:livro];
        [estanteResponse.listaDeLivros  addObject:livro];
        livro = nil;
    }else if([elementName isEqualToString:@"erro"]){
        erro = valorNoAtual;
    }else if([elementName isEqualToString:@"msgErro"]){
        msgErro = valorNoAtual;
    }else
        [livro setValue:[[valorNoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName];
    
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

    NSURL *url = [NSURL URLWithString:_url];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
        NSLog(@"%@", respostaXML);
        
        //FAZENDO O PARSE XML
        NSData *respDataXML = [respostaXML dataUsingEncoding:NSISOLatin1StringEncoding];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
        [parser setDelegate:self];
        
        if(![parser parse]){
            NSLog(@"Erro ao realizar o parse");
        }else{
            NSLog(@"Ok Parse");
        }
        
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
        
    }];
    
    [networkQueue addOperation:operation];
}


@end
