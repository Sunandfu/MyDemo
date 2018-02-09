#import "ReadXML.h"
#include <stdio.h>
#include <stdlib.h>

void Pre_display(TreeNode *T);

/**
 函数功能描述:为一个树节点赋值
 */
TreeNode * setTree(TreeNode *T,NSString *value,NSString *name,TreeNode *child,TreeNode *brother,propertyNode *propertys){
    T.brother=brother;
    T.child=child;
    T.propertys=propertys;
    T.value=value;
    T.name=name;
    return T;
}
/**
 函数功能描述:为一个属性赋值
 */
propertyNode * setProperty(propertyNode *P,NSString *key,NSString *value,propertyNode * next){
    P.key=key;
    P.next=next;
    P.value=value;
    return P;
}
/**
 函数功能描述:获取name值
 */
void _name(NSString *n){
    if(n!=nil)printf("name:%s ",[n UTF8String]);
}
/**
 函数功能描述:获取Value值
 */
void _value(NSString *v){
    if(v!=nil)printf("value:%s ",[v UTF8String]);
}
/**
 函数功能描述:获取Key值
 */
void _key(NSString *k){
    if(k!=nil)printf("Key.%s : ",[k UTF8String]);
}
/**
 函数功能描述:获取属性里面的Value值
 */
void _p_value(NSString *p_v){
    if(p_v!=nil)printf("value.%s ",[p_v UTF8String]);
}
/**
 函数功能描述:打印属性值
 */
void display_propertys(propertyNode *P){
    if(P!=nil){
        _key(P.key);
        _p_value(P.value);//依次打印属性的key值和value值
        if(P.next!=nil){
            printf("    兄弟属性: ");
            display_propertys(P.next);
        }
    }
}
/**
 函数功能描述:前序遍历
 */
void Pre_display(TreeNode *T){
    //依次从根节点遍历(先序遍历)
    if (T!=nil)
    {
        _name(T.name);     //打印名字
        _value(T.value);	//打印属性
        display_propertys(T.propertys);//依次打印属性的key值和value值
        if(T.child!=nil){
            printf("\n打印子节点\n");
            Pre_display(T.child);      //优先打印子节点
        }
        if(T.brother!=nil){
            printf("\n打印兄弟节点\n");
            Pre_display(T.brother);    //打印兄弟节点
        }
    }
}
/**
 函数功能描述:后序遍历
 */
void Post_display(TreeNode *T){
    //依次从根节点遍历(后序遍历)
    if (T!=nil)
    {
        if(T.child!=nil)
            Post_display(T.child);      //优先打印子节点
        _value(T.value);	            //打印属性
        _name(T.name);                 //打印名字
        display_propertys(T.propertys);//依次打印属性的key值和value值
        if(T.brother!=nil)
            Post_display(T.brother);    //打印兄弟节点
    }
}
/**
 函数功能描述:层次遍历
 */
void TravLevel_display(TreeNode *T){
    //依次从根节点遍历(层次遍历)
    if (T!=nil)
    {
        _value(T.value);           	//打印属性
        _name(T.name);                 //打印名字
        display_propertys(T.propertys);//依次打印属性的key值和value值
        if(T.brother!=nil)
            TravLevel_display(T.brother);    //优先打印兄弟节点
        if(T.child!=nil)
            TravLevel_display(T.child);      //打印子节点
    }
}

/**
 函数功能描述:打印兄弟节点
 */
void disPlay_TreeNodes(TreeNode *T){//打印里面的兄弟节点
    if (T!=nil)
    {
        if(T.child!=nil)
            T=T.child;
        _name(T.name);     //打印名字
        _value(T.value);	//打印属性
        display_propertys(T.propertys);//依次打印属性的key值和value值
        if(T.brother!=nil){
            printf("\n打印兄弟节点\n");
            Pre_display(T.brother);    //打印兄弟节点
        }
    }
}


@implementation ReadXML



#pragma mark---------辅助函数
- (void)displayMyInfo:(NSArray *)arr{
    int i=0;
    for (NSString *str in arr) {
        printf("%d  %s\n",++i,[str UTF8String]);
    }
}

- (NSString *)removeSpace:(NSString *)text{
    BOOL change=NO;
    if([text hasPrefix:@" "]){change=YES;text=[text substringFromIndex:1];}
    if([text hasSuffix:@" "]){change=YES;text=[text substringToIndex:text.length-1];}
    if(change==YES)text=[self removeSpace:text];
        return text;
}
/**
 函数功能描述:这个函数是用来将不是XML中的属性信息都删除,删除特殊信息
 */
