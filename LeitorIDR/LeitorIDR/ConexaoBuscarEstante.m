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


@implementation ConexaoBuscarEstante

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
        livro.tipoLivro = @"parabaixar";
        [estanteResponse.listaDeLivrosParaBaixar  addObject:livro];
        [estanteResponse.listaDeLivros  addObject:livro];
        livro = nil;
    }else if([elementName isEqualToString:@"livro"] && isBaixados){
        livro.tipoLivro = @"baixados";
        [estanteResponse.listaDeLivrosBaixados addObject:livro];
        [estanteResponse.listaDeLivros  addObject:livro];
        livro = nil;
    }else if([elementName isEqualToString:@"livro"] && isDeDireito){
        livro.tipoLivro = @"dedireito";
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




-(void)conectarObterEstante:(RegistrarDispositivoResponse *) registrarDispositivoResponse{
    
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
//
//    }

    
// DESCOMENTAR QUANDO USAR O WEBSERVICE
    
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;

    NSURL *url = [NSURL URLWithString:[self montarUrlParaObterEstante:registrarDispositivoResponse]];
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
            //DOWNLOAD DO XML DE ESTANTES
            NSURLRequest *requestXML = [NSURLRequest requestWithURL:url];
            NSString *saveFilenameXML = [self downloadSavePathFor: [url.lastPathComponent.stringByDeletingPathExtension stringByAppendingPathExtension:@"xml"]];
            
            NSLog(@"Salvando o arquivo XML em %@", saveFilenameXML);
            
            AFHTTPRequestOperation *operationXML = [[AFHTTPRequestOperation alloc] initWithRequest:requestXML];
            
            operationXML.outputStream = [NSOutputStream outputStreamToFileAtPath:saveFilenameXML append:NO];
            
            [operationXML setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, NSHTTPURLResponse *response) {
                
                
            } failure:^(AFHTTPRequestOperation *op, NSError *error) {
                [self showMessage:
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
                                       [UIAlertView alloc] initWithTitle:@"Biblioteca local vazia! Necessário conexão com a Internet."
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
}


-(void)conectarObterEstanteLocal:(RegistrarDispositivoResponse *) registrarDispositivoResponse{
    
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
}


- (NSString *) montarUrlParaObterEstante:(RegistrarDispositivoResponse *)registrarDispositivoResponse{
    
    NSString *urlObterEstante = @"http://www.ibracon.com.br/idr/ws/ws_estantes.php?";

    urlObterEstante = [[urlObterEstante stringByAppendingString:@"cliente="] stringByAppendingString:[self urlEncodeUsingEncoding:registrarDispositivoResponse.codCliente]];
    
    urlObterEstante = [[urlObterEstante stringByAppendingString:@"&documento="] stringByAppendingString:[self urlEncodeUsingEncoding:registrarDispositivoResponse.dadosCliente.documento]];
    
    urlObterEstante = [[urlObterEstante stringByAppendingString:@"&dispositivo="] stringByAppendingString:[self urlEncodeUsingEncoding:registrarDispositivoResponse.codDispositivo]];
    
    urlObterEstante = [[urlObterEstante stringByAppendingString:@"&keyword="] stringByAppendingString:[self urlEncodeUsingEncoding:registrarDispositivoResponse.dadosCliente.palavraChave]];
    
    urlObterEstante = [[urlObterEstante stringByAppendingString:@"&senha="] stringByAppendingString:[self urlEncodeUsingEncoding:registrarDispositivoResponse.dadosCliente.senha]];
    
    return urlObterEstante;
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

@end
