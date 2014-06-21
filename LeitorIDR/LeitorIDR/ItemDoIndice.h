//
//  ItemDoIndice.h
//  LeitorIDR
//
//  Created by Jonathan Jordan Carrillo Salcedo on 20/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemDoIndice : NSObject{
    NSString *ID;
    NSString *capitulo;
    NSString *paginavirtual;
    NSString *paginareal;
    NSString *parte;
    NSString *pai;
    NSMutableArray *listaItens;
}

@property(nonatomic, retain) NSString *ID;
@property(nonatomic, retain) NSString *capitulo;
@property(nonatomic, retain) NSString *paginavirtual;
@property(nonatomic, retain) NSString *paginareal;
@property(nonatomic, retain) NSString *parte;
@property(nonatomic, retain) NSString *pai;
@property(nonatomic, retain) NSMutableArray *listaItens;

@end