- (NSMutableIndexSet *)pass_NoHasFuhao:(NSMutableArray *)ArrM{
    NSMutableArray *temp_ArrM=[[NSMutableArray alloc]initWithArray:ArrM copyItems:YES];
    NSMutableIndexSet *index=[[NSMutableIndexSet alloc]init];
    NSArray *temp_a;
    NSString *temp_s;
    int j,count=(int)[temp_ArrM count];
    for(int i=0;i<count-1;i++){
        temp_s=temp_ArrM[i];
        temp_a=[temp_s componentsSeparatedByString:@" "];
        if([temp_a count]==0)return nil;
        if([temp_s hasPrefix:@"/"]==NO&&[temp_s hasSuffix:@"/"]==NO){
            temp_s=[@"/" stringByAppendingString:temp_a[0]];
            for (j=i+1; j<count; j++){
                if([temp_ArrM[j] hasPrefix:@"/"]&&[temp_ArrM[j]isEqualToString: temp_s])
                {temp_ArrM[j]=@"/"; break;}
            }
            if(j==count)[index addIndex:i];
        }
    }
    return index;
}
- (NSString *)remove_space:(NSString *)str{
    NSMutableString *temp=[NSMutableString stringWithString:str];
    unichar ch;
    for (long i=0;i<temp.length; i++) {
        ch=[temp characterAtIndex:i];
        if(ch==' ')
        {[temp deleteCharactersInRange:NSMakeRange(i, 1)];i=-1;}
        else break;
    }
    for (long i=temp.length-1;i>=0; i--) {
        ch=[temp characterAtIndex:i];
        if(ch==' ')
            [temp deleteCharactersInRange:NSMakeRange(i, 1)];
        else break;
    }
    return temp;
}
- (NSString *)sub_info:(NSUInteger)i{
    NSMutableString *temp_strM=[[NSMutableString alloc]init];
    unichar ch;
    for(;i<self.text.length;i++){
        ch=[self.text characterAtIndex:i];
        if(ch=='<')break;
        else [temp_strM appendFormat:@"%C",ch];
    }
    return [self remove_space:temp_strM];//去除首尾空格
}

#pragma mark-----------解析XML到树形结构的相关的函数
- (NSString *)kuohao_NoHasFuhao{
    unichar ch;
    NSMutableString *strM=[[NSMutableString alloc]init];
    for(int i=self.cur+1; i<self.text.length; i++){
        ch=[self.text characterAtIndex:i];
        if(ch=='>')break;
        else [strM appendFormat:@"%C",ch];
    }
    return (NSString *)strM;
}
- (NSMutableArray *)split_NoHasFuhao{
    NSMutableArray *arrM=[[NSMutableArray alloc]init];
    unichar ch;
    for (self.cur=0; self.cur<self.text.length; self.cur++) {
        ch=[self.text characterAtIndex:self.cur];
        if(ch=='<'){
            [arrM addObject:[self kuohao_NoHasFuhao]];
        }
    }
    return arrM;
}
- (NSString *)kuohao_HasFuhao{
    unichar ch;
    NSMutableString *strM=[[NSMutableString alloc]init];
    for(int i=self.cur; i<self.text.length; i++){
        ch=[self.text characterAtIndex:i];
        [strM appendFormat:@"%C",ch];
        if(ch=='>')break;
    }
    return (NSString *)strM;
}
- (NSMutableArray *)split_HasFuhao{
    NSMutableArray *arrM=[[NSMutableArray alloc]init];
    unichar ch;
    for (self.cur=0; self.cur<self.text.length; self.cur++) {
        ch=[self.text characterAtIndex:self.cur];
        if(ch=='<'){
            [arrM addObject:[self kuohao_NoHasFuhao]];
        }
    }
    return arrM;
}
- (NSArray *)Getinformation:(NSMutableArray *)arrM{
    int i;BOOL Is_added=NO;
    NSUInteger now=0;
    NSRange range;
    NSString *temp_str;
    NSString *temp_str_all=@"";
    NSMutableString *temp_str2;
    NSMutableArray *arrM_temp=[[NSMutableArray alloc]init];
    if (arrM.count<=0) {
        return nil;
    }
    //功能:给每个数组里面的内容获取value值
    for(i=0;i<[arrM count]-1;i++){
        //功能:将每个数组里面的属性提取出来
        //因为已经是筛选出来已经配对好了的，所以直接提取就行了
        //如果里面含有keys和values，提取出来
        temp_str=((NSString *)arrM[i]);
        temp_str2=[NSMutableString stringWithString:arrM[i]];
        if([temp_str2 hasPrefix:@"/"]==NO){
            range=[temp_str rangeOfString:@" "];
            if(range.location!=NSNotFound){
                temp_str=[temp_str substringFromIndex:range.location+1];
                temp_str2=[NSMutableString stringWithString:arrM[i]];
                [temp_str2 deleteCharactersInRange:NSMakeRange(range.location+1,temp_str.length)];
                //temp_str_all=remove_space(temp_str);
                
                temp_str_all=[[temp_str2 stringByAppendingString:@"<key>"] stringByAppendingString:[self remove_space:temp_str]];
                
                //这里还有一种意外情况要考虑：<list dname="粮油米面" searchname="粮油米面"/>
                if([temp_str_all hasSuffix:@"/"]==YES){
                    temp_str_all=[temp_str_all substringToIndex:temp_str_all.length-1];
                    //                    NSLog(@"%@",temp_str_all);
                    [arrM_temp addObject:temp_str_all];
                    [arrM_temp addObject:[@"/" stringByAppendingString:[temp_str_all substringToIndex:[temp_str_all rangeOfString:@" "].location]]];
                    //                 NSLog(@"-------%@",[temp_str_all substringToIndex:[temp_str_all rangeOfString:@" "].location]);
                    temp_str_all=@"";
                    continue;
                }
            }
            else temp_str_all=@"";
        }
        
        Is_added =NO;
        temp_str2 =[[NSMutableString alloc]init];
        //如果节点里面有value值
        if([[@"/" stringByAppendingString:arrM[i]]hasPrefix:arrM[i+1]]){
            temp_str=[[@"<" stringByAppendingString:arrM[i]]stringByAppendingString:@">"];
            range=[self.text rangeOfString:temp_str options:NSLiteralSearch range:NSMakeRange(now, self.text.length-now)];
            now=range.location+range.length;
            //这里到时候可能会要修改，因为不知道没有值时是否要存空字符串
            temp_str=[self sub_info:now];
            if([temp_str_all isEqualToString: @""]==NO){
                [temp_str2 appendString:temp_str_all];
                if([temp_str isEqualToString: @""]==NO){
                    [temp_str2 appendString: @"<value>"];
                    [temp_str2 appendString: temp_str];
                }
                [arrM_temp addObject:temp_str2];
                Is_added=YES;
            }
            else if([temp_str isEqualToString: @""]==NO){
                [temp_str2 appendString:arrM[i]];
                [temp_str2 appendString: @" <value>"];
                [temp_str2 appendString: temp_str];
                [arrM_temp addObject:temp_str2];
                Is_added=YES;
            }
            //已经将所有的含有value的项目保存了下来  如果这里面也有keys，也保存了下来
            //            NSLog(@"%@",temp_str2);
        }
        //如果里面没有value，就保存这一项
        if(Is_added==NO){//如果里面有keys
            if([temp_str_all isEqualToString: @""]==NO){
                //                NSLog(@"%@",temp_str_all);
                [temp_str2 appendString:temp_str_all];
                [arrM_temp addObject:temp_str2];
            }
            else [arrM_temp addObject:arrM[i]];//如果里面没有keys，直接保存
        }
        temp_str_all=@"";//重置
    }
    [arrM_temp addObject:arrM[i]];//添加最后一个根节点
    return arrM_temp;
}
/**
 函数功能描述:这个函数是为了获取属性值中的兄弟值
 */
