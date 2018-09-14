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
#import "MBProgressHUD.h"

@interface ConfigureWiFiViewController ()<UITextFieldDelegate>
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
@property (nonatomic,weak) IBOutlet UILabel *label7;
@property (nonatomic,weak) IBOutlet UILabel *label8;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UITextField *textfield1;
@property (nonatomic,weak) IBOutlet UITextField *textfield2;
@property (nonatomic,weak) IBOutlet UITextField *textfield3;
@property (nonatomic,weak) IBOutlet UITextField *textfield4;
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
    self.label3.text = NSLocalizedString(@"step3", nil);
    self.label4.text = NSLocalizedString(@"select_wifi", nil);
    self.label5.text = NSLocalizedString(@"step2", nil);
    self.label6.text = NSLocalizedString(@"reminder_connect_hotspot1", nil);
    self.label7.text = NSLocalizedString(@"step3", nil);
    self.label8.text = NSLocalizedString(@"设备要连接的地址和端口", nil);

    [self.configureBT setTitle:NSLocalizedString(@"pair_wifi", nil) forState:UIControlStateNormal];
    self.configureBT.layer.cornerRadius =25.0f;
    self.titleLabel.text = @"RestOn Z400TWB";
    currentDevciceId = @"0";
    
    self.textfield1.placeholder = NSLocalizedString(@"input_wifi_name", nil);
    self.textfield2.placeholder = NSLocalizedString(@"input_wifi_psw", nil);
    
//    self.textfield1.text = @"medica_2";
//    self.textfield2.text = @"11221122";
    [self refreshServerAddressAndPort];
//    self.textfield3.text = [self backAddressFromID:currentDevciceId];
//    self.textfield4.text = [NSString stringWithFormat:@"%ld",(long)[self backPortFromID:currentDevciceId]];

    self.textfield1.delegate=self;
    self.textfield2.delegate=self;
    self.textfield3.delegate=self;
    self.textfield4.delegate=self;
}

- (void)refreshServerAddressAndPort
{
    self.textfield3.text = [self backAddressFromID:currentDevciceId];
    self.textfield4.text = [NSString stringWithFormat:@"%ld",(long)[self backPortFromID:currentDevciceId]];
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
        [weakSelf refreshServerAddressAndPort];
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
    if (!self.textfield1.text.length) {
        NSString *message = NSLocalizedString(@"input_wifi_name", nil);
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
        [alertview show];
        return ;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [con configDevice:[self backDevicetypeFromID:currentDevciceId] serverAddress:self.textfield3.text port:self.textfield4.text.integerValue wifiName:self.textfield1.text password:self.textfield2.text completion:^(BOOL succeed, id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *result=@"";
        if (succeed) {
            NSLog(@"send succeed!");
            result = NSLocalizedString(@"reminder_configuration_success", nil);
//            SLPDeviceInfo *deviceInfo= (SLPDeviceInfo *)data;
//            result =[NSString stringWithFormat:@"deviceId=%@,version=%@",deviceInfo.deviceID,deviceInfo.version];
        }
        else
        {
            NSLog(@"send failed!");
            result = NSLocalizedString(@"reminder_configuration_fail", nil);
        }
        UIAlertView *alertview =[[ UIAlertView alloc]initWithTitle:nil message:result delegate:self cancelButtonTitle:NSLocalizedString(@"btn_ok", nil) otherButtonTitles: nil];
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
//            address = @"http://172.14.1.100:9880";
            address = @"https://webapi.test.sleepace.net";
            break;
        case 1:
//            address = @"172.14.1.100";
            address = @"120.24.169.204";
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
    if (self.textfield3.isEditing) {
        [self.textfield3 resignFirstResponder];
    }
    if (self.textfield4.isEditing) {
        [self.textfield4 resignFirstResponder];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect=self.view.frame;
        CGFloat y_value=rect.origin.y-240;
        rect.origin.y=y_value;
        self.view.frame=rect;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=self.view.frame;
        CGFloat y_value=rect.origin.y+240;
        rect.origin.y=y_value;
        self.view.frame=rect;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
