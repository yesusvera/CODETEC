//
//  Nota.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 19/06/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Nota : NSObject{
    NSString *codigolivro;
    NSString *titulo;
    NSString *pagina;
    NSString *nota;

}

@property(nonatomic, retain) NSString *codigolivro;
@property(nonatomic, retain) NSString *titulo;
@property(nonatomic, retain) NSString *pagina;
@property(nonatomic, retain) NSString *nota;
@end
