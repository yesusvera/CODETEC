//
//  ObterEstanteResponse.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 19/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "ConexaoBuscarEstante.h"
#import "AFHTTPRequestOperationManager.h"
#import "RegistrarDispositivoResponse.h"
#import "GLB.h"

@implementation ConexaoBuscarEstante

BOOL isBaixados;
BOOL isParaBaixar;
BOOL isDeDireito;

-(id)init{
    self = [super init];
    if(self){
        estanteResponse = [[EstanteResponse alloc]init];
        estanteResponse.listaLivrosVisaoGeral = [[NSMutableArray alloc]init];
        estanteResponse.listaLivrosBaixados = [[NSMutableArray alloc]init];
        estanteResponse.listaLivrosDisponiveis = [[NSMutableArray alloc]init];
        estanteResponse.listaLivrosDeDireito = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"response"]){
        return;
    }
    if ([elementName  isEqualToString:@"baixados"]){
        isBaixados = YES;
        isParaBaixar = NO;
        isDeDireito = NO;
    }else if ([elementName isEqualToString:@"parabaixar"]){
        isParaBaixar = YES;
        isDeDireito = NO;
        isBaixados = NO;
    }else if ([elementName isEqualToString:@"dedireito"]){
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
        livro.tipoLivro = @"parabaixar";
        [estanteResponse.listaLivrosDisponiveis addObject:livro];
        [estanteResponse.listaLivrosVisaoGeral addObject:livro];
    }else if([elementName isEqualToString:@"livro"] && isBaixados){
        livro.tipoLivro = @"baixados";
        [estanteResponse.listaLivrosBaixados addObject:livro];
    }else if([elementName isEqualToString:@"livro"] && isDeDireito){
        livro.tipoLivro = @"dedireito";
        [estanteResponse.listaLivrosDeDireito addObject:livro];
        [estanteResponse.listaLivrosVisaoGeral addObject:livro];
    }else if([elementName isEqualToString:@"erro"]){
        erro = valorNoAtual;
    }else if([elementName isEqualToString:@"msgErro"]){
        msgErro = valorNoAtual;
    }else{
        [livro setValue:[[valorNoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName];
    }
    valorNoAtual = nil;
}

-(EstanteResponse *)conectarObterEstante:(RegistrarDispositivoResponse *) registrarDispositivoResponse{
    
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;

    NSURL *url = [NSURL URLWithString:[self montarUrlParaObterEstante:registrarDispositivoResponse]];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
        NSLog(@"%@", respostaXML);
        
        NSData *respDataXML = [respostaXML dataUsingEncoding:NSISOLatin1StringEncoding];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
        [parser setDelegate:self];
        
        if(![parser parse]){
            NSLog(@"Erro ao realizar o parse");
        }else{
            NSLog(@"Ok Parse");
            NSURLRequest *requestXML = [NSURLRequest requestWithURL:url];
            NSString *saveFilenameXML = [GLB downloadSavePathFor: [url.lastPathComponent.stringByDeletingPathExtension stringByAppendingPathExtension:@"xml"]];
            
            NSLog(@"Salvando o arquivo XML em %@", saveFilenameXML);
            
            AFHTTPRequestOperation *operationXML = [[AFHTTPRequestOperation alloc] initWithRequest:requestXML];
            
            operationXML.outputStream = [NSOutputStream outputStreamToFileAtPath:saveFilenameXML append:NO];
            
            [operationXML setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, NSHTTPURLResponse *response) {
                
                
            } failure:^(AFHTTPRequestOperation *op, NSError *error) {
                [GLB showMessage:
                 [NSString stringWithFormat:@"Error no download do XML: %@", [error localizedDescription]]];
            }];
            
            [operationXML start];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
        
        // BUSCA DO XML LOCAL
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *thumbnailsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[url.lastPathComponent.stringByDeletingPathExtension stringByAppendingPathExtension:@"xml"]]];
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:thumbnailsPath];
        if (!data) {
            UIAlertView *alertError = [
                                       [UIAlertView alloc] initWithTitle:@"Parece que você está sem conexão com a Internet."
                                       message:error.description
                                       delegate:nil
                                       cancelButtonTitle:@"Visto"
                                       otherButtonTitles:nil
                                       ];
            
            [alertError show];

        }
        
        NSString *corpoXML = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        NSLog(@"%@", corpoXML);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        NSLog(@"%@", parser);
        [parser setDelegate:self];
        
        if(![parser parse]){
            NSLog(@"Erro ao realizar o parse");
        }else{
            NSLog(@"Ok Parse");
        
        }
        
        
    }];
    
    [networkQueue addOperation:operation];
    
    return estanteResponse;
}


-(EstanteResponse *)conectarObterEstanteLocal:(RegistrarDispositivoResponse *) registrarDispositivoResponse{
    
    NSString *estante = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"EstanteIbracon.xml"];

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
    
    return estanteResponse;
}


- (NSString *) montarUrlParaObterEstante:(RegistrarDispositivoResponse *)registrarDispositivoResponse{
    
    NSString *urlObterEstante = @"http://www.ibracon.com.br/idr/ws/ws_estantes_mobile.php?";

    urlObterEstante = [[urlObterEstante stringByAppendingString:@"cliente="] stringByAppendingString:[GLB urlEncodeUsingEncoding: registrarDispositivoResponse.codCliente]];
    
    urlObterEstante = [[urlObterEstante stringByAppendingString:@"&documento="] stringByAppendingString:[GLB urlEncodeUsingEncoding:!registrarDispositivoResponse.dadosCliente.documento ? @"":registrarDispositivoResponse.dadosCliente.documento]];
    
    urlObterEstante = [[urlObterEstante stringByAppendingString:@"&dispositivo="] stringByAppendingString:[GLB urlEncodeUsingEncoding:registrarDispositivoResponse.codDispositivo]];
    
    urlObterEstante = [[urlObterEstante stringByAppendingString:@"&keyword="] stringByAppendingString:[GLB urlEncodeUsingEncoding:!registrarDispositivoResponse.dadosCliente.palavraChave?@"":registrarDispositivoResponse.dadosCliente.palavraChave]];
    
    urlObterEstante = [[urlObterEstante stringByAppendingString:@"&senha="] stringByAppendingString:[GLB urlEncodeUsingEncoding:!registrarDispositivoResponse.dadosCliente.senha?@"":registrarDispositivoResponse.dadosCliente.senha]];
    
    return urlObterEstante;
}

@end