- (propertyNode *)next_gets_key:(NSArray *)arr :(int)n{
    for (int i=n; i<[arr count]; i++) {
        propertyNode *P_temp=[propertyNode new];
        NSString *keys=nil,*values=nil;
        
        NSString *temp=arr[i];
        if(!(temp.length>0))continue;//排除空的项,一般也不会出现这种情况
        if([temp rangeOfString:@"="].location==NSNotFound||[temp rangeOfString:@"\""].location==NSNotFound){
            //如果里面没有=符号,说明属性有问题
            NSLog(@"很有可能因为XML格式不对导致错误");
            NSLog(@"出错数据为:%@",temp);
            NSLog(@"%@",arr);
            return nil;
        }
        
        NSString *key=[temp substringToIndex:[temp rangeOfString:@"="].location];
        key=[self removeSpace:key];//移出前尾部的空格
        keys=[key copy];
        
        //id = "201502001" 截取 201502001"
        temp=[temp substringFromIndex:[temp rangeOfString:@"\""].location+1];
        if([temp rangeOfString:@"\""].location!=NSNotFound){
            NSString *value=[temp substringToIndex:[temp rangeOfString:@"\""].location];
            values=[value copy];
        }else{
            NSString *value=temp;
            values=[value copy];
        }
        return P_temp=setProperty(P_temp, keys, values, [self next_gets_key:arr :n+1]);
    }
    return nil;
}//已完成
/**
 函数功能描述:根据keys获取里面的属性值,一一拿出来
 */
- (propertyNode *)gets_key:(NSString *)str{
    
    propertyNode *P=[propertyNode new];
    
    //然而这个并不能简单的使用" "来分割,因为属性值里面存在" " 所以必须使用"\" "
    //但是还发现属性值中
//    <label opaque="NO" userInteractionEnabled="NO" contentMode="left" horizontalHuggingPriority="251" verticalHuggingPriority="251" text="  Label" textAlignment="natural" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" translatesAutoresizingMaskIntoConstraints="NO" id="wWT-gU-7Cd">
    
//    (
//     "opaque=\"NO",
//     "userInteractionEnabled=\"NO",
//     "contentMode=\"left",
//     "horizontalHuggingPriority=\"251",
//     "verticalHuggingPriority=\"251",
//     "text=",
//     " Label",
//     "textAlignment=\"natural",
//     "lineBreakMode=\"tailTruncation",
//     "baselineAdjustment=\"alignBaselines",
//     "adjustsFontSizeToFit=\"NO",
//     "translatesAutoresizingMaskIntoConstraints=\"NO",
//     "id=\"wWT-gU-7Cd\""
//     )
    
//    之前key="frame
//    之后frame
    
    NSArray *arr=[str componentsSeparatedByString:@"\" "];
    if([str rangeOfString:@"=\" "].location!=NSNotFound){
        NSMutableArray *arrM=[NSMutableArray array];
        for (int i=0; i<[arr count]-1; i++) {
            NSString *temp1=arr[i];
            NSString *temp2=arr[i+1];
            if ([temp1 hasSuffix:@"="]&&[temp2 rangeOfString:@"="].location==NSNotFound) {
                [arrM addObject:[[temp1 stringByAppendingString:@"\""]stringByAppendingString:temp2]];
                i++;
            }
            else{
                [arrM addObject:temp1];
            }
        }
        arr=arrM;
//        NSLog(@"\n\n%@\n\n",arrM);
    }
    
    for (int i=0; i<[arr count]; i++) {
        
//        propertyNode *P_temp=[propertyNode new];
        
        NSString *keys=nil,*values=nil;
        
        NSString *temp=arr[i];
        if(!(temp.length>0))continue;//排除空的项,一般也不会出现这种情况
        
        if([temp rangeOfString:@"="].location==NSNotFound||[temp rangeOfString:@"\""].location==NSNotFound){
            //如果里面没有=符号,说明属性有问题
            NSLog(@"很有可能因为XML格式不对导致错误");
            NSLog(@"出错数据为:%@",temp);
            //这里面是处理第一个兄弟节点的值,所以一般情况下,错误会出在后面连续获取兄弟节点值得过程中,因为那里可能出现 属性值有空格的情况
            return nil;
        }
        //id = "201502001"   截取id 但是可能会出现这种情况 id =中间有个空格
        NSString *key=[temp substringToIndex:[temp rangeOfString:@"="].location];
        key=[self removeSpace:key];//移出前尾部的空格
        keys=[key copy];
        
        //id = "201502001" 截取 201502001"
        temp=[temp substringFromIndex:[temp rangeOfString:@"\""].location+1];
        if([temp rangeOfString:@"\""].location!=NSNotFound){
            NSString *value=[temp substringToIndex:[temp rangeOfString:@"\""].location];
            values=[value copy];
        }else{
            NSString *value=temp;
            values=[value copy];
        }
        P=setProperty(P, keys, values, [self next_gets_key:arr :i+1]);
        
        //        display_propertys(P);
        return  P;
    }
    return nil;
}//已完成
/**
 函数功能描述:将开关</>删除,替换成/
 */
