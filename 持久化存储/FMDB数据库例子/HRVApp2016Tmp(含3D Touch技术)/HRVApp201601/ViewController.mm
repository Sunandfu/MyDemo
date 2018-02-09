//
//  ViewController.m
//  HRVApp201601
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 betterlife. All rights reserved.
//
/*
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


*/


//
//  ViewController.m
//  hrv
//
//  Created by Yan Zhenghang on 15/12/26.
//  Copyright © 2015年 Yan Zhenghang. All rights reserved.


#import "ViewController.h"
/*
#import "PreDealFunc.h"
#import "ParameterDefine.h"
#import "header.h"
#import "ios_ecg_abnormal.h"
 */
#include "PreDealFunc.h"
#include "ParameterDefine.h"
#include "header.h"

#define BUFFER_SIZE  100000
@interface ViewController ()

@end

@implementation ViewController
{
    StressAssess HRV;
}
unsigned char decode_raw(unsigned char raw_data)
{
    raw_data = ((raw_data << 1) & 0xaa) | ((raw_data >> 1) & 0x55);
    raw_data = ((raw_data << 2) & 0xcc) | ((raw_data >> 2) & 0x33);
    return raw_data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15, 20, 40, 40);
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.view.bounds.size.width-20, self.view.bounds.size.height-180)];
    label.numberOfLines = 0;
    label.tag = 666;
    [self.view addSubview:label];
    
//    NSString *FileName1 = [[NSBundle mainBundle] pathForResource:@"1456315105017" ofType:@"ecg"];
//    const char * FileName = [FileName1 UTF8String];
    
    const char * FileName = [self.filePath UTF8String];
    
    FILE *f;
#if 0
    double dataecg = 0;
    long i = 0;
    long num_samples;
    long block = 1;// ˝æ›øÈ ˝
    
    f = fopen(FileName, "r");
    if (f == NULL)
    {
        printf("can not open\n");
    }
    DOUB_ARR ECGlist0;
    ECGlist0.arr = (double*)malloc(sizeof(double)* BUFFER_SIZE);//œ»…Í«Î100000∏ˆ ˝æ›ø’º‰
    //while (!feof(f))
    //for(; i< 15 * 20; )
    for(; i< 250 * 120; )
    {
        fscanf(f, "%lf", &dataecg);
        ECGlist0.arr[i] = (double)((dataecg));//≥˝“‘‘ˆ“Ê
        NSLog(@"arr : %s, %f" , FileName, ECGlist0.arr[i]);
        i++;
        if (i >= (block)*BUFFER_SIZE)//sgsg
        {
            block = block + 1;
            ECGlist0.arr = (double*)realloc(ECGlist0.arr, sizeof(double)* BUFFER_SIZE *block);//œ»…Í«Î100000∏ˆ ˝æ›ø’º‰
            
        }
    }
    fclose(f);
    ECGlist0.count = i - 1;//ECG ˝æ›µƒ∏ˆ ˝
    
#else
#if 0      //double
    unsigned char *pEcgbuf;
    long j = 0;
    unsigned int FileLen;
    DOUB_ARR ECGlist0;
    f = fopen(FileName, "rb");//∂¡
    if (f == NULL)
    {
        printf("Œﬁ∑®¥Úø™\n");
        return;
    }
    fseek(f, 0, SEEK_END); //∂®ŒªµΩŒƒº˛ƒ©
    FileLen = ftell(f); //Œƒº˛≥§∂»
    fseek(f, 0, SEEK_SET);
    
    pEcgbuf = (unsigned char *)malloc(FileLen*sizeof(unsigned char));
    ECGlist0.arr = (double *)malloc(FileLen / 2 * sizeof(double));
    fread(pEcgbuf, sizeof(unsigned char), FileLen, f);
    
    for (int i = 0; i < FileLen;)
    {
        ECGlist0.arr[j] = pEcgbuf[i] * 256 + pEcgbuf[i + 1];//Õ®µ¿
        i = i + 2;
        j = j + 1;
    }
    
    fclose(f);
    ECGlist0.count = j;//ECG ˝æ›µƒ∏ˆ ˝
#else
    unsigned char *pEcgbuf;
    long j = 0;
    unsigned long FileLen;
    DOUB_ARR ECGlist0;
    f = fopen(FileName, "rb");//∂¡
    if (f == NULL)
    {
        printf("Œﬁ∑®¥Úø™\n");
        return;
    }
    fseek(f, 0, SEEK_END); //∂®ŒªµΩŒƒº˛ƒ©
    FileLen = ftell(f); //Œƒº˛≥§∂»
    fseek(f, 0, SEEK_SET);
    
    pEcgbuf = (unsigned char *)malloc(FileLen*sizeof(unsigned char));
    ECGlist0.arr = (double *)malloc(FileLen * sizeof(double));
    fread(pEcgbuf, sizeof(unsigned char), FileLen, f);
    
    for (int i = 0; i < FileLen; i++)
    {
        ECGlist0.arr[i] = pEcgbuf[i]*8;//Õ®µ¿
    }
    
    fclose(f);
    ECGlist0.count = (unsigned int)FileLen;//ECG ˝æ›µƒ∏ˆ ˝
    
    
    
