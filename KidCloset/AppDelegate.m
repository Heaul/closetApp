//
//  AppDelegate.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/2/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "AppDelegate.h"
;
#import "Networking.h"
#import "ViewController.h"
#import "CreateClosetViewController.h"
@interface AppDelegate ()
@property UITabBarController *tabBarController;
@property UINavigationController *navigationController;
@end

@implementation AppDelegate

- (void) loginViewControllerDidLogin:(ViewController *)aController{
     self.tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabController"];
    // [self.navigationController popToRootViewControllerAnimated:YES];
    [self transitionToMainInterface];
}
- (void) loginViewControllerDidCancel:(ViewController *)aController{}
-(void)transitionToAppAfterSignUp{

     CreateClosetViewController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateClosetViewController"];
     main.hasOtherClosets = NO;
     NSLog(@"creatreCloset");
     self.navigationController.navigationBarHidden = NO;
     [self.navigationController.navigationItem setHidesBackButton:YES animated:YES];
     main.isFirstRun = YES;
     UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(leftPushed:)];
    [main.navigationItem setLeftBarButtonItem:backButton];
     [main.navigationController.navigationBar setTintColor:[UIColor flatPowderBlueColorDark]];
     [main.navigationController.navigationBar setBackgroundColor:[UIColor flatPowderBlueColorDark]];
     CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
     [self.navigationController setViewControllers:@[main] animated:YES];

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [MagicalRecord setupAutoMigratingCoreDataStack];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.navigationController = [[UINavigationController alloc]init];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor flatPowderBlueColorDark]];
    [self.navigationController.navigationBar 
 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    if ( [[Networking sharedInstance] userIsLoggedIn] ) {
    
        [self presentMainApplication];
        
    } else {
        
        [self presentFirstScreen];
    }
    [Instabug startWithToken:@"091614a4ac2cfe8fed876eee8abf3d6f" invocationEvent:IBGInvocationEventShake];
    return YES;
}

-(void)presentCreateCloset:(Closet *)closet{

     CreateClosetViewController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateClosetViewController"];
     main.closet = closet;
     main.hasOtherClosets = NO;
     NSLog(@"creatreCloset");
     self.navigationController.navigationBarHidden = NO;
     [self.navigationController.navigationItem setHidesBackButton:YES animated:YES];
     main.isFirstRun = YES;
     UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(leftPushed:)];
    [main.navigationItem setLeftBarButtonItem:backButton];
     [main.navigationController.navigationBar setTintColor:[UIColor flatPowderBlueColorDark]];
     [main.navigationController.navigationBar setBackgroundColor:[UIColor flatPowderBlueColorDark]];
     CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
     [self.navigationController setViewControllers:@[main] animated:YES];
}
-(void)leftPushed:(id)sender{
    [Closet clearCloset];
    [[Networking sharedInstance] clearToken];
    [self presentLogin];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to m;ve from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [MagicalRecord cleanUp];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "pjr.KidCloset" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KidCloset" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KidCloset.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void) transitionToMainInterfaceFirstRun {

    self.window.rootViewController = self.navigationController;

    self.tabBarController.delegate = self;
    [self.navigationController setViewControllers:@[self.tabBarController] animated:YES];}

- (void) transitionToMainInterface {
    
   self.window.rootViewController = self.navigationController;

    self.tabBarController.delegate = self;
     [self.navigationController setViewControllers:@[self.tabBarController] animated:YES];

}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (void) presentMainApplication {
    self.tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabController"];

    self.window.rootViewController = self.navigationController;
    self.tabBarController.delegate = self;
     [self.navigationController setViewControllers:@[self.tabBarController] animated:YES];
}

-(void)presentFirstScreen{
    UIViewController *controller2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    //  [self.window.rootViewController.view removeFromSuperview];
   // self.window.rootViewController = self.tabBarController;
    //[self.tabBarController presentViewController:controller2 animated:YES completion:nil];
     [self.window makeKeyAndVisible];
    
    self.window.rootViewController = self.navigationController;
        self.navigationController.navigationBarHidden = YES;

     [self.navigationController setViewControllers:@[controller2] animated:YES];
}

- (void) presentLogin{
    
    
     ViewController *controller2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
    
    controller2.originalViewController = YES;
    controller2.shouldLogin = [[NSNumber alloc]initWithBool:YES];
    self.tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabController"];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setViewControllers:@[controller2] animated:YES];

}


@end