- (NSMutableArray *)get_out_ex:(NSMutableArray *)arr :(int)n{
    if(n>=[arr count])return arr;
    NSString *temp_s;
    NSArray *temp_a;
    int i=0;
    for (i=n+1; i<[arr count]; i++) {
        if([arr[i] hasPrefix:@"/"]){
            temp_s=arr[n];
            temp_a=[temp_s componentsSeparatedByString:@" "];
            temp_s=temp_a[0];
            if([[@"/" stringByAppendingString:temp_s] isEqualToString:arr[i]]){
                arr[i]=@"/";
                return arr;
            }
        }
    }
    if(i==[arr count])NSLog(@"出现不匹配问题:不过已经被解决");
    return arr;
}//已完成
/**
 函数功能描述:为下一个子节点赋值
 */
- (TreeNode *)next_child_tree:(NSMutableArray *)arr{
    
    NSString *temp;
    self.arr_cur++;
    if(self.arr_cur<[arr count]){
        temp=arr[self.arr_cur];
        if([temp hasPrefix:@"/"]){
            return nil;
        }//这句要非常谨慎 代表子节点的结束
        
        //        get_out_ex(arr, arr_cur);
        
        TreeNode *T_temp=[TreeNode new];
        NSString *name=nil,*value=nil;propertyNode *P=nil;
        
        if ([temp rangeOfString:@"<key>"].location!=NSNotFound) {  //如果存在keys值
            
            //拿到name
            //   firstName <key>id = "201502002"<value>李  拿到firstName
            if([temp rangeOfString:@" "].location!=NSNotFound){
                NSString *nameTemp=[temp substringToIndex:[temp rangeOfString:@" "].location];
                name=[nameTemp copy];
                if(!([temp substringToIndex:[temp rangeOfString:@" "].location].length>0)){
                    NSLog(@"出现严重BUG..........");
                }
            }
            
            if([temp rangeOfString:@"<value>"].location!=NSNotFound){  //如果还存在value值
                
                //拿到<key>id = "201502002"
                NSString *keys=[temp substringFromIndex:[temp rangeOfString:@"<key>"].location+5];
                keys=[keys substringToIndex:[keys rangeOfString:@"<value>"].location];
                
                //获取<key>id = "201502002"
                P=[propertyNode new];
                P=[self gets_key:keys];
                
                //获取"李"
                NSString *valueTemp=[temp substringFromIndex:[temp rangeOfString:@"<value>"].location+7];
                value=[valueTemp copy];
            }
            else{  //如果只存在keys值
                NSString *keys=[temp substringFromIndex:[temp rangeOfString:@"<key>"].location+5];
                P=[propertyNode new];
                P=[self gets_key:keys];
            }
        }
        else if([temp rangeOfString:@"<value>"].location!=NSNotFound){  //如果只存在value值
            
            NSString *nameTemp=[temp substringToIndex:[temp rangeOfString:@" "].location];
            name=[nameTemp copy];
            
            NSString *valueTemp=[temp substringFromIndex:[temp rangeOfString:@"<value>"].location+7];
            value=[valueTemp copy];
            
        }
        else{  //如果即不存在keys值，也不存在value值
            
            name=[temp copy];
            
        }
        //        printf("name=%s,value=%s\n",name,value);
        //        display_propertys(P);
        return T_temp=setTree(T_temp, value, name, [self next_child_tree:arr], [self next_brother_tree:arr], P);
    }
    return nil;
}
/**
 函数功能描述:为下一个兄弟节点赋值
 */
