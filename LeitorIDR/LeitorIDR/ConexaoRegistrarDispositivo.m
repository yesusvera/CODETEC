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
#import "DadosCliente.h"
#import "DadosDispositivo.h"
#import "GLB.h"
@implementation ConexaoRegistrarDispositivo
@synthesize registrarDispositivoResponse;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"response"]){
        registrarDispositivoResponse = [[RegistrarDispositivoResponse alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    valorElementoAtual = [[NSMutableString alloc]initWithString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"response"]){
        return;
    } else if([elementName isEqualToString:@"codCliente"]){
        registrarDispositivoResponse.codCliente = valorElementoAtual;
    }else if([elementName isEqualToString:@"codDispositivo"]){
        registrarDispositivoResponse.codDispositivo = valorElementoAtual;
    }else if([elementName isEqualToString:@"status"]){
        registrarDispositivoResponse.status = valorElementoAtual;
    }else if([elementName isEqualToString:@"appVersion"]){
        registrarDispositivoResponse.appVersion = valorElementoAtual;
    }else if([elementName isEqualToString:@"erro"]){
        registrarDispositivoResponse.erro = valorElementoAtual;
    }else if([elementName isEqualToString:@"msgErro"]){
        registrarDispositivoResponse.msgErro = valorElementoAtual;
    }
    valorElementoAtual = nil;
}

-(void)registrarDispositivo:(UIActivityIndicatorView *)indicadorAtividade controller:(UIViewController *)controlador comDadosCliente:(DadosCliente *) dadosCliente comDadosDispositivo:(DadosDispositivo *) dadosDispositivo {
   
    //REGISTRO LOCAL
//    NSString *estante = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"Registrar.xml"];
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
//
//    
//    EstantesController *estanteController = [[EstantesController alloc] init];
//    [estanteController setRegistrarLivroResponse:registrarLivroResponse];
//    [estanteController setTxtDocumento : documento];
//    [estanteController setTxtSenha : senha];
//    [controlador.navigationController pushViewController:estanteController animated:YES];

 //REGISTRO ONLINE
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    
    NSString *urlParaRegistrarDispositivo = [self montarUrlParaRegistroDeDispositivo:dadosCliente comDadosDispositivo:dadosDispositivo];

    NSURL *url = [NSURL URLWithString:urlParaRegistrarDispositivo];
    NSLog(@"%@", urlParaRegistrarDispositivo);
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSLog(@"%@", operation);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", respostaXML);
        
        [indicadorAtividade stopAnimating];

        NSData *respDataXML = [respostaXML dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", respostaXML);
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
                 [NSString stringWithFormat:@"Error no download do XML de registro: %@", [error localizedDescription]]];
            }];
            
            [operationXML start];

        }
        
        
        NSString *mensagemAlerta = registrarDispositivoResponse.status;
        if(![registrarDispositivoResponse.erro isEqualToString:@"0"]){
            mensagemAlerta = [mensagemAlerta stringByAppendingString:@" - "];
            mensagemAlerta = [mensagemAlerta stringByAppendingString:registrarDispositivoResponse.msgErro];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registro "
                                                        message:mensagemAlerta
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil
                              
                              ];
        
        [alert show];

        if([registrarDispositivoResponse.erro isEqualToString:@"0"] & [[registrarDispositivoResponse.status lowercaseString] isEqualToString:@"ativado"]){
            EstantesController *estanteController = [[EstantesController alloc] init];
            registrarDispositivoResponse.dadosCliente = dadosCliente;
            estanteController.registrarDispositivoResponse = registrarDispositivoResponse;
            [controlador.navigationController pushViewController:estanteController animated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);

        [self buscarRegistroLocal];
        
        //REDIRECIONANDO PARA AS ESTANTES
        if([registrarDispositivoResponse.erro isEqualToString:@"0"] & [[registrarDispositivoResponse.status lowercaseString] isEqualToString:@"ativado"]){
            EstantesController *estanteController = [[EstantesController alloc] init];
            registrarDispositivoResponse.dadosCliente = dadosCliente;
            estanteController.registrarDispositivoResponse = registrarDispositivoResponse;
            [controlador.navigationController pushViewController:estanteController animated:YES];
            
        }
        
    }];
    
    indicadorAtividade.hidden = NO;
    [indicadorAtividade startAnimating];
    
    
    [networkQueue addOperation:operation];
}


- (NSString *)montarUrlParaRegistroDeDispositivo:(DadosCliente *) dadosCliente comDadosDispositivo:(DadosDispositivo *) dadosDispositivo{
    
    NSString *urlRegistrarDisp = [self urlRegistrar];
    
    urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"associado="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.ehAssociado]];
 
    urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&registro="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.registroNacional]];
    
    urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&documento="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.documento]];
    
    urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&senha="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.senha]];

    urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&dispositivo="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosDispositivo.dispositivo]];
    
    urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&ip="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosDispositivo.ip]];
    
    urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&macadress="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosDispositivo.macAdress]];
    
    urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&serial="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosDispositivo.serial]];
    
    return urlRegistrarDisp;
}

-(NSString *)urlRegistrar{
    return @"http://www.ibracon.com.br/idr/ws/ws_registrar.php?";
}

- (BOOL) buscarRegistroLocal{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *thumbnailsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[self urlRegistrar].lastPathComponent.stringByDeletingPathExtension stringByAppendingPathExtension:@"xml"]]];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:thumbnailsPath];
    if (!data) {
        UIAlertView *alertError = [
                                   [UIAlertView alloc] initWithTitle:@"Dispositivo não registrado! Necessário conexão com a Internet."
                                   message:@"Não foi localizado um registro local!"
                                   delegate:nil
                                   cancelButtonTitle:@"Visto"
                                   otherButtonTitles:nil
                                   ];
        
        [alertError show];
        return false;
        
    }
    
    NSString *corpoXML = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    NSLog(@"%@", corpoXML);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    NSLog(@"%@", parser);
    [parser setDelegate:self];
    
    if(![parser parse]){
        NSLog(@"Erro ao realizar o parse");
        return false;
    }else{
        NSLog(@"Ok Parse");
        
    }
    
    
//    NSString *mensagemAlerta = registrarDispositivoResponse.status;
//    if(![registrarDispositivoResponse.erro isEqualToString:@"0"]){
//        mensagemAlerta = [mensagemAlerta stringByAppendingString:@" - "];
//        mensagemAlerta = [mensagemAlerta stringByAppendingString:registrarDispositivoResponse.msgErro];
//    }
//    
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registro "
//                                                    message:mensagemAlerta
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil
//                          
//                          ];
//    
//    [alert show];
    
    return true;
}


@end
