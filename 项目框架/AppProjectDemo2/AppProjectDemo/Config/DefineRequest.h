//
//  DefineRequest.h
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/28.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#ifndef DefineRequest_h
#define DefineRequest_h

//列表一页请求数量
#define REQUEST_MIN_PAGE_NUM 10
//连接超时时间
#define RequestTimeOut 30


#if DEBUG

//****************测试环境***********
#define BaseURLString  @"http://192.168.1.175:8080/baidu/rest/post"

#else

//**************生产版本**************
#define BaseURLString  @"http://192.168.1.175:8080/baidu/rest/post"

#endif

#endif /* DefineRequest_h */
