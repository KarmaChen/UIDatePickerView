//
//  ViewController.m
//  UIDatePickerModeCountDownTimer
//
//  Created by Karma on 16/6/1.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIDatePicker *myDatePicker;
@property (nonatomic, strong) UIButton *Btn;//开始执行倒计时的按钮
@property (nonatomic, strong) UIButton *functionBtn;//执行暂停，继续的按钮
@property (nonatomic, strong) NSTimer *myTime;
@property (nonatomic, assign) NSInteger seconds;//存放倒计时器的剩余时间
@property (nonatomic, strong) UIAlertController *myAlert;//是否使用指定时间长度开始倒计时的警告框
@property (nonatomic, strong) UILabel *timeLabel;
@end
BOOL stopFlag = YES;//functionBtn的title是否为暂停
BOOL startFlag = YES;//Btn的title是否为开始
@implementation ViewController

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 240, 100, 30)];
        _timeLabel.backgroundColor = [UIColor grayColor];
        _timeLabel.textAlignment = YES;//设置文字居中
    }
    return _timeLabel;
}
- (UIAlertController *)myAlert{
    if (!_myAlert) {
        self.seconds = self.myDatePicker.countDownDuration;
        NSString *message = [NSString stringWithFormat:@"开始倒计时？还剩下［%ld］秒",self.seconds];
        _myAlert = [UIAlertController alertControllerWithTitle:@"倒计时" message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:_myAlert animated:YES completion:nil];
        UIAlertAction *myAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.myDatePicker.enabled = NO;
            [self.Btn setTitle:@"重置" forState:UIControlStateNormal];
            self.functionBtn.enabled = YES;
            self.functionBtn.backgroundColor = [UIColor blueColor];
            [self.view addSubview:self.timeLabel];
            [self.myDatePicker removeFromSuperview];
            //设置计时器每隔一秒调用一次tickDown方法
            self.myTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tickDown) userInfo:nil repeats:YES];
        }];
        UIAlertAction *cancerAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [_myAlert addAction:myAction];
        [_myAlert addAction:cancerAction];
    }
    return _myAlert;
}
- (UIButton *)Btn{
    if (!_Btn) {
        _Btn = [[UIButton alloc] initWithFrame:CGRectMake(180, 430, 50, 30)];
        [_Btn setTitle:@"开始" forState:UIControlStateNormal];
        [_Btn addTarget:self action:@selector(startOrReset:) forControlEvents:
         UIControlEventTouchUpInside];
        _Btn.backgroundColor = [UIColor redColor];
        [self.view addSubview:_Btn];
    }
    return _Btn;
}
- (UIButton *)functionBtn{
    if (!_functionBtn) {
        _functionBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 430, 50, 30)];
        [_functionBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [_functionBtn addTarget:self action:@selector(stopOrGo:) forControlEvents:
         UIControlEventTouchUpInside];
        _functionBtn.enabled = NO;
        _functionBtn.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_functionBtn];
    }
    return  _functionBtn;
}
- (UIDatePicker *)myDatePicker{
    if (!_myDatePicker) {
        _myDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 198, 375, 216)];
        //设置该UIDatePicker的模式
        _myDatePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        [self.view addSubview:_myDatePicker];
    }
    return _myDatePicker;
}
//设置剩余时间及设置label要显示的内容
- (void)tickDown{
    self.seconds = self.seconds - 1;
    self.timeLabel.text = [self count:self.seconds];
    if (_seconds <= 0) {
        [self.myTime invalidate];
        self.myDatePicker.enabled = YES;
        self.Btn.enabled = YES;
        self.functionBtn.enabled = NO;
        self.functionBtn.backgroundColor = [UIColor grayColor];
    }
}
//传入要倒计时的秒数，输出相对应的字符串
- (NSString *)count: (NSInteger) date{
    NSString *str = [[NSString alloc] init];
    //如果大于60分钟显示三个数字
    if (date / (60 * 60) >= 1) {
        NSInteger h = date / (60 * 60);
        NSInteger m = (date % (60 * 60)) / 60;
        NSInteger s = (date % (60 * 60)) % 60;
        str = [NSString stringWithFormat:@"%ld:%ld:%ld",h,m,s];
    }
    else
    {
        NSInteger m = date / 60;
        NSInteger s = date % 60;
        str = [NSString stringWithFormat:@"%ld:%ld",m,s];
    }
    return str;
}
//开始和重置按钮的功能实现
- (void)startOrReset: (id)sender{
    if (startFlag) {
        [self myAlert];
        startFlag = NO;
    }
    else
    {
        // 点击重置以后将按钮文字改为开始，同时移除label添加DatePicker
        self.timeLabel.text = nil;
        [self.Btn setTitle:@"开始" forState:UIControlStateNormal];
        [self.timeLabel removeFromSuperview];
        [self.view addSubview:_myDatePicker];
        [self.myTime invalidate];
        self.myTime = nil;
        self.myDatePicker.enabled = YES;
        startFlag = YES;
        self.functionBtn.enabled = NO;
        self.functionBtn.backgroundColor = [UIColor grayColor];
        [self.functionBtn setTitle:@"暂停" forState:UIControlStateNormal];
        self.myAlert = nil;
    }
}
//继续和暂停按钮的功能实现
- (void)stopOrGo: (id)sender{
    if (stopFlag) {
        stopFlag = NO;
        //暂停计时器
        [self.myTime setFireDate:[NSDate distantFuture]];
        [self.functionBtn setTitle:@"继续" forState:UIControlStateNormal];
    }
    else{
        stopFlag = YES;
        //启动计时器
        [self.myTime setFireDate:[NSDate distantPast]];
        [self.functionBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self myDatePicker];
    [self Btn];
    [self functionBtn];
    [self timeLabel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
