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
    ItemDoIndice *item;
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"indice"]){
        indiceLivroResponse = [[IndiceLivroResponse alloc] init];
        indiceLivroResponse.parteA = [[NSMutableArray alloc]init];
        indiceLivroResponse.parteB = [[NSMutableArray alloc]init];
    }else if ([elementName isEqualToString:@"ParteA" ] || [elementName isEqualToString:@"ParteB" ]){
         item = [[ItemDoIndice alloc]init];
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
        [indiceLivroResponse setErro:valorElementoAtual];
    }else if([elementName isEqualToString:@"msgErro"]){
        [indiceLivroResponse setMsgErro:valorElementoAtual];
    }else if([elementName isEqualToString:@"item"] || [elementName isEqualToString:@"items"] ){
    
        [item setValue:[[valorElementoAtual stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:elementName];
        
        if ([item.parte isEqualToString:@"Parte A"]) {
            [indiceLivroResponse.parteA addObject:item];
        }else if([item.parte isEqualToString:@"Parte B"]){
            [indiceLivroResponse.parteB addObject:item];
        }
    }

    valorElementoAtual = nil;
    item = nil;
    
}

-(IndiceLivroResponse *)montarIndiceDoLivro:(NSString *) indiceXML{
    
    NSString *respostaXML = indiceXML;
    NSLog(@"%@", respostaXML);
    
    NSData *respDataXML = [respostaXML dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", respostaXML);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:respDataXML];
    [parser setDelegate:self];
        
    if(![parser parse]){
        NSLog(@"Erro ao realizar o parse");
    }else{
        NSLog(@"Ok Parse");
    }
    
    return indiceLivroResponse;

}


@end
