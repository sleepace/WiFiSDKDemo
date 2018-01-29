//
//  ConfigureWiFiViewController.m
//  WiFiSDKDemo
//
//  Created by San on 2018/1/25.
//  Copyright © 2018年 medica. All rights reserved.
//

#import "ConfigureWiFiViewController.h"
#import <APWifiConfig/SLPApWifiConfig.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SLPPopMenuItem.h"
#import "SLPPopMenuViewController.h"

@interface ConfigureWiFiViewController ()
{
    SLPApWifiConfig *con;
    
    NSString *currentDevciceId;
}

@property (nonatomic,weak) IBOutlet UILabel *label1;
@property (nonatomic,weak) IBOutlet UILabel *label2;
@property (nonatomic,weak) IBOutlet UILabel *label3;
@property (nonatomic,weak) IBOutlet UILabel *label4;
@property (nonatomic,weak) IBOutlet UILabel *label5;
@property (nonatomic,weak) IBOutlet UILabel *label6;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UITextField *textfield1;
@property (nonatomic,weak) IBOutlet UITextField *textfield2;
@property (nonatomic,weak) IBOutlet UIButton *configureBT;
@property (nonatomic,weak) IBOutlet UIView *navigationShell;
@property (nonatomic,weak) IBOutlet UIView *containView;
@property (nonatomic,weak) IBOutlet UIButton *selectBT;


@end

@implementation ConfigureWiFiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
    con= [[SLPApWifiConfig alloc]init];
}

- (void)setUI
{
    self.label1.text = NSLocalizedString(@"step1", nil);
    self.label2.text = NSLocalizedString(@"ap_mode", nil);
    self.label3.text = NSLocalizedString(@"step2", nil);
    self.label4.text = NSLocalizedString(@"select_wifi", nil);
    self.label5.text = NSLocalizedString(@"step3", nil);
    self.label6.text = NSLocalizedString(@"reminder_connect_hotspot1", nil);
    
    [self.configureBT setTitle:NSLocalizedString(@"pair_wifi", nil) forState:UIControlStateNormal];
    self.configureBT.layer.cornerRadius =25.0f;
    self.titleLabel.text = @"RestOn Z400TWB";
    currentDevciceId = @"0";
    
    self.textfield1.placeholder = NSLocalizedString(@"input_wifi_name", nil);
    self.textfield2.placeholder = NSLocalizedString(@"input_wifi_psw", nil);
//    self.textfield1.text = @"medica_2";
//    self.textfield2.text = @"11221122";
}


- (IBAction)selectDevice:(id)sender {
    
    SLPPopMenuViewController *popVc = [[SLPPopMenuViewController alloc] initWithDataSource:[self getItem] fromView:self.navigationShell];
    [self.view addSubview:popVc.view];
    [self addChildViewController:popVc];
    __weak typeof(popVc) weakPopVc = popVc;
    __weak typeof(self) weakSelf = self;
    popVc.didSelectedItemBlock = ^(SLPPopMenuItem *item){
        currentDevciceId = item.itemid;
        weakSelf.titleLabel.text = item.itemtitle;
        [weakPopVc.view removeFromSuperview];
        [weakPopVc removeFromParentViewController];
    };
    popVc.dissBlock = ^(SLPPopMenuItem *item ){
        [weakPopVc.view removeFromSuperview];
        [weakPopVc removeFromParentViewController];
    };
}

- (IBAction)configureAction:(id)sender {
    if (![self isConnectedDeviceWiFi]) {
        NSString *message = NSLocalizedString(@"reminder_connect_hotspot2", nil);
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
        [alertview show];
        return ;
    }
    
    [con configDevice:[self backDevicetypeFromID:currentDevciceId] serverAddress:[self backAddressFromID:currentDevciceId] port:[self backPortFromID:currentDevciceId] wifiName:self.textfield1.text password:self.textfield2.text completion:^(BOOL succeed, id data) {
        NSString *result=@"";
        NSString *title=nil;
        if (succeed) {
            NSLog(@"send succeed!");
            title = NSLocalizedString(@"reminder_configuration_success", nil);
            SLPDeviceInfo *deviceInfo= (SLPDeviceInfo *)data;
            result =[NSString stringWithFormat:@"deviceId=%@,version=%@",deviceInfo.deviceID,deviceInfo.version];
        }
        else
        {
            NSLog(@"send failed!");
            result = NSLocalizedString(@"reminder_configuration_fail", nil);
        }
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:title message:result delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
        [alertview show];
    }];
}


- (BOOL)isConnectedDeviceWiFi//热点
{
    NSDictionary *ifs = [self getSSIDInfo];
    if (ifs != nil)
    {
        NSString *ssid = ifs[@"SSID"];
        
        if ([ssid rangeOfString:@"Sleepace"].location != NSNotFound||[ssid rangeOfString:@"RestOn"].location != NSNotFound||[ssid rangeOfString:@"Reston"].location != NSNotFound)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (id)getSSIDInfo
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [((NSDictionary *)info) count])
        {
            break;
        }
    }
    return info;
}

- (SLPDeviceTypes )backDevicetypeFromID:(NSString *)itemId
{
    SLPDeviceTypes type = SLPDeviceType_None;
    switch (itemId.integerValue) {
        case 0:
            type = SLPDeviceType_Z5;
            break;
        case 1:
            type = SLPDeviceType_Z6;
            break;
        default:
            break;
    }
    return type;
}

- (NSString * )backAddressFromID:(NSString *)itemId
{
    NSString *address = @"";
    switch (itemId.integerValue) {
        case 0:
            address = @"http://172.14.1.100:9880";;
            break;
        case 1:
            address = @"172.14.1.100";
            break;
        default:
            break;
    }
    return address;
}

- (NSInteger )backPortFromID:(NSString *)itemId
{
    NSInteger port = 0;
    switch (itemId.integerValue) {
        case 0:
            port = 0;
            break;
        case 1:
            port =9010;
            break;
        default:
            break;
    }
    return port;
}

- (NSArray *)getItem
{
    NSMutableArray *arrayM = [[NSMutableArray alloc] initWithCapacity:0];
    SLPPopMenuItem *item = [[SLPPopMenuItem alloc] init];
    item.itemtitle= @"RestOn Z400TWB";
    item.itemid = @"0";
    [arrayM addObject:item];
    SLPPopMenuItem *item2 = [[SLPPopMenuItem alloc] init];
    item2.itemtitle= @"RestOn Z400TWP";
    item2.itemid = @"1";
    [arrayM addObject:item2];
    return arrayM;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.textfield1.isEditing) {
        [self.textfield1 resignFirstResponder];
    }
    if (self.textfield2.isEditing) {
        [self.textfield2 resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
