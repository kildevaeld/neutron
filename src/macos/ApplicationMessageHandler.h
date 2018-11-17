//
//  ApplicationMessageHandler.h
//  TestApp2
//
//  Created by Rasmus Kildevæld on 16/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Webkit/Webkit.h>
#include <neutron/app.h>

@interface ApplicationMessageHandler : NSObject <WKScriptMessageHandler>

- (instancetype)init:(vv_app_t *)a;

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message;

@end
