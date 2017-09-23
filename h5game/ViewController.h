//
//  ViewController.h
//  h5game
//
//  Created by 光宇 on 2017/6/19.
//  Copyright © 2017年 光宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
    UILabel *load;
}

@property (nonatomic, strong)UIView *Loading;
@end