#endif
#endif
    
    struct ecg_result ecg;
    ecg.RRlist.count = 0;
    ecg.RRlist.arr = NULL;
    long *pr = NULL;//RRº‰∆⁄
    int rr_count = 0;//RRº‰∆⁄µƒ∏ˆ ˝
    int *RRhis = NULL;//RR÷±∑ΩÕº ˝æ›
    int lenpsec = 0;//◊‹ ±≥§
    int fs = 250;
    long int len = 0;
    NSLog(@"class main begin");
    maindetect Maindetect;
    
    
    
    double getFs = 250;
    double getK = 200;
    ecg = Maindetect.getecgresult(ECGlist0.arr, ECGlist0.count, getFs, getK);//analysis the ecg data
    ecg.ECGlist = ECGlist0;
    NSLog(@"%d",ecg.AnalysisOk);
    if (ecg.AnalysisOk != 0){
        
        printf("“Ï≥£nnnnnnnnnn ˝æ›£°");
        label.text = @"解析不成功";
        return ;
    }
    
    if (ecg.Rlist.count > 0)
    {
        pr = ecg.RRlist.arr;	//«Û»°»˝Ω«÷∏ ˝
        rr_count = ecg.RRlist.count;
        //int nump = Maindetect.GETHRVTI(pr, &RRhis, rr_count);
    }
    // RRy Œ™R≤®µƒŒª÷√£®µ•ŒªŒ™s)
    // RRx Œ™RRº‰∆⁄
    float *RRx, *RRy;
    RRx = (float*)malloc(ecg.RRlist.count * sizeof (float));
    RRy = (float*)malloc(ecg.RRlist.count * sizeof (float));
    for (int i = 0; i < ecg.RRlist.count; i++) {
        RRx[i] =  (float)(ecg.Rlist.arr[i + 1] -  ecg.Rlist.arr[i]) / fs;
        RRy[i] = (float)ecg.Rlist.arr[i + 1] / fs;
    }
    StressEstimate(RRy, RRx, ecg.RRlist.count, 1, &HRV);
    lenpsec = (int)(ecg.ECGlist.count / fs);//º∆À„ ˝æ› ±≥§
    printf("len=%d,lenpsec=%d", len, lenpsec);
    //FILE *fp;
    //fp = fopen("D:\\RR.txt", "w");
    //for (i = 0; i < ecg.RRlist.count; i++) {
    //	fprintf(fp, "%f\t\t%f\r\n", RRx[i], RRy[i]);
    //}
    //fclose(fp);
    /*
     float ANSBalance;      //Ωª∏–-∏±Ωª∏–…Òæ≠∆Ω∫‚∂»3
     unsigned PsyStress;      //–ƒ¿Ì—π¡¶
     unsigned PhiStress;	  //…ÌÃÂ—π¡¶
     unsigned StressIndex;    //◊€∫œ—π¡¶÷∏ ˝
     unsigned AntiStress;	  //øπ—πƒ‹¡¶
     unsigned HeartFunAge;	  //–ƒ‘‡π¶ƒ‹ƒÍ¡‰ 1£∫«‡…ŸƒÍ£¨2£∫«‡◊≥ƒÍ£¨3£∫÷–ƒÍ£¨4£∫ƒÍ«·¿œ»À£¨5£∫¿œƒÍ
     unsigned Fatigue;	      //∆£¿Õ÷∏ ˝
     unsigned Motion;         //«È–˜
     */
    
    
    printf("\r\nHRV.ANSBalance:Ωª∏–-∏±Ωª∏–…Òæ≠∆Ω∫‚∂»:%f\r\nHRV.PsyStress–ƒ¿Ì—π¡¶:%d\r\nHRV.PhiStress…ÌÃÂ—π¡¶:%d\r\nHRV.StressIndex◊€∫œ—π¡¶÷∏ ˝:%d\r\nHRV.AntiStressøπ—πƒ‹¡¶:%d\r\nHRV.HeartFunAge–ƒ‘‡π¶ƒ‹ƒÍ¡‰:%d\r\nHRV.Fatigue∆£¿Õ÷∏ ˝:%d\r\nHRV.Motion«È–˜%d\r\n",
           HRV.ANSBalance, HRV.PsyStress, HRV.PhiStress, HRV.StressIndex, HRV.AntiStress, HRV.HeartFunAge, HRV.Fatigue, HRV.Motion);
    printf("–ƒ¬ :%d\r\n\n", ecg.HeartRate);
    
    
    // 心律不齐
    int ar = ecg.flagAR;
    printf("心律不齐–ƒ¬ ≤ª∆Îar=%d\n", ar);
    
    //心动过速
    int Poly = ecg.Polycardia;
    printf("心动过速–ƒ∂Øπ˝ÀŸPoly=%d\n", Poly);
    
    //心动过缓
    int brady = ecg.Bradycardia;
    printf("心动过缓–ƒ∂Øπ˝ª∫brady=%d\n", brady);
    
    //停博
    int arrest = ecg.Arrest_Num;
    printf("停博Õ£≤´∏ˆ ˝arrest=%d\n", arrest);
    
    //漏博
    int miseed = ecg.Missed_Num;
    printf("漏博¬©≤´∏ˆ ˝miseed=%d\n", miseed);
    
    //室性早搏
    int pvb = ecg.PVB;
    printf("室性早搏 “–‘‘Á≤´∏ˆ ˝pvb=%d\n", pvb);
    
    
  // 以下六项结果不计，仅仅在胸口数据有效
    
    //宽博
    int wide = ecg.Wide_Num;
    printf("宽博øÌ≤´∏ˆ ˝wide=%d\n", wide);
    
    //房性早搏
    int pab = ecg.PAB;
    printf("房性早搏∑ø–‘‘Á≤´∏ˆ ˝pab=%d\n", pab);
    
    //插入性室性早搏
    int pvbnum = ecg.Insert_PVBnum;
    printf("插入性室性早搏≤Â»Î–‘ “‘Á∏ˆ ˝pvbnum=%d\n", pvbnum);
    
    //室性心动过速
    int vt = ecg.VT;
    printf("室性心动过速 “–‘–ƒ∂Øπ˝ÀŸ∏ˆ ˝vt=%d\n", vt);
    
    //二联律
    int bigeminy = ecg.Bigeminy_Num;
    printf("二联律∂˛¡™¬…∏ˆ ˝bigeminy=%d\n", bigeminy);
    
    //三联律
    int tregeminy = ecg.Trigeminy_Num;
    printf("三联律»˝¡™¬…tregeminy=%d\n", tregeminy);
    getchar();
    
    NSString *string = [NSString stringWithFormat:@"\r\nHRV.ANSBalance:->:%f\r\nHRV.PsyStress->:%d\r\nHRV.PhiStress->:%d\r\nHRV.StressIndex->:%d\r\nHRV.AntiStress->:%d\r\nHRV.HeartFunAge->:%d\r\nHRV.Fatigue->:%d\r\nHRV.Motion->:%d\r\n",
                        HRV.ANSBalance, HRV.PsyStress, HRV.PhiStress, HRV.StressIndex, HRV.AntiStress, HRV.HeartFunAge, HRV.Fatigue, HRV.Motion];
    label.text = [NSString stringWithFormat:@"%@\n心律不齐->%d\n 心动过速->%d\n 心动过缓->%d\n 停博->%d\n 漏博->%d\n 室性早搏->%d\n 宽博->%d\n 房性早搏->%d\n 插入性室性早搏->%d\n 室性心动过速->%d\n 二联律->%d\n 三联律->%d\n",string,ar,Poly,brady,arrest,miseed,pvb,wide,pab,pvbnum,vt,bigeminy,tregeminy];
    /*
     int ar = ecg.flagAR;
     printf("–ƒ¬ ≤ª∆Îar=%d\n", ar);
     
     int Poly = ecg.Polycardia;
     printf("–ƒ∂Øπ˝ÀŸPoly=%d\n", Poly);
     
     int brady = ecg.Bradycardia;
     printf("–ƒ∂Øπ˝ª∫brady=%d\n", brady);
     
     int arrest = ecg.Arrest_Num;
     printf("Õ£≤´∏ˆ ˝arrest=%d\n", arrest);
     
     int miseed = ecg.Missed_Num;
     printf("¬©≤´∏ˆ ˝miseed=%d\n", miseed);
     
     int wide = ecg.Wide_Num;
     printf("øÌ≤´∏ˆ ˝wide=%d\n", wide);
     
     int pvb = ecg.PVB;
     printf(" “–‘‘Á≤´∏ˆ ˝pvb=%d\n", pvb);
     
     int pab = ecg.PAB;
     printf("∑ø–‘‘Á≤´∏ˆ ˝pab=%d\n", pab);
     
     int pvbnum = ecg.Insert_PVBnum;
     printf("≤Â»Î–‘ “‘Á∏ˆ ˝pvbnum=%d\n", pvbnum);
     
     int vt = ecg.VT;
     printf(" “–‘–ƒ∂Øπ˝ÀŸ∏ˆ ˝vt=%d\n", vt);
     
     int bigeminy = ecg.Bigeminy_Num;
     printf("∂˛¡™¬…∏ˆ ˝bigeminy=%d\n", bigeminy);
     
     int tregeminy = ecg.Trigeminy_Num;
     printf("»˝¡™¬…tregeminy=%d\n", tregeminy);
     getchar();
     
     */
    
}
- (void)btnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    UILabel *label = (UILabel *)[self.view viewWithTag:666];
    label.text = @"我只是测试3D Touch技术";
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"返回" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if ([self.delegate respondsToSelector:@selector(detailViewControllerDidSelectedBackItem:)]) {
            [self.delegate detailViewControllerDidSelectedBackItem:self];
        }
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"刷新" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if ([self.delegate respondsToSelector:@selector(detailViewController:DidSelectedDeleteItem:)]) {
            [self.delegate detailViewController:self DidSelectedDeleteItem:@"刷新"];
        }
    }];
    NSArray *actions = @[action1,action2];
    return actions;
}

@end
