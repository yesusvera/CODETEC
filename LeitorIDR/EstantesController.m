//
//  EstantesController.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 24/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "EstantesController.h"
#import "EstanteLivrosController.h"
#import "ConnectionIbracon.h"
#import "AFHTTPRequestOperationManager.h"

@interface EstantesController ()

@end

@implementation EstantesController
@synthesize erro,msgErro;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"response"]){
        obterEstanteResponse = [[ObterEstanteResponse alloc] init];
    }else if ([elementName  isEqualToString:@"parabaixar"]){
        _isParaBaixar:YES;
        obterEstanteResponse.listaDeLivrosParaBaixar = [[NSMutableArray alloc]init];
    }else if ([elementName isEqualToString:@"baixados"]){
        _isBaixados:YES;
        obterEstanteResponse.listaDeLivrosBaixados = [[NSMutableArray alloc]init];
    }else if ([elementName isEqualToString:@"dedireito"]){
        _isDeDireito:YES;
        obterEstanteResponse.listaDeLivrosDeDireito = [[NSMutableArray alloc]init];
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
    
    if([elementName isEqualToString:@"response"]){
        return;
    }else if([elementName isEqualToString:@"livro"] && _isParaBaixar){
        //TODO Falta implementar para armazenar no Array de livros especifico
    }else if([elementName isEqualToString:@"livro"] && _isBaixados){
        //TODO Falta implementar para armazenar no Array de livros especifico
    }else if([elementName isEqualToString:@"livro"] && _isDeDireito){
        //TODO Falta implementar para armazenar no Array de livros especifico
    }else if([elementName isEqualToString:@"erro"]){
        [obterEstanteResponse setErro:valorElementoAtual];
    }else if([elementName isEqualToString:@"msgErro"]){
        [obterEstanteResponse setMsgErro:valorElementoAtual];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EstanteLivrosController *estanteLivros = [[EstanteLivrosController alloc]init];
    estanteLivros.nomeEstante = [estantes objectAtIndex:indexPath.row];
    [estanteLivros setRegistrarLivroResponse:self.registrarLivroResponse];
    [self.navigationController pushViewController:estanteLivros animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return estantes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemEstante"];
    cell.textLabel.text = [estantes objectAtIndex:indexPath.row];
    return cell;
}


- (void)viewDidLoad
{
    estantes = @[@"Visão Geral", @"Disponíveis", @"Direito de uso", @"Minha Biblioteca"];

    [super viewDidLoad];
    
   self.title= @"Estantes";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) obterEstante:(id)sender {
    //    NSString *urlRegistrarDisp = @"http://www.ibracon.com.br/idr/ws/ws_registrar.php?endereco=GUARA&senha=1234&numero=23&serial=W892913L644&cidade=BRASILIA&ip=192.168.1.10&cliente=YESUS&dispositivo=MacBook-Pro-de-Yesus.local&macadress=00-26-08-E5-4F-01&registro=RN001&uf=DF&email=yesusvera%40gmail.com&cep=&documento=001&associado=n&telefone=111&bairro=GUARA+II&complemento=123";
    
    // MAIS UM TESTES DE COMMIT - YESUS
    NSString *urlObterEstante = @"http://www.ibracon.com.br/idr/ws/ws_estantes.php?";
    //ConnectionIbracon *connectionIbra =[ConnectionIbracon alloc];
    
    
    //Cliente Associado
    urlObterEstante = [urlObterEstante stringByAppendingString:@"cliente=1373"];
    
    //DADOS DO FORMULARIO - JONATHAN
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&documento=338.804.908-48"];
    //urlObterEstante = [urlObterEstante stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.txtRegistroNacional.text]];
    
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&dispositivo=54"];
    //urlObterEstante = [urlObterEstante stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.txtCPFCNPJ.text]];
    
    
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&keyword="];
    //urlObterEstante = [urlObterEstante stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.txtSenha.text]];
    
    
    //DADOS DO DISPOSITIVO
    urlObterEstante = [urlObterEstante stringByAppendingString:@"&senha=teste"];
    //urlObterEstante = [urlObterEstante stringByAppendingString: [connectionIbra urlEncodeUsingEncoding:self.lblDispositivo.text]];
    
    [self obterEstante:urlObterEstante indicadorCarregando:self.indicadorAtividade controller:self];
}


-(void)obterEstante:(NSString *)_url indicadorCarregando:(UIActivityIndicatorView *)indicadorAtividade controller:(UIViewController *)controlador{
    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
    networkQueue.maxConcurrentOperationCount = 5;
    
    NSLog(@"%@", _url);
    
    NSURL *url = [NSURL URLWithString:_url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *respostaXML = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", respostaXML);
        
        [indicadorAtividade stopAnimating];
        indicadorAtividade.hidden = YES;
        
        //FAZENDO O PARSE XML
        NSData *respDataXML = [respostaXML dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
        [parser setDelegate:self];
        
        if(![parser parse]){
            NSLog(@"Erro ao realizar o parse");
        }else{
            NSLog(@"Ok Parse");
        }
        
        
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
        
        [indicadorAtividade stopAnimating];
        indicadorAtividade.hidden = YES;
        
    }];
    
    indicadorAtividade.hidden = NO;
    [indicadorAtividade startAnimating];
    
    
    [networkQueue addOperation:operation];
}



@end
