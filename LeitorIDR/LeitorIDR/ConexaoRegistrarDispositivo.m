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
        registrarDispositivoResponse.dadosCliente = [[DadosCliente alloc]init];
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
    }else if([elementName isEqualToString:@"registroNacional"]){
        registrarDispositivoResponse.dadosCliente.registroNacional = valorElementoAtual;
    }else if([elementName isEqualToString:@"documento"]){
        registrarDispositivoResponse.dadosCliente.documento = valorElementoAtual;
    }else if([elementName isEqualToString:@"senha"]){
        registrarDispositivoResponse.dadosCliente.senha = valorElementoAtual;
    }else if([elementName isEqualToString:@"palavraChave"]){
        registrarDispositivoResponse.dadosCliente.palavraChave = valorElementoAtual;
    }else if([elementName isEqualToString:@"erro"]){
        registrarDispositivoResponse.erro = valorElementoAtual;
    }else if([elementName isEqualToString:@"msgErro"]){
        registrarDispositivoResponse.msgErro = valorElementoAtual;
    }
    valorElementoAtual = nil;
}

-(void)registrarDispositivo:(UIActivityIndicatorView *)indicadorAtividade
       controller:(UIViewController *)controlador
       comDadosCliente:(DadosCliente *) dadosCliente
       comDadosDispositivo:(DadosDispositivo *)
       dadosDispositivo botaoRegistrar: (UIButton *) btnRegistrar {

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
        
        NSString *concatXML = @"<registroNacional>";
        concatXML = [concatXML stringByAppendingString: !dadosCliente.registroNacional ?@"" : dadosCliente.registroNacional];

        concatXML = [concatXML stringByAppendingString: @"</registroNacional>"];
        
        concatXML = [concatXML stringByAppendingString: @"<documento>"];
        concatXML = [concatXML stringByAppendingString: !dadosCliente.documento ? @"" : dadosCliente.documento ];
        concatXML = [concatXML stringByAppendingString: @"</documento>"];
        
        concatXML = [concatXML stringByAppendingString: @"<senha>"];
        concatXML = [concatXML stringByAppendingString: !dadosCliente.senha ? @"" : dadosCliente.senha];
        concatXML = [concatXML stringByAppendingString: @"</senha>"];
        
        concatXML = [concatXML stringByAppendingString: @"<palavraChave>"];
        concatXML = [concatXML stringByAppendingString: !dadosCliente.palavraChave ? @"" : dadosCliente.palavraChave];
        concatXML = [concatXML stringByAppendingString: @"</palavraChave>"];
        
        concatXML = [concatXML stringByAppendingString: @"</response>"];
        
        
        respostaXML = [respostaXML stringByReplacingOccurrencesOfString:@"</response>" withString:concatXML];
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
            
            BOOL ok = [respostaXML writeToFile:[GLB downloadSavePathFor: [url.lastPathComponent.stringByDeletingPathExtension stringByAppendingPathExtension:@"xml"]] atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
            if(ok){
                NSLog(@"Salvou com sucesso");
            }
        }
        
        if([registrarDispositivoResponse.erro isEqualToString:@"0"] & [[registrarDispositivoResponse.status lowercaseString] isEqualToString:@"ativado"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registro "
                                                            message:@"Dispositivo registrado com sucesso! Selecione a estante desejada."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil
                                  
                                  ];
            
            [alert show];
            
            EstantesController *estanteController = [[EstantesController alloc] init];
            registrarDispositivoResponse.dadosCliente = dadosCliente;
            estanteController.registrarDispositivoResponse = registrarDispositivoResponse;
            
            [controlador.navigationController pushViewController:estanteController animated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        btnRegistrar.hidden = FALSE;
        
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);

        [self buscarRegistroLocal];
        
        //REDIRECIONANDO PARA AS ESTANTES
        if([registrarDispositivoResponse.erro isEqualToString:@"0"] & [[registrarDispositivoResponse.status lowercaseString] isEqualToString:@"ativado"]){
            EstantesController *estanteController = [[EstantesController alloc] init];
            registrarDispositivoResponse.dadosCliente = dadosCliente;
            estanteController.registrarDispositivoResponse = registrarDispositivoResponse;
            [controlador.navigationController pushViewController:estanteController animated:YES];
        }else{ //PROBLEMAS COM A INTERNET
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registro "
                                                            message:@"Não é possível realizar o registro. Verifique sua conexão com a internet."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil
                                  
                                  ];
            
            [alert show];
        }
        
        [indicadorAtividade stopAnimating];
        indicadorAtividade.hidden = YES;
    }];
    
    indicadorAtividade.hidden = NO;
    [indicadorAtividade startAnimating];
    
    [networkQueue addOperation:operation];
}


- (NSString *)montarUrlParaRegistroDeDispositivo:(DadosCliente *) dadosCliente comDadosDispositivo:(DadosDispositivo *) dadosDispositivo{
    
    NSString *urlRegistrarDisp = [self urlRegistrar];
    
    if(dadosCliente.ehAssociado!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"associado="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.ehAssociado]];
    }
    
    if(dadosCliente.registroNacional!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&registro="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.registroNacional]];
    }

    if(dadosCliente.documento!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&documento="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.documento]];
    }
    
    if(dadosCliente.senha!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&senha="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.senha]];
    }
    if(dadosCliente.endereco!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&endereco="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.endereco]];
    }
    
    if(dadosCliente.numero!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&numero="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.numero]];
    }
    if(dadosCliente.nomeRazao!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&cliente="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.nomeRazao]];
    }
    
    if(dadosCliente.uf!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&uf="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.uf]];
    }
    
    if(dadosCliente.email!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&email="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.email]];
    }
    
    if(dadosCliente.telefone!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&telefone="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.telefone]];
    }
    
    if(dadosCliente.bairro!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&bairro="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.bairro]];
    }
    
    if(dadosCliente.complemento!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&complemento="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosCliente.complemento]];
    }
    
    if(dadosDispositivo.dispositivo!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&dispositivo="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosDispositivo.dispositivo]];
    }
    
    if(dadosDispositivo.ip!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&ip="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosDispositivo.ip]];
    }
    
    if(dadosDispositivo.macAdress!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&macadress="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosDispositivo.macAdress]];
    }
    
    if(dadosDispositivo.serial!=nil){
        urlRegistrarDisp = [[urlRegistrarDisp stringByAppendingString:@"&serial="] stringByAppendingString: [GLB urlEncodeUsingEncoding:dadosDispositivo.serial]];
    }
    return urlRegistrarDisp;
}

-(NSString *)urlRegistrar{
    return @"http://www.ibracon.com.br/idr/ws/ws_registrar.php?";
}

- (RegistrarDispositivoResponse *) buscarRegistroLocal{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *thumbnailsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[self urlRegistrar].lastPathComponent.stringByDeletingPathExtension stringByAppendingPathExtension:@"xml"]]];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:thumbnailsPath];
    
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
    
    return registrarDispositivoResponse;
}


@end