- (TreeNode *)next_brother_tree:(NSMutableArray *)arr
{
    NSString *temp;
    self.arr_cur++;
    if(self.arr_cur<[arr count]){
        temp=arr[self.arr_cur];
        if([temp hasPrefix:@"/"]){
            return nil;
        }
        
        //        get_out_ex(arr, arr_cur);
        
        TreeNode *T_temp=[TreeNode new];
        NSString *name=nil,*value=nil;propertyNode *P=nil;
        
        if ([temp rangeOfString:@"<key>"].location!=NSNotFound) {  //如果存在keys值
            
            //拿到name
            //   firstName <key>id = "201502002"<value>李  拿到firstName
            if([temp rangeOfString:@" "].location!=NSNotFound){
                NSString *nameTemp=[temp substringToIndex:[temp rangeOfString:@" "].location];
                name=[nameTemp copy];
                if(!([temp substringToIndex:[temp rangeOfString:@" "].location].length>0)){
                    NSLog(@"出现严重BUG..........");
                }
            }
            
            if([temp rangeOfString:@"<value>"].location!=NSNotFound){  //如果还存在value值
                
                //拿到<key>id = "201502002"
                NSString *keys=[temp substringFromIndex:[temp rangeOfString:@"<key>"].location+5];
                keys=[keys substringToIndex:[keys rangeOfString:@"<value>"].location];
                
                //获取<key>id = "201502002"
                P=[propertyNode new];
                P=[self gets_key:keys];
                //获取"李"
                NSString *valueTemp=[temp substringFromIndex:[temp rangeOfString:@"<value>"].location+7];
                value=[valueTemp copy];
                
            }
            else{  //如果只存在keys值
                
                NSString *keys=[temp substringFromIndex:[temp rangeOfString:@"<key>"].location+5];
                P=[propertyNode new];
                P=[self gets_key:keys];
                
            }
        }
        else if([temp rangeOfString:@"<value>"].location!=NSNotFound){  //如果只存在value值
            
            NSString *nameTemp=[temp substringToIndex:[temp rangeOfString:@" "].location];
            name=[nameTemp copy];
            
            NSString *valueTemp=[temp substringFromIndex:[temp rangeOfString:@"<value>"].location+7];
            value=[valueTemp copy];
            
        }
        else{  //如果即不存在keys值，也不存在value值
            
            name=[temp copy];
            
        }
        //        printf("name=%s,value=%s\n",name,value);
        //        display_propertys(P);
        return T_temp=setTree(T_temp, value, name, [self next_child_tree:arr], [self next_brother_tree:arr], P);
    }
    return nil;
}
/**
 函数功能描述:将信息保存成树形的数据结构中
 */
- (TreeNode *)get_tree:(NSMutableArray *)arr{
    NSString *temp;
    TreeNode *T=[TreeNode new];
    for(self.arr_cur=0;self.arr_cur<[arr count];self.arr_cur++){
        temp=arr[self.arr_cur];
        if([temp hasPrefix:@"/"]){//如果出现反斜杠,就跳过继续
            continue;
        }
        
        //1.将闭开关</>删除
        [self get_out_ex:arr :self.arr_cur];
        //2.进行存储信息
        
        //初始化
        NSString *name=nil,*value=nil;
        propertyNode *P=nil;
        
        if ([temp rangeOfString:@"<key>"].location!=NSNotFound) {  //如果存在keys值
            
            //拿到name
            //   firstName <key>id = "201502002"<value>李  拿到firstName
            if([temp rangeOfString:@" "].location!=NSNotFound){
                NSString *nameTemp=[temp substringToIndex:[temp rangeOfString:@" "].location];
                name=[nameTemp copy];
                if(!([temp substringToIndex:[temp rangeOfString:@" "].location].length>0)){
                    NSLog(@"出现严重BUG..........");
                }
            }
            
            if([temp rangeOfString:@"<value>"].location!=NSNotFound){  //如果还存在value值
                
                //拿到<key>id = "201502002"
                NSString *keys=[temp substringFromIndex:[temp rangeOfString:@"<key>"].location+5];
                keys=[keys substringToIndex:[keys rangeOfString:@"<value>"].location];
                
                //获取<key>id = "201502002"
                P=[propertyNode new];
                P=[self gets_key:keys];
                
                //获取"李"
                NSString *valueTemp=[temp substringFromIndex:[temp rangeOfString:@"<value>"].location+7];
                value=[valueTemp copy];
            }
            else{  //如果只存在keys值
                NSString *keys=[temp substringFromIndex:[temp rangeOfString:@"<key>"].location+5];
                P=[propertyNode new];
                P=[self gets_key:keys];
            }
        }//已完成
        else if([temp rangeOfString:@"<value>"].location!=NSNotFound){  //如果只存在value值
            
            NSString *nameTemp=[temp substringToIndex:[temp rangeOfString:@" "].location];
            name=[nameTemp copy];
            
            NSString *valueTemp=[temp substringFromIndex:[temp rangeOfString:@"<value>"].location+7];
            value=[valueTemp copy];
            
            
        }
        else{  //如果即不存在keys值，也不存在value值
            name=[temp copy];
        }
        //        printf("name=%s,value=%s\n",name,value);
        //        display_propertys(P);
        T=setTree(T, value, name, [self next_child_tree:arr], [self next_brother_tree:arr], P);
    }
    return T;
}

/**
 函数功能描述:将XML(文件)里面的信息挑出来,并且保存到树形结构中
 */
- (void)initWithXMLFilePath:(NSString *)filePath{
    //将XML文档进行特殊处理，得到主要信息
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self initWithXMLString:context];
}
/**
 函数功能描述:将XML里面的信息挑出来,并且保存到树形结构中
 */
- (void)initWithXMLString:(NSString *)string{
    self.text=string;
    //将XML文件提取出来节点信息，去除了括号
    NSMutableArray *arrM2=[self split_NoHasFuhao];
//
//    //将里面没有用或者错误信息进行删除
    [arrM2 removeObjectsAtIndexes:[self pass_NoHasFuhao:arrM2]];
//
//    //将筛选出来的信息进行最后一步信息获取与整理，便于保存到树形结构里面去
    NSArray *lastArr=[self Getinformation:arrM2];
    
    
    //将取出来的信息保存到树形结构里面去
//    [self displayMyInfo:lastArr];
    //    return;
    
    TreeNode *T1=[TreeNode new];
    T1=[self get_tree:[NSMutableArray arrayWithArray:lastArr]];
    _TNode=T1;
//    destroyTree(T1);
//    Pre_display(T1);
}//已完成


