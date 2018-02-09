//
//  NextViewController.m
//  MyProject
//
//  Created by 小富 on 16/3/22.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController (){
    NSString *urlChoose;
    UILabel *label;
    NSInteger k;
    UIImageView *imageView;
}

@property (nonatomic, copy) NSString* yesurl;
@property (nonatomic, copy) NSString* nourl;
@property (nonatomic, copy) NSString* notsureurl;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.pushID isEqualToString:@"gameFirst"]) {
        [self gameFirst];
    } else if ([self.pushID isEqualToString:@"gameSecond"]) {
        [self gameSecond];
    }
    
}
- (void)gameSecond{
    
}
- (void)gameFirst{
    NSArray *array=@[@"YES",@"NO",@"Don't Know"];
    CGFloat btnWidth = 100;
    CGFloat setLeft = (kScreenWidth-btnWidth*2-80)/2;
    for (NSInteger i=0; i<3; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(setLeft+i*btnWidth, kScreenHeight*0.7, 80, 30);
        [button setTitle:[NSString stringWithFormat:@"%@",array[i]] forState:UIControlStateNormal];
        button.tag=100+i;
        [self.view addSubview:button];
        button.userInteractionEnabled = NO;
        [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    label=[[UILabel alloc]initWithFrame:CGRectMake(25, kScreenHeight*0.4, kScreenWidth-50, 50)];
    label.text=@"";
    label.numberOfLines=0;
    [self.view addSubview:label];
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-65, kScreenHeight*0.1, 130, 130)];
    imageView.image=[UIImage imageNamed:@"2.jpg"];
    [self.view addSubview:imageView];
    
    
    k=1;
    
    [self customUI];
}
-(void)customUI
{
    NSString *url = @"http://renlifang.msra.cn/Q20/api/gamestart.ashx?alias=WP7&stamp=366";
    [self request:url];
    
}
-(void)onButtonClick:(UIButton*)sender
{
    if (sender.tag==100) {
        [self  request:self.yesurl];
    }else if (sender.tag==101){
        [self request:self.nourl];
    }else if (sender.tag==102){
        [self request:self.notsureurl];
    }
}
-(void)request:(NSString *)url
{
    [NetRequestManager GET:url parame:nil SUccess:^(AFHTTPRequestOperation *operation, id reponseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:reponseObject options:NSJSONReadingMutableLeaves error:nil];
        if (k==1) {
            k=2;
            [self request:dic[@"starturl"]];
        } else {
            if ([dic[@"step"] intValue]== 1){
                label.text=dic[@"qtext"];
                self.yesurl=dic[@"yesurl"];
                self.nourl=dic[@"nourl"];
                self.notsureurl=dic[@"notsureurl"];
                
                if (k==2) {
                    for (int i=0; i<3; i++) {
                        UIButton *button = (UIButton *)[self.view viewWithTag:100+i];
                        button.userInteractionEnabled = YES;
                    }
                    k=3;
                }
                
            }else if([dic[@"step"] intValue]==2){
                label.text=[NSString stringWithFormat:@"小主想的是：%@",dic[@"guessname"]];
                label.textAlignment = NSTextAlignmentCenter;
                NSString* imageUrl = [NSString stringWithFormat:@"http://renlifang.msra.cn/portrait.aspx?id=%@", dic[@"pid"]];
                NSLog(@"%@",imageUrl);
                //拿到图片
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
            }
        }
    } failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        if ([NetRequestManager sharedNetworking].networkStats == StatusNotReachable) {
            label.text = @"请检查你的网络连接网络连接";
        } else {
            label.text = @"                服务器关闭，该功能暂停使用";
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
