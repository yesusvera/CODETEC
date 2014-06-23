//
//  ConexaoBuscarIndice.m
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import "MontadorDeIncideDoLivro.h"
#import "ItemDoIndice.h"

@implementation MontadorDeIncideDoLivro{
    ItemDoIndice *itemPai;
    ItemDoIndice *itemFilho;
    NSString *idPai;
    BOOL temFilho;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"indice"]){
        indiceLivroResponse = [[IndiceLivroResponse alloc] init];
        indiceLivroResponse.parteA = [[NSMutableArray alloc]init];
        indiceLivroResponse.parteB = [[NSMutableArray alloc]init];
        itemPai = [[ItemDoIndice alloc]init];
    }
    
    if ([elementName isEqualToString:@"item" ]){
        if([idPai isEqualToString:itemPai.id]){
            itemFilho = [[ItemDoIndice alloc]init];
        }else{
            itemPai = [[ItemDoIndice alloc]init];
            temFilho = NO;
        }
    }else if([elementName isEqualToString:@"itens"]){
        temFilho = YES;
        itemFilho = [[ItemDoIndice alloc]init];
        itemPai.listaItens = [[NSMutableArray alloc]init];
        idPai = itemPai.id;
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
    
    if([elementName isEqualToString:@"response"] || [elementName isEqualToString:@"livro"] || [elementName isEqualToString:@"indice"] || [elementName isEqualToString:@"ParteA" ] || [elementName isEqualToString:@"ParteB" ] ){
        return;
    }else if([elementName isEqualToString:@"erro"]){
        [indiceLivroResponse setErro:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ];
    }else if([elementName isEqualToString:@"msgErro"]){
        [indiceLivroResponse setMsgErro:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ];
    }else if([elementName isEqualToString:@"item"]){
    
        if (![idPai isEqualToString:itemPai.id]) {
            if ([itemPai.parte isEqualToString:@"Parte A"]) {
                [indiceLivroResponse.parteA addObject:itemPai];
            }else if([itemPai.parte isEqualToString:@"Parte B"]){
                [indiceLivroResponse.parteB addObject:itemPai];
            }
            idPai = itemPai.id;
            itemPai = nil;
        }else{
            [itemPai.listaItens addObject:itemFilho];
            itemFilho = nil;
        }
        
    }else if([elementName isEqualToString:@"itens"]){
        temFilho = NO;
        itemFilho = nil;
        idPai = nil;
    }else{
        if (!temFilho){
           [itemPai setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName];
        }else{
           [itemFilho setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName];
        }
        
    }

    valorElementoAtual = nil;
    
}

-(IndiceLivroResponse *)montarIndiceDoLivro:(NSString *) indiceXML{
    
    NSString *indice = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"indice.xml"];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:indice];
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
    
//    NSString *respostaXML = indiceXML;
//    NSLog(@"%@", respostaXML);
//    
//    NSData *respDataXML = [respostaXML dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@", respostaXML);
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
//    [parser setDelegate:self];
//        
//    if(![parser parse]){
//        NSLog(@"Erro ao realizar o parse");
//    }else{
//        NSLog(@"Ok Parse");
//    }
    
    return indiceLivroResponse;

}


@end
