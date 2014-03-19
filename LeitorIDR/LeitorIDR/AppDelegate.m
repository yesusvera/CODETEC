//
//  AppDelegate.m
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 18/12/13.
//  Copyright (c) 2013 Yesus Castillo Vera. All rights reserved.
//

#import "AppDelegate.h"
#import "PerguntaRegistroController.h"
#import "AFNetworking.h"
#import "EstantesController.h"
#import "ConexaoRegistrarDispositivo.h"
#import "DadosCliente.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //VERIFICAR AQUI SE JA TEM REGISTRO
    ConexaoRegistrarDispositivo *buscarRegistroLocal = [[ConexaoRegistrarDispositivo alloc]init];
    
    if(![buscarRegistroLocal buscarRegistroLocal]){
        PerguntaRegistroController *perguntaRegistroViewController = [[PerguntaRegistroController alloc] init];
        
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:perguntaRegistroViewController];
        self.window.rootViewController = navController;
    }else{
        // DEFININDO OS DADOS DO CLIENTE A FOGO. FALTA DEFINIR SE DEVO IR PARA A TELA DE REGISTRO DE ASSOCIADO PARA QUE O CLIENTE POSSA DIGITAR OS SEUS DADOS E ASSIM BUSCAR A ESTANTE CORRETAMENTE.
        DadosCliente *dadosCliente = [[DadosCliente alloc] init];
        dadosCliente.ehAssociado      = @"s";
        dadosCliente.registroNacional = @"";
        dadosCliente.documento        = @"338.804.908-48";
        dadosCliente.senha            = @"";
        dadosCliente.palavraChave     = @"";
        EstantesController *estanteViewController = [[EstantesController alloc] init];
        buscarRegistroLocal.registrarDispositivoResponse.dadosCliente = dadosCliente;
        estanteViewController.registrarDispositivoResponse = buscarRegistroLocal.registrarDispositivoResponse;
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:estanteViewController];
        self.window.rootViewController = navController;
        
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