#pragma mark-----------具体取出数据相关的函数
- (TreeNode *)rootElement{
    return _TNode;
}
- (TreeNode *)getIdForPath:(TreeNode *)T :(NSArray *)arr :(int)n{
    if(n==[arr count]-1&&[T.name isEqualToString:arr[n]])return T;
    else if(n<[arr count]&&(T!=nil||T.child!=nil)){
        if([T.name isEqualToString:arr[n]]){
            return  [self getIdForPath:T.child :arr :n+1];
        }
        while (T.brother!=nil){
            T=T.brother;
            if([T.name isEqualToString:arr[n]]){
                return [self getIdForPath:T.child :arr :n+1];
            }
        }
    }
    return nil;
}
- (NSArray *)nodesForAbsoluteAddressXPath:(NSString *)xpath{
    if([xpath hasSuffix:@"/"])xpath=[xpath substringToIndex:xpath.length-1];
    NSArray *arr=[xpath componentsSeparatedByString:@"/"];
    return [self children:[self getIdForPath:self.TNode :arr :0]];
}
- (NSArray *)nodesForRelativeAddressWithTreeNode:(TreeNode *)T XPath:(NSString *)xpath{
    if([xpath hasSuffix:@"/"])xpath=[xpath substringToIndex:xpath.length-1];
    NSArray *arr=[xpath componentsSeparatedByString:@"/"];
    TreeNode *node=[self getIdForPath:T :arr :0];
    return [self children:node];
}
//获取某个节点的所有孩子节点
- (NSArray *)children:(TreeNode *)T{
    NSMutableArray *arrM=[[NSMutableArray alloc]init];
    if(T.child!=nil) {
        T=T.child;
        [arrM addObject:[NSValue value:&T withObjCType:@encode(TreeNode)]];
        while (T.brother!=nil) {
            T=T.brother;
            [arrM addObject:[NSValue value:&T withObjCType:@encode(TreeNode)]];
        }
        return arrM;
    }
    return nil;
}
//取出某个节点的孩子节点
- (NSArray *)elementsForName:(TreeNode *)T :(NSString *)name{
    if([T.name isEqualToString:name]){
        NSMutableArray *arrM=[[NSMutableArray alloc]init];
        if(T.child!=nil) {
            T=T.child;
                [arrM addObject:[NSValue value:&T withObjCType:@encode(TreeNode)]];
            while (T.brother!=nil) {
                T=T.brother;
                [arrM addObject:[NSValue value:&T withObjCType:@encode(TreeNode)]];
            }
            return arrM;
        }
    }
    return nil;
}
//取出某个节点属性值
- (NSString *)attributeForName:(TreeNode *)T :(NSString *)name{
    if(T!=nil){
        if(T.propertys!=nil) {
            propertyNode *P=T.propertys;
            if([P.key isEqualToString:name])
                return [P.value copy];
            while(P.next!=nil){
                P=P.next;
                if([P.key isEqualToString:name])
                    return [P.value copy];
            }
        }
    }
    return nil;
}
//取出某个节点的Value值
- (NSString *)stringValue:(TreeNode *)T{
    if(T!=nil)
        return [T.value copy];
    return nil;
}
//获取某个节点的孩子个数
- (NSUInteger)childCount:(TreeNode *)T{
    NSInteger count=0;
    if(T.child!=nil) {
        count++;
        T=T.child;
        while (T.brother!=nil) {
            count++;
            T=T.brother;
        }
    }
    return count;
}


#pragma mark-----------将XML数据转换成Plist文件的相关的函数
- (BOOL)XML_TO_Plist:(NSString *)path1 :(NSString*)path2{
    [self initWithXMLFilePath:path1];
    NSDictionary *dict=[self TreeToDict:_TNode];
    return [dict writeToFile:path2 atomically:YES];
}
/**
 函数功能描述:将树形结构保存的数据写到plist文件中
 */
-(void)write_propertysToDict:(NSMutableDictionary *)dicM :(propertyNode *)P{
    if(P!=nil){
        if(P.key!=nil&&P.value!=nil)
            [dicM setObject:P.value forKey:P.key];
        if(P.next!=nil)
            [self write_propertysToDict:dicM :P.next];
    }
}
- (NSMutableArray *)child_Dic:(TreeNode *)T{
    NSMutableArray *arrM=[[NSMutableArray alloc]init];
    if(T!=nil){
        NSMutableDictionary *dicM=[[NSMutableDictionary alloc]init];
        [dicM setObject:T.name forKey:@"self_Node_Name"];
        if(T.value!=nil)
            [dicM setObject:T.value forKey:@"self_Node_value"];
        if(T.propertys!=nil)
            [self write_propertysToDict:dicM :T.propertys];
        if(T.child!=nil){
            NSMutableArray *arrM_child=[[NSMutableArray alloc]init];
            arrM_child=[self child_Dic:T.child];
            [dicM setObject:arrM_child forKey:@"child_nodes"];
        }
        else [dicM setObject:@"" forKey:@"child_nodes"];
        [arrM addObject:dicM];
        if(T.brother!=nil){//应该把兄弟节点保存到数组里面
            [self brother_Dic:T.brother :arrM];
        }
    }
    return arrM;
}
- (void)brother_Dic:(TreeNode *)T :(NSMutableArray *)arrM{
    if(T!=nil){
        NSMutableDictionary *dicM=[[NSMutableDictionary alloc]init];
        [dicM setObject:T.name forKey:@"self_Node_Name"];
        if(T.value!=nil)
            [dicM setObject:T.value forKey:@"self_Node_value"];
        if(T.propertys!=nil)
            [self write_propertysToDict:dicM :T.propertys];
        if(T.child!=nil){
            NSMutableArray *arrM_child=[[NSMutableArray alloc]init];
            arrM_child=[self child_Dic:T.child];
            [dicM setObject:arrM_child forKey:@"child_nodes"];
        }
        else [dicM setObject:@"" forKey:@"child_nodes"];
        [arrM addObject:dicM];
        
        if(T.brother!=nil){
            [self brother_Dic:T.brother :arrM];
        }
    }
}

