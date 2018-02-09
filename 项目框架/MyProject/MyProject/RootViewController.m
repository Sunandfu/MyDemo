//
//  RootViewController.m
//  fruitLink
//
//  Created by gdy on 14-11-21.
//  Copyright (c) 2014年 郭东洋. All rights reserved.
//

#import "RootViewController.h"

//定义行和列
#define Row 11
#define Col 10

#define selectedColor  [UIColor greenColor]


@interface RootViewController ()
{
    UIButton* _curButton;
    UIButton* _LastButton;
    int btnNumber;
    int map[Row][Col];
}
@property (nonatomic, strong) NSMutableArray *btnArray;
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    btnNumber = 0;
    self.btnArray = [NSMutableArray array];
    //视图背景色
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.alpha = 0.5;
    [self createStartAndStop];
}

#pragma mark --开始和结束按钮--
-(void)createStartAndStop
{

    //开始按钮
    UIButton* buttonStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStart.frame = CGRectMake(kMainScreenWidth*0.2, kScreenHeight*0.7, 60, 30);
    [buttonStart addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
    [buttonStart setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:buttonStart];
    
    //结束按钮
    UIButton* buttonStop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStop.frame = CGRectMake(kMainScreenWidth*0.8-60, kScreenHeight*0.7, 60, 30);
    [buttonStop addTarget:self action:@selector(stopGame:) forControlEvents:UIControlEventTouchUpInside];
    [buttonStop setTitle:@"结束" forState:UIControlStateNormal];
    [self.view addSubview:buttonStop];
}

#pragma mark  --创建按钮--
-(void)createButtons
{
    //初始化 两个按钮
    _curButton = nil;
    _LastButton = nil;
     

    CGFloat width = kScreenWidth/Row;
    for(int i=0;i<Row;i++)//行
    {
        for(int j=0;j<Col;j++)//列
        {
            map[i][j] = 1;//设置初始值    表示   按钮没有消除
            UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //button.backgroundColor = [UIColor redColor];
            //添加事件
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            //设置标志
            button.tag = i*Col+j+1;//从1开始
            //设置大小
            button.frame = CGRectMake(j*width+10,i*width+50, width, width);
            [self.view addSubview:button];
            [self.btnArray addObject:button];
        }
    }
    btnNumber = (int)self.btnArray.count;
#pragma mark  --设置图片--
    
    //设置图片、   一定要保证每个图片出现的次数为偶数  不然消除不完
    
    int random = 0;//随机数 表示随机获取某个图片
    int fruit[Row] = {0};  //表示某个图片的  个数（为偶数）
    for(int i=1;i<=Row*Col;i++)
    {
        UIButton* button = (UIButton*)[self.view viewWithTag:i];//获取按钮
        
        random = arc4random()%(Row);//获取一个随机数
        //NSLog(@"%d",random);
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"q%d.png",random]];//随机获取一个图片          //也可以通过数组实现
        fruit[random]++;// 这个图片的个数 加1
        if(fruit[random] < Row)
        {
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
        }
        else//不是偶数
        {
            i--;//重做
            fruit[random]--;
        }
    }
    
    

}

#pragma mark --处理按钮点击--
-(void)buttonClick:(UIButton*)curButton
{
    if(_curButton == nil)//如果当前点击按钮为空
    {
        _curButton = curButton;  //赋值给当前
        _curButton.backgroundColor = selectedColor;   //设置选中背景色
    }
    else//当前按钮不为空
    {
        _LastButton = _curButton;//把当前赋值给 上一个
        _curButton = curButton;//把新的赋值给当前
        NSLog(@"%@==%@",_LastButton.currentBackgroundImage,_curButton.currentBackgroundImage);
        NSData *dataLast = UIImagePNGRepresentation(_LastButton.currentBackgroundImage);
        NSData *dataCur = UIImagePNGRepresentation(_curButton.currentBackgroundImage);
        if ([dataLast isEqual:dataCur])//背景图片是否相同
        {
            if(_LastButton == _curButton)//判断是否是同一个按钮
            {
                _curButton  = curButton;
                _LastButton.backgroundColor = [UIColor clearColor];
                _curButton.backgroundColor = selectedColor;
                _LastButton = nil;
            }
            else  //不是同一个按钮
            {
                //路线是否走通
                if([self linkSuccess])//            线路走的同成功
                {
                    //分别获取两个 按钮的  坐标   (最后一行和最后一列特殊处理）
                    int last_x = (int)_LastButton.tag/Col;
                    if(_LastButton.tag / 10 == 10)//最后一行
                    {
                        last_x = Row - 1;
                    }
                    int last_y = _LastButton.tag%Col-1;
                    if(_LastButton.tag %10 == 0)//最后一列
                    {
                        last_y = Col - 1;
                        last_x = (int)_LastButton.tag/Col - 1;
                    }
                    //current
                    int cur_x = (int)_curButton.tag/Col;
                    if(_curButton.tag /10 == 10)
                    {
                        cur_x = Row - 1;//最后一行
                    }
                    int cur_y = _curButton.tag%Col - 1;
                    if(_curButton.tag %10 == 0)
                    {
                        cur_y = Col - 1;
                        cur_x = (int)_curButton.tag/Col - 1;
                    }
                    
                    [_LastButton removeFromSuperview];
                    [_curButton removeFromSuperview];
                    _LastButton = nil;
                    _curButton = nil;
                    btnNumber--;
                    
                    //消除之后  标志设置为  0
                    map[last_x][last_y] = 0;
                    map[cur_x][cur_y] = 0;
                    
                }
                else//走不通 怎么处理
                {
                    _curButton  = curButton;
                    _LastButton.backgroundColor = [UIColor clearColor];
                    _curButton.backgroundColor = selectedColor;
                    _LastButton = nil;
                }

            }
            
        }
        else//不相等  把
        {
            _curButton = curButton;
            _LastButton.backgroundColor = [UIColor clearColor];
            _curButton.backgroundColor = selectedColor;//选中颜色
            _LastButton = nil;
        }
    }
    
    //判断是否通关
    NSLog(@"%d",btnNumber);
    if(btnNumber == self.btnArray.count/2)
    {
        UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"成功" message:@"已经通关" delegate:self cancelButtonTitle:@"不来了" otherButtonTitles:@"再来一局" , nil];
        [alert show];
    }
    
    
//    for(int i=0;i<Row;i++)
//    {
//        for(int j=0;j<Col;j++)
//        {
//            printf("%4d",map[i][j]);
//        }
//        printf("\n");
//    }
    
//    printf("\n\n");
    
    
}

#pragma mark --开始和结束按钮处理函数--
-(void)startGame:(UIButton*)startButton
{
    _curButton = nil;
    _LastButton = nil;
    for(int i=0;i<Row;i++)
        for(int j=0;j<Col;j++)
        {
            map[i][j] = 1;
            UIButton* button = (UIButton*)[self.view viewWithTag:((i*Col)+j+1)];
            [button removeFromSuperview];
        }
    [self viewDidLoad];
    [self createButtons];
}

-(void)stopGame:(UIButton*)stopButton
{
    exit(0);
}

#pragma mark --  处理alert --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
//        exit(0);//结束程序
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1)
    {
        [self viewDidLoad];//重新加载
    }
}