#pragma mark-----------辅助函数
/**获取子节点*/
- (NSArray *)childDic:(NSDictionary *)dic{
    if (dic[@"child_nodes"]!=nil&&[dic[@"child_nodes"] isKindOfClass:[NSArray class]]) {
        return dic[@"child_nodes"];
    }
    return nil;
}
/**获取当前节点的名字*/
- (NSString *)dicNodeName:(NSDictionary *)dic{
    if ([dic[@"self_Node_Name"] isKindOfClass:[NSString class]]&&[dic[@"self_Node_Name"] length]>0) {
        return dic[@"self_Node_Name"];
    }
    return @"";
}
/**获取当前节点指定的值*/
- (NSString *)dicNodeValueWithKey:(NSString *)key ForDic:(NSDictionary *)dic{
    if ([dic[key] isKindOfClass:[NSString class]]&&[dic[key] length]>0) {
        return dic[key];
    }
    return @"";
}

- (BOOL)checkNodeValue:(id)value{
    if ([value isKindOfClass:[NSString class]]&&([value length]>0)) {
        return YES;
    }
    return NO;
}
#pragma mark-----------字典操作相关函数
/**将树转换成字典*/
- (NSDictionary *)TreeToDict:(TreeNode *)T{
    //当做一个字典，selfName-root  selfDic-child
    NSMutableDictionary *dicM=[[NSMutableDictionary alloc]init];
    if(T!=nil){
        [dicM setObject:T.name forKey:@"self_Node_Name"];
        if(T.value!=nil)
            [dicM setObject:T.value forKey:@"self_Node_value"];
        if(T.propertys!=nil)
            [self write_propertysToDict:dicM :T.propertys];
        if(T.child!=nil){
            NSMutableArray *arrM_child=[[NSMutableArray alloc]init];
            arrM_child=[self child_Dic:T.child];
            [dicM setObject:arrM_child forKey:@"child_nodes"];
        }
        else [dicM setObject:@"" forKey:@"child_nodes"];
        
        if(T.brother!=nil){//应该把兄弟节点保存到数组里面
            NSLog(@"根节点不应该再有兄弟节点，请检查数据是否有误!");
        }
    }
    return dicM;
}
/**查找整个字典中某个名字的子节点的个数*/
- (NSInteger)countOfTargetNodeWithName:(NSString *)name withDic:(NSDictionary *)dic withCount:(NSInteger)count{
    if([[self dicNodeName:dic]isEqualToString:name])count++;
    NSArray *childArr=[self childDic:dic];
    if (childArr!=nil) {
        for (id obj in childArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                count=[self countOfTargetNodeWithName:name withDic:obj withCount:count];
            }
        }
        return count;
    }
    return count;
}
/**获取指定路径下目标节点的指定key的值*/
- (void)getTargetNodeArrWithName:(NSString *)name withDic:(NSDictionary *)dic withtargetKey:(NSString *)key withArrM:(NSMutableArray *)ArrM{
    if (!ArrM) {
        ArrM=[NSMutableArray array];
    }
    if([[self dicNodeName:dic]isEqualToString:name]){
        if ([self checkNodeValue:[self dicNodeValueWithKey:key ForDic:dic]]) {
            [ArrM addObject:[self dicNodeValueWithKey:key ForDic:dic]];
        }
    }
    NSArray *childArr=[self childDic:dic];
    if (childArr!=nil) {
        for (id obj in childArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [self getTargetNodeArrWithName:name withDic:obj withtargetKey:key withArrM:ArrM];
            }
        }
    }
}

/**获取指定路径下目标节点数组(也就是说,所有目标节点)*/
- (void)getTargetNodeArrWithName:(NSString *)name withDic:(NSDictionary *)dic withArrM:(NSMutableArray *)ArrM{
    if (!ArrM) {
        ArrM=[NSMutableArray array];
    }
    if([[self dicNodeName:dic]isEqualToString:name]){
        [ArrM addObject:dic];
    }
    //获取孩子节点的目标节点,其中所有的孩子不止两个(兄弟节点)
    NSArray *childArr=[self childDic:dic];
    if (childArr!=nil) {
        for (id obj in childArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [self getTargetNodeArrWithName:name withDic:(NSDictionary *)obj withArrM:ArrM];
            }
        }
    }
}

/**获取指定路径下目标节点数组(也就是说,所有目标节点) 查询根据,不是具体的路径,而是某个节点中的属性值*/
- (void)getTargetNodeArrWithKeyName:(NSString *)keyName andKeyValue:(NSString *)keyValue withDic:(NSDictionary *)dic withArrM:(NSMutableArray *)ArrM{
    if (!ArrM) {
        ArrM=[NSMutableArray array];
    }
    if ([self dicNodeValueWithKey:keyName ForDic:dic].length>0) {
        if ([[self dicNodeValueWithKey:keyName ForDic:dic] isEqualToString:keyValue]) {
            [ArrM addObject:dic];
        }
    }else if ([keyValue hasPrefix:@"self.view"]&&[self dicNodeValueWithKey:@"id" ForDic:dic].length>0) {
        if ([[self dicNodeValueWithKey:@"id" ForDic:dic] hasPrefix:keyValue]) {
            [ArrM addObject:dic];
        }
    }
    //获取孩子节点的目标节点,其中所有的孩子不止两个(兄弟节点)
    NSArray *childArr=[self childDic:dic];
    if (childArr!=nil) {
        for (id obj in childArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [self getTargetNodeArrWithKeyName:keyName andKeyValue:keyValue withDic:(NSDictionary *)obj withArrM:ArrM];
            }
        }
    }
}

/**获取指定路径下目标节点数组(中间不包括,某些节点)(也就是说,所有目标节点)*/
- (void)getTargetNodeArrWithName:(NSString *)name withDic:(NSDictionary *)dic withArrM:(NSMutableArray *)ArrM notContain:(NSArray *)path withSuccess:(BOOL)success{
    if (!ArrM) {
        ArrM=[NSMutableArray array];
    }
    
    NSString *self_node_name=[self dicNodeName:dic];
    
    if([self_node_name isEqualToString:name]){
        [ArrM addObject:dic];
        success=YES;
    }
    
    if (success) {
        //进行筛选
        for (NSString *condition in path) {
            if ([self_node_name isEqualToString:condition]) {
                return;
            }
        }
    }
    
    //获取孩子节点的目标节点,其中所有的孩子不止两个(兄弟节点)
    NSArray *childArr=[self childDic:dic];
    if (childArr!=nil) {
        for (id obj in childArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                for (NSString *condition in path) {
                    if ([[self dicNodeName:obj] isEqualToString:condition]) {
                        success=YES;//已经是嵌套了
                    }
                }
                //真的很巧妙
                [self getTargetNodeArrWithName:name withDic:(NSDictionary *)obj withArrM:ArrM notContain:path withSuccess:success];
            }
        }
    }
}

/**获取某个路径链表下的节点*/
- (NSDictionary *)getDicFormPathArr:(NSArray *)paths withIndex:(NSInteger)index withDic:(NSDictionary *)dic{
    if (paths.count<=index) {
        return nil;
    }
    NSString *target=paths[index];
    if ([self checkNodeValue:[self dicNodeName:dic]]) {
        if([[self dicNodeName:dic]isEqualToString:target]) {
            if (index==paths.count-1) {
                return dic;
            }
            return [self getDicFormPathArr:paths withIndex:index+1 withDic:dic];
        }
    }
    
    NSArray *childArr=[self childDic:dic];
    if (childArr!=nil) {
        for (id obj in childArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *targetDic=[self getDicFormPathArr:paths withIndex:index withDic:obj];
                if (targetDic!=nil) {
                    return targetDic;
                }
            }
        }
    }
    return nil;
}

/**获取某个路径链表下的所有节点*/
- (NSDictionary *)getDicArrFormPathArr:(NSArray *)paths withIndex:(NSInteger)index withDic:(NSDictionary *)dic addToArrM:(NSMutableArray *)arrM{
    
    if (arrM==nil) {
        arrM=[NSMutableArray array];
    }
    
    if (paths.count<=index) {
        return nil;
    }
    
    NSString *target=paths[index];
    if ([self checkNodeValue:[self dicNodeName:dic]]) {
        if([[self dicNodeName:dic]isEqualToString:target]) {
            if (index==paths.count-1) {
                [arrM addObject:dic];
                return dic;
            }
            return [self getDicArrFormPathArr:paths withIndex:index+1 withDic:dic addToArrM:arrM];
        }
    }
    
    NSArray *childArr=[self childDic:dic];
    if (childArr!=nil) {
        for (id obj in childArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *targetDic=
                [self getDicArrFormPathArr:paths withIndex:index withDic:obj addToArrM:arrM];
//                if (targetDic!=nil) {
//                    return targetDic;//这里是返回第一个,而不是全部
//                }
            }
        }
    }
    return nil;
}

/**获取指定条件下的节点*/
- (NSDictionary *)getDicWithCondition:(NSDictionary *)condition withDic:(NSDictionary *)dic{
    if(condition.count<1)return nil;
    for (NSString *str in condition) {
        if (str.length<=0||condition[str]==nil) {
            return nil;
        }
    }
    
    BOOL success=YES;
    for (NSString *str in condition) {
        if ([self checkNodeValue:[self dicNodeValueWithKey:str ForDic:dic]]) {
            if (![[self dicNodeValueWithKey:str ForDic:dic] isEqualToString:condition[str]]) {
                success=NO;
                break;
            }
        }else{
            success=NO;
            break;
        }
        
    }
    
    if (success) {
        return dic;
    }
    
    NSArray *childArr=[self childDic:dic];
    if (childArr!=nil) {
        for (id obj in childArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *targetDic=[self getDicWithCondition:condition withDic:obj];
                if (targetDic!=nil) {
                    return targetDic;
                }
            }
        }
    }
    return nil;
}
@end