#pragma mark --路线是否畅通--
-(BOOL)linkSuccess
{
    //位置的大小         根据位置来做处理
    UIButton* minButton = _curButton.tag > _LastButton.tag?_LastButton:_curButton;//左上方
    UIButton* maxButton = _curButton.tag > _LastButton.tag?_curButton:_LastButton;//右下方
    //获取连个  按钮的坐标
    //***************************************************************左上方按钮坐标处理
    int min_x = (int)minButton.tag/Col;
    if(minButton.tag / Col == Col)//  最后一行
    {
        min_x = Row - 1;
    }
    //最后一列的坐标  特殊  处理
    int min_y = minButton.tag%Col-1;
    if(minButton.tag % Col == 0)
    {
        min_y = Col - 1;
        min_x = (int)minButton.tag/Col - 1;//为最后一列，  X坐标要减去  1
    }
    //***************************************************************右下方按钮坐标处理
    //最后一列的坐标  特殊  处理
    int max_x = (int)maxButton.tag/Col;
    if(maxButton.tag / Col == Col)//  最后一行
    {
        max_x = Row - 1;
    }
    //y坐标
    int max_y = maxButton.tag%10-1;
    if(maxButton.tag % Col == 0)
    {
        max_y = Col - 1;
        max_x = (int)maxButton.tag/Col - 1;//如果是最后一列  那么要 x坐标要  减去 1
    }

    //******************************************主要算法   实现
    
    //****************************************设置一些标志
    int closeToMin = 0;//和最小的挨着
    int directToMin = 0;//和最小的直连
    int closeToMax = 0;//和最大的直连
    int directToMax = 0;//和最大的直连
    int x,y;
    int flag = 0;

   
    
    //*************************************************************第一种情况   直连（没有拐角）
    if(min_x == max_x)//x坐标相等    横着直连
    {
        //特殊情况     在第一行和  最后一行
        if(min_x == 0 || max_x == Row-1)
        {
            return YES;
        }
        
        //判断是否挨着
        if(min_y == (max_y - 1))
        {
            return YES;
        }
        else//不挨着
        {
            for(int i=(min_y+1);i<max_y;i++) //比较Y
            {
                if(map[min_x][i] == 0)//两者之间没有   任何  按钮
                {
                    continue;  //如果没有  继续下一个循环
                }
#pragma mark   --同行两个拐点--
                else//   *********    在判断中间是否有有障碍  如果有，判断两个拐点
                {
                    
                    /*******************************************************两个拐点
                     ************************************************选取的点坐标（i,y) 上班部分*/
                     #pragma mark  --从上半部分--
                    for(int i=(min_x-1);i>=0;i--)//x坐标
                    {
                        //处理特殊  i==0上半部分
                        if(i==0)
                        {
                            if(map[i][min_y]==0)
                            {
                                for(int j=0;j<max_x;j++)
                                {
                                    if(map[j][max_y]==0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                        }
                        
                        
                        closeToMax = 0;
                        closeToMin = 0;
                        directToMax = 0;
                        directToMin = 0;
                        y = min_y;
                        
                        //第一个选取的点   (i,y)
                        //判断两个水果是否 挨着
                        if(i == (min_x -1))
                        {
                            closeToMin = 1;
                        }
                        else//不挨着
                        {
                            for(int j=(min_x-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                            {
                                if(map[j][y] == 0)
                                {
                                    directToMin = 1;
                                }
                                else
                                {
                                    directToMin = 0;
                                    break;
                                }
                            }
                        }
                        //判断是否通过一个  拐点   找到   最大的按钮
                        if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                        {
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                            //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                            if(y == (max_y-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=(y+1);j<max_y;j++)
                                {
                                    if(map[i][j] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            
                            if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                            {
                                //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                if(i == (max_x-1))
                                {
                                    closeToMax = 1;
                                }
                                else
                                {
                                    for(int j=(i+1);j<max_x;j++)
                                    {
                                        if(map[j][max_y] == 0)
                                        {
                                            directToMax = 1;
                                        }
                                        else
                                        {
                                            directToMax = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                {
                                    return YES;
                                }
                                else
                                {
                                    break;
                                
                                }
                            }
                            else
                            {
                                continue;
                                
                            }
                            
                        }
                        else  //选取的第一个点和 和最小的不直连
                        {

                            flag = 0;
                            break;
                            
                            
                        }

                }
                    #pragma mark  --从下半部分--
                    for(int i=min_x+1;i<=Row;i++)
                    {
                        
                        //特殊处理  i==11
                        if(i==Col)
                        {
                            if(map[i][min_y]==0)
                            {
                                for(int j=max_x+1;j<Row;j++)
                                {
                                    if(map[j][max_y]==0)
                                    {
                                        flag =1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                        }
                        
                     closeToMax = 0;
                     closeToMin = 0;
                     directToMax = 0;
                     directToMin = 0;
                     y = min_y;
                     //选取第一个点得坐标(i,y)
                     if(min_x == (i-1))
                     {
                         closeToMin = 1;
                     }
                     else
                     {
                         for(int j=min_x+1;j<i;j++)
                         {
                             if(map[j][y] == 0)
                             {
                                 directToMin = 1;
                             }
                             else
                             {
                                 directToMin = 0;
                                    break;
                             }
                         }
                     }
                     if((closeToMin || directToMin) && map[i][y] == 0)
                     {
                     closeToMax = 0;
                     closeToMin = 0;
                     directToMax = 0;
                     directToMin = 0;
                     
                     //是否和最大的有一个拐点
                     //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                     if(y == (max_y-1))
                     {
                     closeToMin = 1;
                     }
                     else
                     {
                     for(int j=y+1;j<max_y;j++)
                     {
                     if(map[i][j] == 0)
                     {
                     directToMin = 1;
                     }
                     else
                     {
                     directToMin = 0;
                     break;
                     }
                     }
                     }
                     if((closeToMin || directToMin)&& map[i][max_y]==0)
                     {
                     if(max_x == (i-1))
                     {
                     closeToMax = 1;
                     }
                     else
                     {
                     for(int j=max_x+1;j<i;j++)
                        {
                            if(map[j][max_y] == 0)
                        {
                         directToMax = 1;
                        }
                        else
                        {
                         directToMax = 0;
                         break;
                            }
                        }
                        }
                    if((closeToMax || directToMax)&& map[i][max_y]==0)
                        {
                         return YES;
                        }
                        else
                        {
                            break;
                        }
                        }
                        else
                        {
                            continue;
                        }
                     
                     
                     }
                     else
                     {
                         break;
                     }
                     
                     
                     
                     
                     
                     }
                    
                    //两个拐点也没有走通
                    return NO;

                }
   
            }
            return YES;//全部走完 没有障碍
        }
        
    }
    else if(min_y == max_y) //y坐标相等  ***************************************   竖着直连
    {
        //特殊情况     在第一列和  最后一列
        if(min_y == 0 || max_y == (Col-1))
        {
            return YES;
        }
        
        //判断两个水果是否 挨着
        if(min_x == (max_x -1))
        {
            return YES;
        }
        else//不挨着
        {
            for(int i=(min_x + 1);i<max_x;i++)//+1  为了从最小的下一个 进行比较
            {
                if(map[i][min_y] == 0)
                {
                    //继续走 判断下一个
                    continue;
                }
#pragma mark  --竖着两个之间有两个拐点  的处理--
                else
                {
#pragma mark --左半部分--
                    for(int i=min_y-1;i>=0;i--)
                    {
                        //处理特殊  i==0左半部分
                        if(i==0)
                        {
                            if(map[min_x][i]==0)
                            {
                                for(int j=0;j<max_y;j++)
                                {
                                    if(map[max_x][j]==0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                        }
                        
                        
                        closeToMax = 0;
                        closeToMin = 0;
                        directToMax = 0;
                        directToMin = 0;
                        x = min_x;
                        
                        //第一个选取的点   (x,i)
                        //判断两个水果是否 挨着
                        if(i == (min_y -1))
                        {
                            closeToMin = 1;
                        }
                        else//不挨着
                        {
                            for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                            {
                                if(map[x][j] == 0)
                                {
                                    directToMin = 1;
                                }
                                else
                                {
                                    directToMin = 0;
                                    break;
                                }
                            }
                        }
                        //判断是否通过一个  拐点   找到   最大的按钮
                        if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                        {
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                            //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                            if(x == (max_x-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=(x+1);j<max_x;j++)
                                {
                                    if(map[j][i] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            
                            if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                            {
                                //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                if(i == (max_y-1))
                                {
                                    closeToMax = 1;
                                }
                                else
                                {
                                    for(int j=(i+1);j<max_y;j++)
                                    {
                                        if(map[max_x][j] == 0)
                                        {
                                            directToMax = 1;
                                        }
                                        else
                                        {
                                            directToMax = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                {
                                    return YES;
                                }
                                else
                                {
                                    break;
                                    
                                }
                            }
                            else
                            {
                                continue;
                                
                            }
                            
                        }
                        else  //选取的第一个点和 和最小的不直连
                        {
                            
                            flag = 0;
                            break;
                            
                            
                        }
                    }
#pragma mark --右半部分--
                    for(int i=min_y+1;i<Col;i++)
                    {
                        //处理特殊  i==0左半部分
                        if(i==9)
                        {
                            if(map[min_x][i]==0)
                            {
                                for(int j=max_y+1;j<=9;j++)
                                {
                                    if(map[max_x][j]==0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                        }
                        
                        
                        closeToMax = 0;
                        closeToMin = 0;
                        directToMax = 0;
                        directToMin = 0;
                        x = min_x;
                        
                        //第一个选取的点   (x,i)
                        //判断两个水果是否 挨着
                        if(i-1 == min_y)
                        {
                            closeToMin = 1;
                        }
                        else//不挨着
                        {
                            for(int j=(min_y+1);j<Col;j++)//+1  为了从最小的下一个 进行比较
                            {
                                if(map[x][j] == 0)
                                {
                                    directToMin = 1;
                                }
                                else
                                {
                                    directToMin = 0;
                                    break;
                                }
                            }
                        }
                        //判断是否通过一个  拐点   找到   最大的按钮
                        if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                        {
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                            //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                            if(x == (max_x-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=(x+1);j<max_x;j++)
                                {
                                    if(map[j][i] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            
                            if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                            {
                                //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                if(i == (max_y+1))
                                {
                                    closeToMax = 1;
                                }
                                else
                                {
                                    for(int j=(max_y+1);j<i;j++)
                                    {
                                        if(map[max_x][j] == 0)
                                        {
                                            directToMax = 1;
                                        }
                                        else
                                        {
                                            directToMax = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                {
                                    return YES;
                                }
                                else
                                {
                                    break;
                                    
                                }
                            }
                            else
                            {
                                continue;
                                
                            }
                            
                        }
                        else  //选取的第一个点和 和最小的不直连
                        {
                            
                            flag = 0;
                            break;
                            
                            
                        }

                    }
                    
                    
                    return NO;//连个拐点也没有走通
                }
            }
            return YES;
        }
        
    }
    //*************************************************************第二种情况 （有一个拐角）
    //两个按钮组成一个  矩形， 如果通过任一一个顶点  和 这两个图片都  直连
    //(min_x,min_y)       (max_x,max_y)
    
#pragma mark --第三种情况--
    else if(min_x != max_x && min_y != max_y)//x和y都不相等
    {
        //******************************************查找      右上方 顶点，判断是否和两个按钮直连
        
        
        //(x,y)         右上方顶点  只需要   和   最小tag按钮的  x轴直连
        //******************************判断是否和 最小的Min直连
        //判断是否挨着
  #pragma mark  --最小在最大左边--
        if(min_y < max_y)
        {
            
            if(min_y==0)
            {
                flag = 0;
                for(int j=0;j<max_y;j++)
                {
                    if(map[max_x][j] == 0)
                    {
                        flag = 1;
                    }
                    else
                    {
                        flag = 0;
                        break;
                    }
                }
                
                if(flag == 1)
                {
                    return YES;
                }
            }
            
            
            
            
            
            if(max_y==9)
            {
                flag = 0;
                for(int j=min_y+1;j<Col;j++)
                {
                    if(map[min_x][j] == 0)
                    {
                        flag = 1;
                    }
                    else
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 1)
                {
                    return YES;
                }
            }
            
            
            
            if(min_x == 0)
            {
                flag = 0;
                for(int j=0;j<max_x;j++)
                {
                    if(map[j][max_y] == 0)
                    {
                        flag = 1;
                    }
                    else
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 1)
                {
                    return  YES;
                }
            }
            
            
            if(max_x==Col)
            {
                flag = 0;
                for(int j=min_x+1;j<Row;j++)
                {
                    if(map[j][min_y] == 0)
                    {
                        flag = 1;
                    }
                    else
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 1)
                {
                    return YES;
                }
            }

            
            
            
            
            
            //先找 右上方
            x = min_x;
            y = max_y;
                //directToMin = 1  直连
                if(min_y == (y - 1))
                {
                    closeToMin = 1;
                }
                else//不挨着
                {
                    for(int i=(min_y+1);i<y;i++) //比较Y
                    {
                        if(map[min_x][i] == 0)//两者之间没有   任何  按钮
                        {
                            directToMin = 1;
                            //continue;
                        }
                        else
                        {
                            directToMin = 0;
                            break;
                        }
                    }
                    //全部走完 没有障碍   和最小的直连
                }
            
            if((directToMin || closeToMin) && map[x][y]==0)//右上方      和最小的直连         链接最小成功
            {
                //***********************判断是否和 最大的Max直连
                //判断两个水果是否 挨着
                if(x == (max_x -1))
                {
                    closeToMax = 1;
                }
                else//不挨着
                {
                    for(int i=(x + 1);i<max_x;i++)//+1  为了从最小的下一个 进行比较
                    {
                        if(map[i][y] == 0)
                        {
                            directToMax = 1;
                        }
                        else
                        {
                            directToMax = 0;//有障碍
                            break;
                        }
                    }
                }
                if((closeToMax || directToMax) && map[x][y] == 0)//右上方    和   最大   直连
                {
                    return YES;
                }
                else//没有成功    判断    左下方
                {
                    //****************************************************************左下方按钮是否直连
                    //对左下方的   顶点进行判断
                    int x = max_x;
                    int y = min_y;
                    
                    //最小的按钮
                    //判断是否挨着
                    if(min_x == (x - 1))
                    {
                        closeToMin = 1;
                    }
                    else//不挨着
                    {
                        for(int i=(min_x+1);i<x;i++) //比较Y
                        {
                            if(map[i][y] == 0)//两者之间没有   任何  按钮
                            {
                                directToMin = 1;
                            }
                            else
                            {
                                directToMin = 0;
                                break;
                            }
                        }
                    }
                    if((closeToMin  || directToMin)&& map[x][y]==0) //左下方   直连  最小
                    {
                            //比较最大
                            //***********************判断是否和 最大的Max直连
                            //判断两个水果是否 挨着
                            if(y == (max_y -1))
                            {
                                closeToMax = 1;
                            }
                            else//不挨着
                            {
                                for(int i=(y + 1);i<max_y;i++)//+1  为了从最小的下一个 进行比较
                                {
                                    if(map[x][i] == 0)
                                    {
                                        directToMax = 1;
                                    }
                                    else
                                    {
                                        directToMax = 0;
                                        break;
                                    }
                                }
                            }
                            if((closeToMax || directToMax) && map[x][y] == 0)
                            {
                                return YES;
                            }
                            else
                            {
                                //和 最大按钮  相连的 两条边没有走通
#pragma mark --处理正确的33333333444444444444444444444--
                                //尝试
#pragma mark --左半部分3333333--
                                for(int i=min_y-1;i>=0;i--)
                                {
                                    if(min_y==0)
                                    {
                                        flag = 0;
                                        for(int j=0;j<max_y;j++)
                                        {
                                            if(map[max_x][j] == 0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                    //处理特殊  i==0左半部分
                                    if(i==0)
                                    {
                                        if(map[min_x][i]==0)
                                        {
                                            for(int j=0;j<max_y;j++)
                                            {
                                                if(map[max_x][j]==0)
                                                {
                                                    flag = 1;
                                                }
                                                else
                                                {
                                                    flag = 0;
                                                    break;
                                                }
                                            }
                                            if(flag == 1)
                                            {
                                                return YES;
                                            }
                                        }
                                    }
                                    
                                    
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    x = min_x;
                                    
                                    //第一个选取的点   (x,i)
                                    //判断两个水果是否 挨着
                                    if(i == (min_y -1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else//不挨着
                                    {
                                        for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                        {
                                            if(map[x][j] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    //判断是否通过一个  拐点   找到   最大的按钮
                                    if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                    {
                                        closeToMax = 0;
                                        closeToMin = 0;
                                        directToMax = 0;
                                        directToMin = 0;
                                        //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                                        //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                        if(x == (max_x-1))
                                        {
                                            closeToMin = 1;
                                        }
                                        else
                                        {
                                            for(int j=(x+1);j<max_x;j++)
                                            {
                                                if(map[j][i] == 0)
                                                {
                                                    directToMin = 1;
                                                }
                                                else
                                                {
                                                    directToMin = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                        {
                                            //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                            if(i == (max_y-1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=(i+1);j<max_y;j++)
                                                {
                                                    if(map[max_x][j] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {
                                                continue;
                                                
                                            }
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                        
                                    }
                                    else  //选取的第一个点和 和最小的不直连
                                    {
                                        
                                        
                                        break;
                                        
                                        
                                    }
                                }
#pragma mark  --从右半部分--
                                for(int i=min_y+1;i<Col;i++)
                                {
                                    //处理特殊  i==0左半部分
                                    
                                    if(i==9)
                                    {
                                        if(map[min_x][i]==0)
                                        {
                                            for(int j=max_y+1;j<=9;j++)
                                            {
                                                if(map[max_x][j]==0)
                                                {
                                                    flag = 1;
                                                }
                                                else
                                                {
                                                    flag = 0;
                                                    break;
                                                }
                                            }
                                            if(flag == 1)
                                            {
                                                return YES;
                                            }
                                        }
                                    }
                                    
                                    
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    x = min_x;
                                    
                                    //第一个选取的点   (x,i)
                                    //判断两个水果是否 挨着
                                    if(i-1 == min_y)
                                    {
                                        closeToMin = 1;
                                    }
                                    else//不挨着
                                    {
                                        for(int j=(min_y+1);j<i;j++)//+1  为了从最小的下一个 进行比较
                                        {
                                            if(map[x][j] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    //判断是否通过一个  拐点   找到   最大的按钮
                                    if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                    {
                                        closeToMax = 0;
                                        closeToMin = 0;
                                        directToMax = 0;
                                        directToMin = 0;
                                        //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                        //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                        if(x == (max_x-1))
                                        {
                                            closeToMin = 1;
                                        }
                                        else
                                        {
                                            for(int j=(x+1);j<max_x;j++)
                                            {
                                                if(map[j][i] == 0)
                                                {
                                                    directToMin = 1;
                                                }
                                                else
                                                {
                                                    directToMin = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                        {
                                            if(i<max_y)
                                            {
                                                //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                                if(i == (max_y-1))
                                                {
                                                    closeToMax = 1;
                                                }
                                                else
                                                {
                                                    for(int j=(i+1);j<max_y;j++)
                                                    {
                                                        if(map[max_x][j] == 0)
                                                        {
                                                            directToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMax = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                                {
                                                    return YES;
                                                }
                                                else
                                                {continue;}
                                            }
                                            if(i>max_y)
                                            {
                                                
                                                //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                                if(i == (max_y+1))
                                                {
                                                    closeToMax = 1;
                                                }
                                                else
                                                {
                                                    for(int j=(max_y+1);j<i;j++)
                                                    {
                                                        if(map[max_x][j] == 0)
                                                        {
                                                            directToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMax = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                                {
                                                    return YES;
                                                }
                                                else
                                                {continue;}
                                                
                                            }
                                            
                                        }
                                        else
                                        {continue;}
                                        
                                    }
                                    else  //选取的第一个点和 和最小的不直连
                                    {
                                        break;
                                    }
                                    
                                }
#pragma mark  --从上半部分--
                                for(int i=(min_x-1);i>=0;i--)//x坐标
                                {
                                    //处理特殊  i==0上半部分
                                    if(min_x == 0)
                                    {
                                        flag = 0;
                                        for(int j=0;j<max_x;j++)
                                        {
                                            if(map[j][max_y] == 0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return  YES;
                                        }
                                    }
                                    if(i==0)
                                    {
                                        if(map[i][min_y]==0)
                                        {
                                            for(int j=0;j<max_x;j++)
                                            {
                                                if(map[j][max_y]==0)
                                                {
                                                    flag = 1;
                                                }
                                                else
                                                {
                                                    flag = 0;
                                                    break;
                                                }
                                            }
                                            if(flag == 1)
                                            {
                                                return YES;
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    y = min_y;
                                    
                                    //第一个选取的点   (i,y)
                                    //判断两个水果是否 挨着
                                    if(i == (min_x -1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else//不挨着
                                    {
                                        for(int j=(min_x-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                        {
                                            if(map[j][y] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    //判断是否通过一个  拐点   找到   最大的按钮
                                    if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                                    {
                                        closeToMax = 0;
                                        closeToMin = 0;
                                        directToMax = 0;
                                        directToMin = 0;
                                        //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                        //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                                        if(y == (max_y-1))
                                        {
                                            closeToMin = 1;
                                        }
                                        else
                                        {
                                            for(int j=(y+1);j<max_y;j++)
                                            {
                                                if(map[i][j] == 0)
                                                {
                                                    directToMin = 1;
                                                }
                                                else
                                                {
                                                    directToMin = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                                        {
                                            //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                            if(i == (max_x-1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=(i+1);j<max_x;j++)
                                                {
                                                    if(map[j][max_y] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {
                                                continue;
                                                
                                            }
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                        
                                    }
                                    else  //选取的第一个点和 和最小的不直连
                                    {
                                        break;
                                        
                                        
                                    }
                                    
                                }
#pragma mark  --从下半部分--
                                for(int i=min_x+1;i<=Row;i++)
                                {
                                    
                                    //特殊处理  i==10
                                    if(max_x==Col)
                                    {
                                        flag = 0;
                                        for(int j=min_x+1;j<Row;j++)
                                        {
                                            if(map[j][min_y] == 0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                    if(i==Col)
                                    {
                                        if(map[i][min_y]==0)
                                        {
                                            for(int j=max_x+1;j<Row;j++)
                                            {
                                                if(map[j][max_y]==0)
                                                {
                                                    flag =1;
                                                }
                                                else
                                                {
                                                    flag = 0;
                                                    break;
                                                }
                                            }
                                            if(flag == 1)
                                            {
                                                return YES;
                                            }
                                        }
                                    }
                                    
                                    
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    y = min_y;
                                    //选取第一个点得坐标(i,y)
                                    if(min_x == (i-1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=min_x+1;j<i;j++)
                                        {
                                            if(map[j][y] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMin || directToMin) && map[i][y] == 0)
                                    {
                                        closeToMax = 0;
                                        closeToMin = 0;
                                        directToMax = 0;
                                        directToMin = 0;
                                        
                                        //是否和最大的有一个拐点
                                        //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                                        if(y == (max_y-1))
                                        {
                                            closeToMin = 1;
                                        }
                                        else
                                        {
                                            for(int j=y+1;j<max_y;j++)
                                            {
                                                if(map[i][j] == 0)
                                                {
                                                    directToMin = 1;
                                                }
                                                else
                                                {
                                                    directToMin = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMin || directToMin)&& map[i][max_y]==0)
                                        {
                                            if(i < max_x)
                                            {
                                                if(max_x == (i+1))
                                                {
                                                    closeToMax = 1;
                                                }
                                                else
                                                {
                                                    for(int j=i+1;j<max_x;j++)
                                                    {
                                                        if(map[j][max_y] == 0)
                                                        {
                                                            directToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMax = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMax || directToMax)&& map[i][max_y]==0)
                                                {
                                                    return YES;
                                                }
                                                else
                                                {continue;}
                                            }
                                            if(max_x < i)
                                            {
                                                if(max_x == (i-1))
                                                {
                                                    closeToMax = 1;
                                                }
                                                else
                                                {
                                                    for(int j=max_x+1;j<i;j++)
                                                    {
                                                        if(map[j][max_y] == 0)
                                                        {
                                                            directToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMax = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMax || directToMax)&& map[i][max_y]==0)
                                                {
                                                    return YES;
                                                }
                                                else
                                                {continue;}
                                            }
                                            
                                        }
                                        else
                                        {
                                            continue;
                                        }
                                        
                                        
                                    }
                                    else//第一个点不知脸
                                    {
                                        break;
                                    }
                                }
                                return NO;
                            }
                            
                        }
                    else//走不通，直接返回
                    {
#pragma mark --一个拐点没有走通  尝试下和右两拐点--
                        //最小的  下边   和  最大的   上边
#pragma mark --左半部分3333333--
                        for(int i=min_y-1;i>=0;i--)
                        {
                            if(min_y==0)
                            {
                                flag = 0;
                                for(int j=0;j<max_y;j++)
                                {
                                    if(map[max_x][j] == 0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                            //处理特殊  i==0左半部分
                            if(i==0)
                            {
                                if(map[min_x][i]==0)
                                {
                                    for(int j=0;j<max_y;j++)
                                    {
                                        if(map[max_x][j]==0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                            }
                            
                            
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            x = min_x;
                            
                            //第一个选取的点   (x,i)
                            //判断两个水果是否 挨着
                            if(i == (min_y -1))
                            {
                                closeToMin = 1;
                            }
                            else//不挨着
                            {
                                for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                {
                                    if(map[x][j] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            //判断是否通过一个  拐点   找到   最大的按钮
                            if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                            {
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                                //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                if(x == (max_x-1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=(x+1);j<max_x;j++)
                                    {
                                        if(map[j][i] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                
                                if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                {
                                    //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                    if(i == (max_y-1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int j=(i+1);j<max_y;j++)
                                        {
                                            if(map[max_x][j] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                    {
                                        return YES;
                                    }
                                    else
                                    {
                                        continue;
                                        
                                    }
                                }
                                else
                                {
                                    continue;
                                    
                                }
                                
                            }
                            else  //选取的第一个点和 和最小的不直连
                            {
                                
                                
                                break;
                                
                                
                            }
                        }
#pragma mark  --从右半部分--
                        for(int i=min_y+1;i<Col;i++)
                        {
                            //处理特殊  i==0左半部分
                            
                            if(i==9)
                            {
                                if(map[min_x][i]==0)
                                {
                                    for(int j=max_y+1;j<=9;j++)
                                    {
                                        if(map[max_x][j]==0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                            }
                            
                            
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            x = min_x;
                            
                            //第一个选取的点   (x,i)
                            //判断两个水果是否 挨着
                            if(i-1 == min_y)
                            {
                                closeToMin = 1;
                            }
                            else//不挨着
                            {
                                for(int j=(min_y+1);j<i;j++)//+1  为了从最小的下一个 进行比较
                                {
                                    if(map[x][j] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            //判断是否通过一个  拐点   找到   最大的按钮
                            if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                            {
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                if(x == (max_x-1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=(x+1);j<max_x;j++)
                                    {
                                        if(map[j][i] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                
                                if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                {
                                    if(i<max_y)
                                    {
                                        //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                        if(i == (max_y-1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=(i+1);j<max_y;j++)
                                            {
                                                if(map[max_x][j] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {continue;}
                                    }
                                    if(i>max_y)
                                    {
                                        
                                        //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                        if(i == (max_y+1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=(max_y+1);j<i;j++)
                                            {
                                                if(map[max_x][j] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {continue;}
                                        
                                    }
                                    
                                }
                                else
                                {continue;}
                                
                            }
                            else  //选取的第一个点和 和最小的不直连
                            {
                                break;
                            }
                            
                        }
#pragma mark  --从上半部分--
                        for(int i=(min_x-1);i>=0;i--)//x坐标
                        {
                            //处理特殊  i==0上半部分
                            if(min_x == 0)
                            {
                                flag = 0;
                                for(int j=0;j<max_x;j++)
                                {
                                    if(map[j][max_y] == 0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return  YES;
                                }
                            }
                            if(i==0)
                            {
                                if(map[i][min_y]==0)
                                {
                                    for(int j=0;j<max_x;j++)
                                    {
                                        if(map[j][max_y]==0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                            }
                            
                            
                            
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            y = min_y;
                            
                            //第一个选取的点   (i,y)
                            //判断两个水果是否 挨着
                            if(i == (min_x -1))
                            {
                                closeToMin = 1;
                            }
                            else//不挨着
                            {
                                for(int j=(min_x-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                {
                                    if(map[j][y] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            //判断是否通过一个  拐点   找到   最大的按钮
                            if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                            {
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                                if(y == (max_y-1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=(y+1);j<max_y;j++)
                                    {
                                        if(map[i][j] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                
                                if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                                {
                                    //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                    if(i == (max_x-1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int j=(i+1);j<max_x;j++)
                                        {
                                            if(map[j][max_y] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                    {
                                        return YES;
                                    }
                                    else
                                    {
                                        continue;
                                        
                                    }
                                }
                                else
                                {
                                    continue;
                                    
                                }
                                
                            }
                            else  //选取的第一个点和 和最小的不直连
                            {
                                break;
                                
                                
                            }
                            
                        }
#pragma mark  --从下半部分--
                        for(int i=min_x+1;i<=Row;i++)
                        {
                            
                            //特殊处理  i==10
                            if(max_x==Col)
                            {
                                flag = 0;
                                for(int j=min_x+1;j<Row;j++)
                                {
                                    if(map[j][min_y] == 0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                            if(i==Col)
                            {
                                if(map[i][min_y]==0)
                                {
                                    for(int j=max_x+1;j<Row;j++)
                                    {
                                        if(map[j][max_y]==0)
                                        {
                                            flag =1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                            }
                            
                            
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            y = min_y;
                            //选取第一个点得坐标(i,y)
                            if(min_x == (i-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=min_x+1;j<i;j++)
                                {
                                    if(map[j][y] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            if((closeToMin || directToMin) && map[i][y] == 0)
                            {
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                
                                //是否和最大的有一个拐点
                                //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                                if(y == (max_y-1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=y+1;j<max_y;j++)
                                    {
                                        if(map[i][j] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMin || directToMin)&& map[i][max_y]==0)
                                {
                                    if(i < max_x)
                                    {
                                        if(max_x == (i+1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=i+1;j<max_x;j++)
                                            {
                                                if(map[j][max_y] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax || directToMax)&& map[i][max_y]==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {continue;}
                                    }
                                    if(max_x < i)
                                    {
                                        if(max_x == (i-1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=max_x+1;j<i;j++)
                                            {
                                                if(map[j][max_y] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax || directToMax)&& map[i][max_y]==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {continue;}
                                    }
                                    
                                }
                                else
                                {
                                    continue;
                                }
                                
                                
                            }
                            else//第一个点不知脸
                            {
                                break;
                            }
                        }
                        
                        return NO;
                        
                    }
                }
            }
            else//右上方走不通    判断左下方
            {
                //****************************************************************左下方按钮是否直连
                //对左下方的   顶点进行判断
                int x = max_x;
                int y = min_y;
                
                //最小的按钮
                //判断是否挨着
                if(min_x == (x - 1))
                {
                    closeToMin = 1;
                }
                else//不挨着
                {
                    for(int i=(min_x+1);i<x;i++) //比较Y
                    {
                        if(map[i][y] == 0)//两者之间没有   任何  按钮
                        {
                            directToMin = 1;
                        }
                        else
                        {
                            directToMin = 0;
                            break;
                        }
                    }
                }
                if((closeToMin|| directToMin)&& map[x][y] == 0)
                {
                    
                        //比较最大
                        //***********************判断是否和 最大的Max直连
                        //判断两个水果是否 挨着
                        if(y == (max_y -1))
                        {
                            closeToMax = 1;
                        }
                        else//不挨着
                        {
                            for(int i=(y + 1);i<max_y;i++)//+1  为了从最小的下一个 进行比较
                            {
                                if(map[x][i] == 0)
                                {
                                    directToMax = 1;
                                }
                                else
                                {
                                    directToMax = 0;
                                    break;
                                }
                            }
                        }
                        if((closeToMax || directToMax) && map[x][y] == 0)
                        {
                            return YES;
                        }
                        else//两条横着平行的边   不通
                        {
        
#pragma mark ------------------------------正确
#pragma mark --左半部分3333333--
                            for(int i=min_y-1;i>=0;i--)
                            {
                                if(min_y==0)
                                {
                                    flag = 0;
                                    for(int j=0;j<max_y;j++)
                                    {
                                        if(map[max_x][j] == 0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                                //处理特殊  i==0左半部分
                                if(i==0)
                                {
                                    if(map[min_x][i]==0)
                                    {
                                        for(int j=0;j<max_y;j++)
                                        {
                                            if(map[max_x][j]==0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                }
                                
                                
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                x = min_x;
                                
                                //第一个选取的点   (x,i)
                                //判断两个水果是否 挨着
                                if(i == (min_y -1))
                                {
                                    closeToMin = 1;
                                }
                                else//不挨着
                                {
                                    for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                    {
                                        if(map[x][j] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                //判断是否通过一个  拐点   找到   最大的按钮
                                if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                {
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                                    //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                    if(x == (max_x-1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=(x+1);j<max_x;j++)
                                        {
                                            if(map[j][i] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    
                                    if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                    {
                                        //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                        if(i == (max_y-1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=(i+1);j<max_y;j++)
                                            {
                                                if(map[max_x][j] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                    }
                                    else
                                    {
                                        continue;
                                        
                                    }
                                    
                                }
                                else  //选取的第一个点和 和最小的不直连
                                {
                                    
                                    
                                    break;
                                    
                                    
                                }
                            }
#pragma mark  --从右半部分--
                            for(int i=min_y+1;i<Col;i++)
                            {
                                //处理特殊  i==0左半部分
                                
                                if(i==9)
                                {
                                    if(map[min_x][i]==0)
                                    {
                                        for(int j=max_y+1;j<=9;j++)
                                        {
                                            if(map[max_x][j]==0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                }
                                
                                
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                x = min_x;
                                
                                //第一个选取的点   (x,i)
                                //判断两个水果是否 挨着
                                if(i-1 == min_y)
                                {
                                    closeToMin = 1;
                                }
                                else//不挨着
                                {
                                    for(int j=(min_y+1);j<i;j++)//+1  为了从最小的下一个 进行比较
                                    {
                                        if(map[x][j] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                //判断是否通过一个  拐点   找到   最大的按钮
                                if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                {
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                    //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                    if(x == (max_x-1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=(x+1);j<max_x;j++)
                                        {
                                            if(map[j][i] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    
                                    if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                    {
                                        if(i<max_y)
                                        {
                                            //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                            if(i == (max_y-1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=(i+1);j<max_y;j++)
                                                {
                                                    if(map[max_x][j] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {continue;}
                                        }
                                        if(i>max_y)
                                        {
                                            
                                            //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                            if(i == (max_y+1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=(max_y+1);j<i;j++)
                                                {
                                                    if(map[max_x][j] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {continue;}
                                            
                                        }
                                        
                                    }
                                    else
                                    {continue;}
                                    
                                }
                                else  //选取的第一个点和 和最小的不直连
                                {
                                    break;
                                }
                                
                            }
#pragma mark  --从上半部分--
                            for(int i=(min_x-1);i>=0;i--)//x坐标
                            {
                                //处理特殊  i==0上半部分
                                if(min_x == 0)
                                {
                                    flag = 0;
                                    for(int j=0;j<max_x;j++)
                                    {
                                        if(map[j][max_y] == 0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return  YES;
                                    }
                                }
                                if(i==0)
                                {
                                    if(map[i][min_y]==0)
                                    {
                                        for(int j=0;j<max_x;j++)
                                        {
                                            if(map[j][max_y]==0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                }
                                
                                
                                
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                y = min_y;
                                
                                //第一个选取的点   (i,y)
                                //判断两个水果是否 挨着
                                if(i == (min_x -1))
                                {
                                    closeToMin = 1;
                                }
                                else//不挨着
                                {
                                    for(int j=(min_x-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                    {
                                        if(map[j][y] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                //判断是否通过一个  拐点   找到   最大的按钮
                                if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                                {
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                    //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                                    if(y == (max_y-1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=(y+1);j<max_y;j++)
                                        {
                                            if(map[i][j] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    
                                    if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                                    {
                                        //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                        if(i == (max_x-1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=(i+1);j<max_x;j++)
                                            {
                                                if(map[j][max_y] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                    }
                                    else
                                    {
                                        continue;
                                        
                                    }
                                    
                                }
                                else  //选取的第一个点和 和最小的不直连
                                {
                                    break;
                                    
                                    
                                }
                                
                            }
#pragma mark  --从下半部分--
                            for(int i=min_x+1;i<=Row;i++)
                            {
                                
                                //特殊处理  i==10
                                if(max_x==Col)
                                {
                                    flag = 0;
                                    for(int j=min_x+1;j<Row;j++)
                                    {
                                        if(map[j][min_y] == 0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                                if(i==Col)
                                {
                                    if(map[i][min_y]==0)
                                    {
                                        for(int j=max_x+1;j<Row;j++)
                                        {
                                            if(map[j][max_y]==0)
                                            {
                                                flag =1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                }
                                
                                
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                y = min_y;
                                //选取第一个点得坐标(i,y)
                                if(min_x == (i-1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=min_x+1;j<i;j++)
                                    {
                                        if(map[j][y] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMin || directToMin) && map[i][y] == 0)
                                {
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    
                                    //是否和最大的有一个拐点
                                    //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                                    if(y == (max_y-1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=y+1;j<max_y;j++)
                                        {
                                            if(map[i][j] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMin || directToMin)&& map[i][max_y]==0)
                                    {
                                        if(i < max_x)
                                        {
                                            if(max_x == (i+1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=i+1;j<max_x;j++)
                                                {
                                                    if(map[j][max_y] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax || directToMax)&& map[i][max_y]==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {continue;}
                                        }
                                        if(max_x < i)
                                        {
                                            if(max_x == (i-1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=max_x+1;j<i;j++)
                                                {
                                                    if(map[j][max_y] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax || directToMax)&& map[i][max_y]==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {continue;}
                                        }
                                        
                                    }
                                    else
                                    {
                                        continue;
                                    }
                                    
                                    
                                }
                                else//第一个点不知脸
                                {
                                    break;
                                }
                            }
                            return NO;
                        }
                    
                    }
                else//两者最小按钮      的两条边走不通
                {
#pragma mark --左半部分3333333--
                    for(int i=min_y-1;i>=0;i--)
                    {
                        
                        //处理特殊  i==0左半部分
                        if(i==0)
                        {
                            if(map[min_x][i]==0)
                            {
                                for(int j=0;j<max_y;j++)
                                {
                                    if(map[max_x][j]==0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                        }
                        
                        
                        closeToMax = 0;
                        closeToMin = 0;
                        directToMax = 0;
                        directToMin = 0;
                        x = min_x;
                        
                        //第一个选取的点   (x,i)
                        //判断两个水果是否 挨着
                        if(i == (min_y -1))
                        {
                            closeToMin = 1;
                        }
                        else//不挨着
                        {
                            for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                            {
                                if(map[x][j] == 0)
                                {
                                    directToMin = 1;
                                }
                                else
                                {
                                    directToMin = 0;
                                    break;
                                }
                            }
                        }
                        //判断是否通过一个  拐点   找到   最大的按钮
                        if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                        {
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                            //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                            if(x == (max_x-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=(x+1);j<max_x;j++)
                                {
                                    if(map[j][i] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            
                            if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                            {
                                //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                if(i == (max_y-1))
                                {
                                    closeToMax = 1;
                                }
                                else
                                {
                                    for(int j=(i+1);j<max_y;j++)
                                    {
                                        if(map[max_x][j] == 0)
                                        {
                                            directToMax = 1;
                                        }
                                        else
                                        {
                                            directToMax = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                {
                                    return YES;
                                }
                                else
                                {
                                    continue;
                                    
                                }
                            }
                            else
                            {
                                continue;
                                
                            }
                            
                        }
                        else  //选取的第一个点和 和最小的不直连
                        {
                            
                            
                            break;
                            
                            
                        }
                    }
#pragma mark  --从右半部分--
                    for(int i=min_y+1;i<Col;i++)
                    {
                        //处理特殊  i==0左半部分
                        
                        if(i==9)
                        {
                            if(map[min_x][i]==0)
                            {
                                for(int j=max_y+1;j<=9;j++)
                                {
                                    if(map[max_x][j]==0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                        }
                        
                        
                        closeToMax = 0;
                        closeToMin = 0;
                        directToMax = 0;
                        directToMin = 0;
                        x = min_x;
                        
                        //第一个选取的点   (x,i)
                        //判断两个水果是否 挨着
                        if(i-1 == min_y)
                        {
                            closeToMin = 1;
                        }
                        else//不挨着
                        {
                            for(int j=(min_y+1);j<i;j++)//+1  为了从最小的下一个 进行比较
                            {
                                if(map[x][j] == 0)
                                {
                                    directToMin = 1;
                                }
                                else
                                {
                                    directToMin = 0;
                                    break;
                                }
                            }
                        }
                        //判断是否通过一个  拐点   找到   最大的按钮
                        if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                        {
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                            //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                            if(x == (max_x-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=(x+1);j<max_x;j++)
                                {
                                    if(map[j][i] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            
                            if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                            {
                                if(i<max_y)
                                {
                                    //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                    if(i == (max_y-1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int j=(i+1);j<max_y;j++)
                                        {
                                            if(map[max_x][j] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                    {
                                        return YES;
                                    }
                                    else
                                    {continue;}
                                }
                                if(i>max_y)
                                {
                                    
                                    //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                    if(i == (max_y+1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int j=(max_y+1);j<i;j++)
                                        {
                                            if(map[max_x][j] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                    {
                                        return YES;
                                    }
                                    else
                                    {continue;}
                                    
                                }
                                
                            }
                            else
                            {continue;}
                            
                        }
                        else  //选取的第一个点和 和最小的不直连
                        {
                            break;
                        }
                        
                    }
#pragma mark  --从上半部分--
                    for(int i=(min_x-1);i>=0;i--)//x坐标
                    {
                        //处理特殊  i==0上半部分
                        
                        if(i==0)
                        {
                            if(map[i][min_y]==0)
                            {
                                for(int j=0;j<max_x;j++)
                                {
                                    if(map[j][max_y]==0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                        }
                        
                        
                        
                        closeToMax = 0;
                        closeToMin = 0;
                        directToMax = 0;
                        directToMin = 0;
                        y = min_y;
                        
                        //第一个选取的点   (i,y)
                        //判断两个水果是否 挨着
                        if(i == (min_x -1))
                        {
                            closeToMin = 1;
                        }
                        else//不挨着
                        {
                            for(int j=(min_x-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                            {
                                if(map[j][y] == 0)
                                {
                                    directToMin = 1;
                                }
                                else
                                {
                                    directToMin = 0;
                                    break;
                                }
                            }
                        }
                        //判断是否通过一个  拐点   找到   最大的按钮
                        if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                        {
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                            //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                            if(y == (max_y-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=(y+1);j<max_y;j++)
                                {
                                    if(map[i][j] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            
                            if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                            {
                                //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                if(i == (max_x-1))
                                {
                                    closeToMax = 1;
                                }
                                else
                                {
                                    for(int j=(i+1);j<max_x;j++)
                                    {
                                        if(map[j][max_y] == 0)
                                        {
                                            directToMax = 1;
                                        }
                                        else
                                        {
                                            directToMax = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                {
                                    return YES;
                                }
                                else
                                {
                                    continue;
                                    
                                }
                            }
                            else
                            {
                                continue;
                                
                            }
                            
                        }
                        else  //选取的第一个点和 和最小的不直连
                        {
                            break;
                            
                            
                        }
                        
                    }
#pragma mark  --从下半部分--
                    for(int i=min_x+1;i<=Row;i++)
                    {
                        
                        //特殊处理  i==10
                                                if(i==Col)
                        {
                            if(map[i][min_y]==0)
                            {
                                for(int j=max_x+1;j<Row;j++)
                                {
                                    if(map[j][max_y]==0)
                                    {
                                        flag =1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                        }
                        
                        
                        closeToMax = 0;
                        closeToMin = 0;
                        directToMax = 0;
                        directToMin = 0;
                        y = min_y;
                        //选取第一个点得坐标(i,y)
                        if(min_x == (i-1))
                        {
                            closeToMin = 1;
                        }
                        else
                        {
                            for(int j=min_x+1;j<i;j++)
                            {
                                if(map[j][y] == 0)
                                {
                                    directToMin = 1;
                                }
                                else
                                {
                                    directToMin = 0;
                                    break;
                                }
                            }
                        }
                        if((closeToMin || directToMin) && map[i][y] == 0)
                        {
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            
                            //是否和最大的有一个拐点
                            //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                            if(y == (max_y-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=y+1;j<max_y;j++)
                                {
                                    if(map[i][j] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            if((closeToMin || directToMin)&& map[i][max_y]==0)
                            {
                                if(i < max_x)
                                {
                                    if(max_x == (i+1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int j=i+1;j<max_x;j++)
                                        {
                                            if(map[j][max_y] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax || directToMax)&& map[i][max_y]==0)
                                    {
                                        return YES;
                                    }
                                    else
                                    {continue;}
                                }
                                if(max_x < i)
                                {
                                    if(max_x == (i-1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int j=max_x+1;j<i;j++)
                                        {
                                            if(map[j][max_y] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax || directToMax)&& map[i][max_y]==0)
                                    {
                                        return YES;
                                    }
                                    else
                                    {continue;}
                                }
                                
                            }
                            else
                            {
                                continue;
                            }
                            
                            
                        }
                        else//第一个点不知脸
                        {
                            break;
                        }
                    }

                    return NO;
                }
            }
        }
#pragma mark  ------------------------------------------------------------最小在最大 右边--
        else if(min_y > max_y)//第二种情况      最小的   在最大的   右方
        {
            
            
            //特殊处理
            
            if(max_y == 0)
            {
                flag = 0;
                for(int j=0;j<min_y;j++)
                {
                    if(map[min_x][j] == 0)
                    {
                        flag = 1;
                    }
                    else
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 1)
                {
                    return YES;
                }
            }
            
            
            
            if(min_y==9)
            {
                flag = 0;
                for(int j=max_y+1;j<Col;j++)
                {
                    if(map[max_x][j] == 0)
                    {
                        flag = 1;
                    }
                    else
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 1)
                {
                    return YES;
                }
            }
            
            
            
            if(min_x == 0)
            {
                flag = 0;
                for(int j=0;j<max_x;j++)
                {
                    if(map[j][max_y]==0)
                    {
                        flag = 1;
                    }
                    else
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 1)
                {
                    return YES;
                }
            }
            
            
            
            if(max_x == Col)
            {
                flag = 0;
                for(int j=min_x+1;j<Row;j++)
                {
                    if(map[j][min_y] == 0)
                    {
                        flag = 1;
                    }
                    else
                    {
                        flag = 0;
                        break;
                    }
                }
                if(flag == 1)
                {
                    return YES;
                }
            }
            
            
                //****************************************判断左上方按钮是否和两个按钮直连
            closeToMin = 0;
            directToMin = 0;
            closeToMax = 0;
            directToMax = 0;
                x = min_x;
                y = max_y;
            
                //和最小是否直连
                if(y == (min_y-1))
                {
                    closeToMin = 1;
                }
                else
                {
                    for(int i=(y+1);i<min_y;i++)
                    {
                        if(map[x][i] == 0)
                        {
                            directToMin = 1;
                        }
                        else
                        {
                            directToMin = 0;
                            break;
                        }
                    }
                }
            
                if((closeToMin || directToMin))//左上方和   最小的直连
                {
                    //是否和最大直连
                    if(x == max_x-1)
                    {
                        closeToMax = 1;
                    }
                    else
                    {
                        for(int i = (x+1);i<max_x;i++)
                        {
                            if(map[i][y] == 0)
                            {
                                directToMax = 1;
                            }
                            else
                            {
                                
                                directToMax = 0;
                                break;
                            }
                        }
                    }
                    if((closeToMax || directToMax) && map[x][y] == 0)//左上方满足条件
                    {
                        return YES;
                    }
                    else//左上方和   最大的不直连
                    {
                            //判断右下方是否直连
                            closeToMin = 0;
                            closeToMax = 0;
                            directToMin = 0;
                            directToMax = 0;
                            x = max_x;
                            y = min_y;
                            //判断是否 和最小的直连
                            if(min_x == (x-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int i=min_x+1;i<x;i++)
                                {
                                    if(map[i][y] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            if(closeToMin || directToMin)//满足直连
                            {
                                    //判断 是否和最大的直连
                                    if(max_y == (y-1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int i=max_y+1;i<y;i++)
                                        {
                                            if(map[x][i] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax || directToMax)&& map[x][y] == 0)//也和最大的直连
                                    {
                                        return YES;
                                    }
                                    else//和最大相连的 两条边不通
                                    {
                                        
#pragma mark ---下半部分和左半部分33333333333333333333333333333333444444444---
#pragma mark --左半部分--
                                        for(int i=min_y-1;i>=0;i--)
                                        {
                                            
                                            //处理特殊  i==0左半部分
                                            
                                            if(i==0)
                                            {
                                                
                                                if(map[min_x][i]==0)
                                                {
                                                    flag = 0;
                                                    for(int j=0;j<max_y;j++)
                                                    {
                                                        if(map[max_x][j]==0)
                                                        {
                                                            flag = 1;
                                                        }
                                                        else
                                                        {
                                                            flag = 0;
                                                            break;
                                                        }
                                                    }
                                                    if(flag == 1)
                                                    {
                                                        return YES;
                                                    }
                                                }
                                            }
                                            
                                            
                                            
                                            closeToMax = 0;
                                            closeToMin = 0;
                                            directToMax = 0;
                                            directToMin = 0;
                                            x = min_x;
                                            
                                            //第一个选取的点   (x,i)
                                            //判断两个水果是否 挨着
                                            if(i == (min_y -1))
                                            {
                                                closeToMin = 1;
                                            }
                                            else//不挨着
                                            {
                                                for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                                {
                                                    if(map[x][j] == 0)
                                                    {
                                                        directToMin = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMin = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            //判断是否通过一个  拐点   找到   最大的按钮
                                            if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                            {
                                                closeToMax = 0;
                                                closeToMin = 0;
                                                directToMax = 0;
                                                directToMin = 0;
                                                //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                                                //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                                if(x == (max_x-1))
                                                {
                                                    closeToMin = 1;
                                                }
                                                else
                                                {
                                                    for(int j=(x+1);j<max_x;j++)
                                                    {
                                                        if(map[j][i] == 0)
                                                        {
                                                            directToMin = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMin = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                
                                                if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                                {
                                                    if(i<max_y)
                                                    {
                                                        //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                                        if(i == (max_y-1))
                                                        {
                                                            closeToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            for(int j=(i+1);j<max_y;j++)
                                                            {
                                                                if(map[max_x][j] == 0)
                                                                {
                                                                    directToMax = 1;
                                                                }
                                                                else
                                                                {
                                                                    directToMax = 0;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                        if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                                        {
                                                            return YES;
                                                        }
                                                        else
                                                        {
                                                            continue;
                                                            
                                                        }
                                                    }
                                                    if(i>max_y)
                                                    {
                                                        //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                                        if(i == (max_y+1))
                                                        {
                                                            closeToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            for(int j=(max_y+1);j<i;j++)
                                                            {
                                                                if(map[max_x][j] == 0)
                                                                {
                                                                    directToMax = 1;
                                                                }
                                                                else
                                                                {
                                                                    directToMax = 0;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                        if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                                        {
                                                            return YES;
                                                        }
                                                        else
                                                        {
                                                            continue;
                                                            
                                                        }
                                                    }
                                                }
                                                else
                                                {continue;}
                                                
                                            }
                                            else  //选取的第一个点和 和最小的不直连
                                            {
                                                break;
                                                
                                                
                                            }
                                        }
#pragma mark  --从右半部分--
                                        for(int i=min_y+1;i<Col;i++)
                                        {
                                            //处理特殊  i==0左半部分
                                            
                                            if(i==9)
                                            {
                                                if(map[min_x][i]==0)
                                                {
                                                    for(int j=max_y+1;j<=9;j++)
                                                    {
                                                        if(map[max_x][j]==0)
                                                        {
                                                            flag = 1;
                                                        }
                                                        else
                                                        {
                                                            flag = 0;
                                                            break;
                                                        }
                                                    }
                                                    if(flag == 1)
                                                    {
                                                        return YES;
                                                    }
                                                }
                                            }
                                            
                                            
                                            closeToMax = 0;
                                            closeToMin = 0;
                                            directToMax = 0;
                                            directToMin = 0;
                                            x = min_x;
                                            
                                            //第一个选取的点   (x,i)
                                            //判断两个水果是否 挨着
                                            if(i-1 == min_y)
                                            {
                                                closeToMin = 1;
                                            }
                                            else//不挨着
                                            {
                                                for(int j=(min_y+1);j<i;j++)//+1  为了从最小的下一个 进行比较
                                                {
                                                    if(map[x][j] == 0)
                                                    {
                                                        directToMin = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMin = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            //判断是否通过一个  拐点   找到   最大的按钮
                                            if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                            {
                                                closeToMax = 0;
                                                closeToMin = 0;
                                                directToMax = 0;
                                                directToMin = 0;
                                                //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                                //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                                if(x == (max_x-1))
                                                {
                                                    closeToMin = 1;
                                                }
                                                else
                                                {
                                                    for(int j=(x+1);j<max_x;j++)
                                                    {
                                                        if(map[j][i] == 0)
                                                        {
                                                            directToMin = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMin = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                
                                                if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                                {
                                                    //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                                    if(i == (max_y+1))
                                                    {
                                                        closeToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        for(int j=(max_y+1);j<i;j++)
                                                        {
                                                            if(map[max_x][j] == 0)
                                                            {
                                                                directToMax = 1;
                                                            }
                                                            else
                                                            {
                                                                directToMax = 0;
                                                                break;
                                                            }
                                                        }
                                                    }
                                                    if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                                    {
                                                        return YES;
                                                    }
                                                    else
                                                    {
                                                        continue;
                                                        
                                                    }
                                                }
                                                else
                                                {
                                                    continue;
                                                    
                                                }
                                                
                                            }
                                            else  //选取的第一个点和 和最小的不直连
                                            {
                                                break;
                                                
                                                
                                            }
                                            
                                        }
#pragma mark  --从上半部分--
                                        for(int i=(min_x-1);i>=0;i--)//x坐标
                                        {
                                            //处理特殊  i==0上半部分
                                            
                                            if(i==0)
                                            {
                                                if(map[i][min_y]==0)
                                                {
                                                    for(int j=0;j<max_x;j++)
                                                    {
                                                        if(map[j][max_y]==0)
                                                        {
                                                            flag = 1;
                                                        }
                                                        else
                                                        {
                                                            flag = 0;
                                                            break;
                                                        }
                                                    }
                                                    if(flag == 1)
                                                    {
                                                        return YES;
                                                    }
                                                }
                                            }
                                            
                                            
                                            closeToMax = 0;
                                            closeToMin = 0;
                                            directToMax = 0;
                                            directToMin = 0;
                                            y = min_y;
                                            
                                            //第一个选取的点   (i,y)
                                            //判断两个水果是否 挨着
                                            if(i+1 == min_x)
                                            {
                                                closeToMin = 1;
                                            }
                                            else//不挨着
                                            {
                                                for(int j=(i+1);j<min_x;j++)//+1  为了从最小的下一个 进行比较
                                                {
                                                    if(map[j][y] == 0)
                                                    {
                                                        directToMin = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMin = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            //判断是否通过一个  拐点   找到   最大的按钮
                                            if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                                            {
                                                closeToMax = 0;
                                                closeToMin = 0;
                                                directToMax = 0;
                                                directToMin = 0;
                                                //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                                //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                                                if(y == (max_y+1))
                                                {
                                                    closeToMin = 1;
                                                }
                                                else
                                                {
                                                    for(int j=(max_y+1);j<y;j++)
                                                    {
                                                        if(map[i][j] == 0)
                                                        {
                                                            directToMin = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMin = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                
                                                if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                                                {
                                                    //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                                    if(i == (max_x-1))
                                                    {
                                                        closeToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        for(int j=(i+1);j<max_x;j++)
                                                        {
                                                            if(map[j][max_y] == 0)
                                                            {
                                                                directToMax = 1;
                                                            }
                                                            else
                                                            {
                                                                directToMax = 0;
                                                                break;
                                                            }
                                                        }
                                                    }
                                                    if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                                    {
                                                        return YES;
                                                    }
                                                    else
                                                    {
                                                        continue;
                                                        
                                                    }
                                                }
                                                else
                                                {
                                                    continue;
                                                    
                                                }
                                                
                                            }
                                            else  //选取的第一个点和 和最小的不直连
                                            {
                                                break;
                                                
                                                
                                            }
                                            
                                        }
#pragma mark  --从下半部分--
                                        for(int i=min_x+1;i<=Row;i++)
                                        {
                                            
                                            //特殊处理  i==10
                                           
                                            if(i==Col)
                                            {
                                                if(map[i][min_y]==0)
                                                {
                                                    for(int j=max_x+1;j<Row;j++)
                                                    {
                                                        if(map[j][max_y]==0)
                                                        {
                                                            flag =1;
                                                        }
                                                        else
                                                        {
                                                            flag = 0;
                                                            break;
                                                        }
                                                    }
                                                    if(flag == 1)
                                                    {
                                                        return YES;
                                                    }
                                                }
                                            }
                                            
                                            closeToMax = 0;
                                            closeToMin = 0;
                                            directToMax = 0;
                                            directToMin = 0;
                                            y = min_y;
                                            //选取第一个点得坐标(i,y)
                                            if(min_x == (i-1))
                                            {
                                                closeToMin = 1;
                                            }
                                            else
                                            {
                                                for(int j=min_x+1;j<i;j++)
                                                {
                                                    if(map[j][y] == 0)
                                                    {
                                                        directToMin = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMin = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMin || directToMin) && map[i][y] == 0)
                                            {
                                                closeToMax = 0;
                                                closeToMin = 0;
                                                directToMax = 0;
                                                directToMin = 0;
                                                
                                                //是否和最大的有一个拐点
                                                //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                                                if(y == (max_y+1))
                                                {
                                                    closeToMin = 1;
                                                }
                                                else
                                                {
                                                    for(int j=max_y+1;j<y;j++)
                                                    {
                                                        if(map[i][j] == 0)
                                                        {
                                                            directToMin = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMin = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMin || directToMin)&& map[i][max_y]==0)
                                                {
                                                    if(i<max_x)
                                                    {
                                                        if(max_x == (i+1))
                                                        {
                                                            closeToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            for(int j=i+1;j<max_x;j++)
                                                            {
                                                                if(map[j][max_y] == 0)
                                                                {
                                                                    directToMax = 1;
                                                                }
                                                                else
                                                                {
                                                                    directToMax = 0;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                        if((closeToMax || directToMax)&& map[i][max_y]==0)
                                                        {
                                                            return YES;
                                                        }
                                                        else
                                                        {continue;}
                                                    }
                                                    if(i > max_x)
                                                    {
                                                        if(max_x == (i-1))
                                                        {
                                                            closeToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            for(int j=max_x+1;j<i;j++)
                                                            {
                                                                if(map[j][max_y] == 0)
                                                                {
                                                                    directToMax = 1;
                                                                }
                                                                else
                                                                {
                                                                    directToMax = 0;
                                                                    break;
                                                                }
                                                            }
                                                        }
                                                        if((closeToMax || directToMax)&& map[i][max_y]==0)
                                                        {
                                                            return YES;
                                                        }
                                                        else
                                                        {continue;}
                                                    }
                                                }
                                                else
                                                {continue;}
                                                
                                                
                                            }
                                            else
                                            {
                                                
                                                break;
                                            }
                                        }
                                        
                                        return NO;
                                    }
                                
                            }
                            else   //竖着平行   的两条边  不通
                            {
#pragma mark ---111111---
#pragma mark --左半部分--
                                for(int i=min_y-1;i>=0;i--)
                                {
                                    
                                    //处理特殊  i==0左半部分
                                    if(max_y == 0)
                                    {
                                        flag = 0;
                                        for(int j=0;j<min_y;j++)
                                        {
                                            if(map[min_x][j] == 0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                    if(i==0)
                                    {
                                        
                                        if(map[min_x][i]==0)
                                        {
                                            flag = 0;
                                            for(int j=0;j<max_y;j++)
                                            {
                                                if(map[max_x][j]==0)
                                                {
                                                    flag = 1;
                                                }
                                                else
                                                {
                                                    flag = 0;
                                                    break;
                                                }
                                            }
                                            if(flag == 1)
                                            {
                                                return YES;
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    x = min_x;
                                    
                                    //第一个选取的点   (x,i)
                                    //判断两个水果是否 挨着
                                    if(i == (min_y -1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else//不挨着
                                    {
                                        for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                        {
                                            if(map[x][j] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    //判断是否通过一个  拐点   找到   最大的按钮
                                    if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                    {
                                        closeToMax = 0;
                                        closeToMin = 0;
                                        directToMax = 0;
                                        directToMin = 0;
                                        //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                                        //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                        if(x == (max_x-1))
                                        {
                                            closeToMin = 1;
                                        }
                                        else
                                        {
                                            for(int j=(x+1);j<max_x;j++)
                                            {
                                                if(map[j][i] == 0)
                                                {
                                                    directToMin = 1;
                                                }
                                                else
                                                {
                                                    directToMin = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                        {
                                            if(i<max_y)
                                            {
                                                //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                                if(i == (max_y-1))
                                                {
                                                    closeToMax = 1;
                                                }
                                                else
                                                {
                                                    for(int j=(i+1);j<max_y;j++)
                                                    {
                                                        if(map[max_x][j] == 0)
                                                        {
                                                            directToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMax = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                                {
                                                    return YES;
                                                }
                                                else
                                                {
                                                    continue;
                                                    
                                                }
                                            }
                                            if(i>max_y)
                                            {
                                                //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                                if(i == (max_y+1))
                                                {
                                                    closeToMax = 1;
                                                }
                                                else
                                                {
                                                    for(int j=(max_y+1);j<i;j++)
                                                    {
                                                        if(map[max_x][j] == 0)
                                                        {
                                                            directToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMax = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                                {
                                                    return YES;
                                                }
                                                else
                                                {
                                                    continue;
                                                    
                                                }
                                            }
                                        }
                                        else
                                        {continue;}
                                        
                                    }
                                    else  //选取的第一个点和 和最小的不直连
                                    {
                                        break;
                                        
                                        
                                    }
                                }
#pragma mark  --从右半部分--
                                for(int i=min_y+1;i<Col;i++)
                                {
                                    //处理特殊  i==0左半部分
                                    if(min_y==9)
                                    {
                                        flag = 0;
                                        for(int j=max_y+1;j<Col;j++)
                                        {
                                            if(map[max_x][j] == 0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                    if(i==9)
                                    {
                                        if(map[min_x][i]==0)
                                        {
                                            for(int j=max_y+1;j<=9;j++)
                                            {
                                                if(map[max_x][j]==0)
                                                {
                                                    flag = 1;
                                                }
                                                else
                                                {
                                                    flag = 0;
                                                    break;
                                                }
                                            }
                                            if(flag == 1)
                                            {
                                                return YES;
                                            }
                                        }
                                    }
                                    
                                    
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    x = min_x;
                                    
                                    //第一个选取的点   (x,i)
                                    //判断两个水果是否 挨着
                                    if(i-1 == min_y)
                                    {
                                        closeToMin = 1;
                                    }
                                    else//不挨着
                                    {
                                        for(int j=(min_y+1);j<i;j++)//+1  为了从最小的下一个 进行比较
                                        {
                                            if(map[x][j] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    //判断是否通过一个  拐点   找到   最大的按钮
                                    if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                    {
                                        closeToMax = 0;
                                        closeToMin = 0;
                                        directToMax = 0;
                                        directToMin = 0;
                                        //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                        //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                        if(x == (max_x-1))
                                        {
                                            closeToMin = 1;
                                        }
                                        else
                                        {
                                            for(int j=(x+1);j<max_x;j++)
                                            {
                                                if(map[j][i] == 0)
                                                {
                                                    directToMin = 1;
                                                }
                                                else
                                                {
                                                    directToMin = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                        {
                                            //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                            if(i == (max_y+1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=(max_y+1);j<i;j++)
                                                {
                                                    if(map[max_x][j] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {
                                                continue;
                                                
                                            }
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                        
                                    }
                                    else  //选取的第一个点和 和最小的不直连
                                    {
                                        break;
                                        
                                        
                                    }
                                    
                                }
#pragma mark  --从上半部分--
                                for(int i=(min_x-1);i>=0;i--)//x坐标
                                {
                                    //处理特殊  i==0上半部分
                                    if(min_x == 0)
                                    {
                                        flag = 0;
                                        for(int j=0;j<max_x;j++)
                                        {
                                            if(map[j][max_y]==0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                    if(i==0)
                                    {
                                        if(map[i][min_y]==0)
                                        {
                                            for(int j=0;j<max_x;j++)
                                            {
                                                if(map[j][max_y]==0)
                                                {
                                                    flag = 1;
                                                }
                                                else
                                                {
                                                    flag = 0;
                                                    break;
                                                }
                                            }
                                            if(flag == 1)
                                            {
                                                return YES;
                                            }
                                        }
                                    }
                                    
                                    
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    y = min_y;
                                    
                                    //第一个选取的点   (i,y)
                                    //判断两个水果是否 挨着
                                    if(i+1 == min_x)
                                    {
                                        closeToMin = 1;
                                    }
                                    else//不挨着
                                    {
                                        for(int j=(i+1);j<min_x;j++)//+1  为了从最小的下一个 进行比较
                                        {
                                            if(map[j][y] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    //判断是否通过一个  拐点   找到   最大的按钮
                                    if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                                    {
                                        closeToMax = 0;
                                        closeToMin = 0;
                                        directToMax = 0;
                                        directToMin = 0;
                                        //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                        //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                                        if(y == (max_y+1))
                                        {
                                            closeToMin = 1;
                                        }
                                        else
                                        {
                                            for(int j=(max_y+1);j<y;j++)
                                            {
                                                if(map[i][j] == 0)
                                                {
                                                    directToMin = 1;
                                                }
                                                else
                                                {
                                                    directToMin = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                                        {
                                            //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                            if(i == (max_x-1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=(i+1);j<max_x;j++)
                                                {
                                                    if(map[j][max_y] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {
                                                continue;
                                                
                                            }
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                        
                                    }
                                    else  //选取的第一个点和 和最小的不直连
                                    {
                                        break;
                                        
                                        
                                    }
                                    
                                }
#pragma mark  --从下半部分--
                                for(int i=min_x+1;i<=Row;i++)
                                {
                                    
                                    //特殊处理  i==10
                                    if(max_x == Col)
                                    {
                                        flag = 0;
                                        for(int j=min_x+1;j<Row;j++)
                                        {
                                            if(map[j][min_y] == 0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                    if(i==Col)
                                    {
                                        if(map[i][min_y]==0)
                                        {
                                            for(int j=max_x+1;j<Row;j++)
                                            {
                                                if(map[j][max_y]==0)
                                                {
                                                    flag =1;
                                                }
                                                else
                                                {
                                                    flag = 0;
                                                    break;
                                                }
                                            }
                                            if(flag == 1)
                                            {
                                                return YES;
                                            }
                                        }
                                    }
                                    
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    y = min_y;
                                    //选取第一个点得坐标(i,y)
                                    if(min_x == (i-1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=min_x+1;j<i;j++)
                                        {
                                            if(map[j][y] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMin || directToMin) && map[i][y] == 0)
                                    {
                                        closeToMax = 0;
                                        closeToMin = 0;
                                        directToMax = 0;
                                        directToMin = 0;
                                        
                                        //是否和最大的有一个拐点
                                        //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                                        if(y == (max_y+1))
                                        {
                                            closeToMin = 1;
                                        }
                                        else
                                        {
                                            for(int j=max_y+1;j<y;j++)
                                            {
                                                if(map[i][j] == 0)
                                                {
                                                    directToMin = 1;
                                                }
                                                else
                                                {
                                                    directToMin = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMin || directToMin)&& map[i][max_y]==0)
                                        {
                                            if(i<max_x)
                                            {
                                                if(max_x == (i+1))
                                                {
                                                    closeToMax = 1;
                                                }
                                                else
                                                {
                                                    for(int j=i+1;j<max_x;j++)
                                                    {
                                                        if(map[j][max_y] == 0)
                                                        {
                                                            directToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMax = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMax || directToMax)&& map[i][max_y]==0)
                                                {
                                                    return YES;
                                                }
                                                else
                                                {continue;}
                                            }
                                            if(i > max_x)
                                            {
                                                if(max_x == (i-1))
                                                {
                                                    closeToMax = 1;
                                                }
                                                else
                                                {
                                                    for(int j=max_x+1;j<i;j++)
                                                    {
                                                        if(map[j][max_y] == 0)
                                                        {
                                                            directToMax = 1;
                                                        }
                                                        else
                                                        {
                                                            directToMax = 0;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if((closeToMax || directToMax)&& map[i][max_y]==0)
                                                {
                                                    return YES;
                                                }
                                                else
                                                {continue;}
                                            }
                                        }
                                        else
                                        {continue;}
                                        
                                        
                                    }
                                    else
                                    {
                                        
                                        break;
                                    }
                                }
                            }
                    }
                    
                }
                else//左上方和最小的不直连       判断右下方是否直连
                {
                    closeToMin = 0;
                    closeToMax = 0;
                    directToMin = 0;
                    directToMax = 0;
                    x = max_x;
                    y = min_y;
                    //判断是否 和最小的直连
                    if(min_x == (x-1))
                    {
                        closeToMin = 1;
                    }
                    else
                    {
                        for(int i=min_x+1;i<x;i++)
                        {
                            if(map[i][y] == 0)
                            {
                                directToMin = 1;
                            }
                            else
                            {
                                directToMin = 0;
                                break;
                            }
                        }
                    }
                    if(closeToMin || directToMin)//满足直连
                    {
                        //判断 是否和最大的直连
                        if(max_y == (y-1))
                        {
                            closeToMax = 1;
                        }
                        else
                        {
                            for(int i=max_y+1;i<y;i++)
                            {
                                if(map[x][i] == 0)
                                {
                                    directToMax = 1;
                                }
                                else
                                {
                                    directToMax = 0;
                                    break;
                                }
                            }
                        }
                        if((closeToMax || directToMax)&& map[x][y] == 0)//也和最大的直连
                        {
                            return YES;
                        }
                        else//横着平行的两条边  不通
                        {
#pragma mark --333--
#pragma mark --左半部分--
                            for(int i=min_y-1;i>=0;i--)
                            {
                                
                                //处理特殊  i==0左半部分
                                if(max_y == 0)
                                {
                                    flag = 0;
                                    for(int j=0;j<min_y;j++)
                                    {
                                        if(map[min_x][j] == 0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                                if(i==0)
                                {
                                    
                                    if(map[min_x][i]==0)
                                    {
                                        flag = 0;
                                        for(int j=0;j<max_y;j++)
                                        {
                                            if(map[max_x][j]==0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                }
                                
                                
                                
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                x = min_x;
                                
                                //第一个选取的点   (x,i)
                                //判断两个水果是否 挨着
                                if(i == (min_y -1))
                                {
                                    closeToMin = 1;
                                }
                                else//不挨着
                                {
                                    for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                    {
                                        if(map[x][j] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                //判断是否通过一个  拐点   找到   最大的按钮
                                if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                {
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                                    //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                    if(x == (max_x-1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=(x+1);j<max_x;j++)
                                        {
                                            if(map[j][i] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    
                                    if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                    {
                                        if(i<max_y)
                                        {
                                            //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                            if(i == (max_y-1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=(i+1);j<max_y;j++)
                                                {
                                                    if(map[max_x][j] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {
                                                continue;
                                                
                                            }
                                        }
                                        if(i>max_y)
                                        {
                                            //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                            if(i == (max_y+1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=(max_y+1);j<i;j++)
                                                {
                                                    if(map[max_x][j] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {
                                                continue;
                                                
                                            }
                                        }
                                    }
                                    else
                                    {continue;}
                                    
                                }
                                else  //选取的第一个点和 和最小的不直连
                                {
                                    break;
                                    
                                    
                                }
                            }
#pragma mark  --从右半部分--
                            for(int i=min_y+1;i<Col;i++)
                            {
                                //处理特殊  i==0左半部分
                                if(min_y==9)
                                {
                                    flag = 0;
                                    for(int j=max_y+1;j<Col;j++)
                                    {
                                        if(map[max_x][j] == 0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                                if(i==9)
                                {
                                    if(map[min_x][i]==0)
                                    {
                                        for(int j=max_y+1;j<=9;j++)
                                        {
                                            if(map[max_x][j]==0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                }
                                
                                
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                x = min_x;
                                
                                //第一个选取的点   (x,i)
                                //判断两个水果是否 挨着
                                if(i-1 == min_y)
                                {
                                    closeToMin = 1;
                                }
                                else//不挨着
                                {
                                    for(int j=(min_y+1);j<i;j++)//+1  为了从最小的下一个 进行比较
                                    {
                                        if(map[x][j] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                //判断是否通过一个  拐点   找到   最大的按钮
                                if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                                {
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                    //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                    if(x == (max_x-1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=(x+1);j<max_x;j++)
                                        {
                                            if(map[j][i] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    
                                    if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                    {
                                        //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                        if(i == (max_y+1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=(max_y+1);j<i;j++)
                                            {
                                                if(map[max_x][j] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                    }
                                    else
                                    {
                                        continue;
                                        
                                    }
                                    
                                }
                                else  //选取的第一个点和 和最小的不直连
                                {
                                    break;
                                    
                                    
                                }
                                
                            }
#pragma mark  --从上半部分--
                            for(int i=(min_x-1);i>=0;i--)//x坐标
                            {
                                //处理特殊  i==0上半部分
                                if(min_x == 0)
                                {
                                    flag = 0;
                                    for(int j=0;j<max_x;j++)
                                    {
                                        if(map[j][max_y]==0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                                if(i==0)
                                {
                                    if(map[i][min_y]==0)
                                    {
                                        for(int j=0;j<max_x;j++)
                                        {
                                            if(map[j][max_y]==0)
                                            {
                                                flag = 1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                }
                                
                                
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                y = min_y;
                                
                                //第一个选取的点   (i,y)
                                //判断两个水果是否 挨着
                                if(i+1 == min_x)
                                {
                                    closeToMin = 1;
                                }
                                else//不挨着
                                {
                                    for(int j=(i+1);j<min_x;j++)//+1  为了从最小的下一个 进行比较
                                    {
                                        if(map[j][y] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                //判断是否通过一个  拐点   找到   最大的按钮
                                if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                                {
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                    //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                                    if(y == (max_y+1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=(max_y+1);j<y;j++)
                                        {
                                            if(map[i][j] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    
                                    if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                                    {
                                        //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                        if(i == (max_x-1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=(i+1);j<max_x;j++)
                                            {
                                                if(map[j][max_y] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                    }
                                    else
                                    {
                                        continue;
                                        
                                    }
                                    
                                }
                                else  //选取的第一个点和 和最小的不直连
                                {
                                    break;
                                    
                                    
                                }
                                
                            }
#pragma mark  --从下半部分--
                            for(int i=min_x+1;i<=Row;i++)
                            {
                                
                                //特殊处理  i==10
                                if(max_x == Col)
                                {
                                    flag = 0;
                                    for(int j=min_x+1;j<Row;j++)
                                    {
                                        if(map[j][min_y] == 0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                                if(i==Col)
                                {
                                    if(map[i][min_y]==0)
                                    {
                                        for(int j=max_x+1;j<Row;j++)
                                        {
                                            if(map[j][max_y]==0)
                                            {
                                                flag =1;
                                            }
                                            else
                                            {
                                                flag = 0;
                                                break;
                                            }
                                        }
                                        if(flag == 1)
                                        {
                                            return YES;
                                        }
                                    }
                                }
                                
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                y = min_y;
                                //选取第一个点得坐标(i,y)
                                if(min_x == (i-1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=min_x+1;j<i;j++)
                                    {
                                        if(map[j][y] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMin || directToMin) && map[i][y] == 0)
                                {
                                    closeToMax = 0;
                                    closeToMin = 0;
                                    directToMax = 0;
                                    directToMin = 0;
                                    
                                    //是否和最大的有一个拐点
                                    //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                                    if(y == (max_y+1))
                                    {
                                        closeToMin = 1;
                                    }
                                    else
                                    {
                                        for(int j=max_y+1;j<y;j++)
                                        {
                                            if(map[i][j] == 0)
                                            {
                                                directToMin = 1;
                                            }
                                            else
                                            {
                                                directToMin = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMin || directToMin)&& map[i][max_y]==0)
                                    {
                                        if(i<max_x)
                                        {
                                            if(max_x == (i+1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=i+1;j<max_x;j++)
                                                {
                                                    if(map[j][max_y] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax || directToMax)&& map[i][max_y]==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {continue;}
                                        }
                                        if(i > max_x)
                                        {
                                            if(max_x == (i-1))
                                            {
                                                closeToMax = 1;
                                            }
                                            else
                                            {
                                                for(int j=max_x+1;j<i;j++)
                                                {
                                                    if(map[j][max_y] == 0)
                                                    {
                                                        directToMax = 1;
                                                    }
                                                    else
                                                    {
                                                        directToMax = 0;
                                                        break;
                                                    }
                                                }
                                            }
                                            if((closeToMax || directToMax)&& map[i][max_y]==0)
                                            {
                                                return YES;
                                            }
                                            else
                                            {continue;}
                                        }
                                    }
                                    else
                                    {continue;}
                                    
                                    
                                }
                                else
                                {
                                    
                                    break;
                                }
                            }
                            return NO;
                        }
                    }
                    else//和最小的 相连 的  两条边不通
                    {
#pragma mark --上半部分和右半部分没有问题hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh--
#pragma mark --左半部分--
                        for(int i=min_y-1;i>=0;i--)
                        {
                            
                            //处理特殊  i==0左半部分
                            if(max_y == 0)
                            {
                                flag = 0;
                                for(int j=0;j<min_y;j++)
                                {
                                    if(map[min_x][j] == 0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                            if(i==0)
                            {
                                
                                if(map[min_x][i]==0)
                                {
                                    flag = 0;
                                    for(int j=0;j<max_y;j++)
                                    {
                                        if(map[max_x][j]==0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                            }
                            
                            
                            
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            x = min_x;
                            
                            //第一个选取的点   (x,i)
                            //判断两个水果是否 挨着
                            if(i == (min_y -1))
                            {
                                closeToMin = 1;
                            }
                            else//不挨着
                            {
                                for(int j=(min_y-1);j>i;j--)//+1  为了从最小的下一个 进行比较
                                {
                                    if(map[x][j] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            //判断是否通过一个  拐点   找到   最大的按钮
                            if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                            {
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                //和                最大的   之间有一个拐点（（（（（（（（左下方）））））
                                //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                if(x == (max_x-1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=(x+1);j<max_x;j++)
                                    {
                                        if(map[j][i] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                
                                if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                {
                                    if(i<max_y)
                                    {
                                        //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                        if(i == (max_y-1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=(i+1);j<max_y;j++)
                                            {
                                                if(map[max_x][j] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                    }
                                    if(i>max_y)
                                    {
                                        //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                        if(i == (max_y+1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=(max_y+1);j<i;j++)
                                            {
                                                if(map[max_x][j] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {
                                            continue;
                                            
                                        }
                                    }
                                }
                                else
                                {continue;}
                                
                            }
                            else  //选取的第一个点和 和最小的不直连
                            {
                                break;
                                
                                
                            }
                        }
#pragma mark  --从右半部分--
                        for(int i=min_y+1;i<Col;i++)
                        {
                            //处理特殊  i==0左半部分
                            if(min_y==9)
                            {
                                flag = 0;
                                for(int j=max_y+1;j<Col;j++)
                                {
                                    if(map[max_x][j] == 0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                            if(i==9)
                            {
                                if(map[min_x][i]==0)
                                {
                                    for(int j=max_y+1;j<=9;j++)
                                    {
                                        if(map[max_x][j]==0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                            }
                            
                            
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            x = min_x;
                            
                            //第一个选取的点   (x,i)
                            //判断两个水果是否 挨着
                            if(i-1 == min_y)
                            {
                                closeToMin = 1;
                            }
                            else//不挨着
                            {
                                for(int j=(min_y+1);j<i;j++)//+1  为了从最小的下一个 进行比较
                                {
                                    if(map[x][j] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            //判断是否通过一个  拐点   找到   最大的按钮
                            if((closeToMin  || directToMin) && map[x][i] == 0)//和最小的直连
                            {
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                //选取新的点得坐标    (max_x,i)  判断是否和两个点(x,i)   (max_x,max_y)直连
                                if(x == (max_x-1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=(x+1);j<max_x;j++)
                                    {
                                        if(map[j][i] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                
                                if((closeToMin || directToMin)&& map[max_x][i]==0)//和最小的直连
                                {
                                    //判断是否和最大的直连(max_x,i)   (max_x,max_y)
                                    if(i == (max_y+1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int j=(max_y+1);j<i;j++)
                                        {
                                            if(map[max_x][j] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax ||directToMax)&& map[max_x][i] ==0)
                                    {
                                        return YES;
                                    }
                                    else
                                    {
                                        continue;
                                        
                                    }
                                }
                                else
                                {
                                    continue;
                                    
                                }
                                
                            }
                            else  //选取的第一个点和 和最小的不直连
                            {
                                break;
                                
                                
                            }
                            
                        }
#pragma mark  --从上半部分--
                        for(int i=(min_x-1);i>=0;i--)//x坐标
                        {
                            //处理特殊  i==0上半部分
                            if(min_x == 0)
                            {
                                flag = 0;
                                for(int j=0;j<max_x;j++)
                                {
                                    if(map[j][max_y]==0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                            if(i==0)
                            {
                                if(map[i][min_y]==0)
                                {
                                    for(int j=0;j<max_x;j++)
                                    {
                                        if(map[j][max_y]==0)
                                        {
                                            flag = 1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                            }
                            
                            
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            y = min_y;
                            
                            //第一个选取的点   (i,y)
                            //判断两个水果是否 挨着
                            if(i+1 == min_x)
                            {
                                closeToMin = 1;
                            }
                            else//不挨着
                            {
                                for(int j=(i+1);j<min_x;j++)//+1  为了从最小的下一个 进行比较
                                {
                                    if(map[j][y] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            //判断是否通过一个  拐点   找到   最大的按钮
                            if((closeToMin  || directToMin) && map[i][y] == 0)//和最小的直连
                            {
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                //和                最大的   之间有一个拐点（（（（（（（（右上方）））））
                                //选取新的点得坐标    (i,max_y)  判断是否和两个点(i,y)   (max_x,max_y)直连
                                if(y == (max_y+1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=(max_y+1);j<y;j++)
                                    {
                                        if(map[i][j] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                
                                if((closeToMin || directToMin)&& map[i][max_y]==0)//和最小的直连
                                {
                                    //判断是否和最大的直连(i,max_y)   (max_x,max_y)
                                    if(i == (max_x-1))
                                    {
                                        closeToMax = 1;
                                    }
                                    else
                                    {
                                        for(int j=(i+1);j<max_x;j++)
                                        {
                                            if(map[j][max_y] == 0)
                                            {
                                                directToMax = 1;
                                            }
                                            else
                                            {
                                                directToMax = 0;
                                                break;
                                            }
                                        }
                                    }
                                    if((closeToMax ||directToMax)&& map[i][max_y] ==0)
                                    {
                                        return YES;
                                    }
                                    else
                                    {
                                        continue;
                                        
                                    }
                                }
                                else
                                {
                                    continue;
                                    
                                }
                                
                            }
                            else  //选取的第一个点和 和最小的不直连
                            {
                                break;
                                
                                
                            }
                            
                        }
#pragma mark  --从下半部分--
                        for(int i=min_x+1;i<=Row;i++)
                        {
                            
                            //特殊处理  i==10
                            if(max_x == Col)
                            {
                                flag = 0;
                                for(int j=min_x+1;j<Row;j++)
                                {
                                    if(map[j][min_y] == 0)
                                    {
                                        flag = 1;
                                    }
                                    else
                                    {
                                        flag = 0;
                                        break;
                                    }
                                }
                                if(flag == 1)
                                {
                                    return YES;
                                }
                            }
                            if(i==Col)
                            {
                                if(map[i][min_y]==0)
                                {
                                    for(int j=max_x+1;j<Row;j++)
                                    {
                                        if(map[j][max_y]==0)
                                        {
                                            flag =1;
                                        }
                                        else
                                        {
                                            flag = 0;
                                            break;
                                        }
                                    }
                                    if(flag == 1)
                                    {
                                        return YES;
                                    }
                                }
                            }
                            
                            closeToMax = 0;
                            closeToMin = 0;
                            directToMax = 0;
                            directToMin = 0;
                            y = min_y;
                            //选取第一个点得坐标(i,y)
                            if(min_x == (i-1))
                            {
                                closeToMin = 1;
                            }
                            else
                            {
                                for(int j=min_x+1;j<i;j++)
                                {
                                    if(map[j][y] == 0)
                                    {
                                        directToMin = 1;
                                    }
                                    else
                                    {
                                        directToMin = 0;
                                        break;
                                    }
                                }
                            }
                            if((closeToMin || directToMin) && map[i][y] == 0)
                            {
                                closeToMax = 0;
                                closeToMin = 0;
                                directToMax = 0;
                                directToMin = 0;
                                
                                //是否和最大的有一个拐点
                                //(i,max_y)   和  （i,y)   /  (max_x,max_y)
                                if(y == (max_y+1))
                                {
                                    closeToMin = 1;
                                }
                                else
                                {
                                    for(int j=max_y+1;j<y;j++)
                                    {
                                        if(map[i][j] == 0)
                                        {
                                            directToMin = 1;
                                        }
                                        else
                                        {
                                            directToMin = 0;
                                            break;
                                        }
                                    }
                                }
                                if((closeToMin || directToMin)&& map[i][max_y]==0)
                                {
                                    if(i<max_x)
                                    {
                                        if(max_x == (i+1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=i+1;j<max_x;j++)
                                            {
                                                if(map[j][max_y] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax || directToMax)&& map[i][max_y]==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {continue;}
                                    }
                                    if(i > max_x)
                                    {
                                        if(max_x == (i-1))
                                        {
                                            closeToMax = 1;
                                        }
                                        else
                                        {
                                            for(int j=max_x+1;j<i;j++)
                                            {
                                                if(map[j][max_y] == 0)
                                                {
                                                    directToMax = 1;
                                                }
                                                else
                                                {
                                                    directToMax = 0;
                                                    break;
                                                }
                                            }
                                        }
                                        if((closeToMax || directToMax)&& map[i][max_y]==0)
                                        {
                                            return YES;
                                        }
                                        else
                                        {continue;}
                                    }
                                }
                                else
                                {continue;}
                                
                                
                            }
                            else
                            {
                                
                                break;
                            }
                        }

                        return NO;//跳出
                    }
                }
            
        }
    }
    return NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
