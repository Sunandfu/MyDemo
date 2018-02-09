//
//  CreatFatherFile.m
//  代码助手
//
//  Created by mac on 16/3/19.
//  Copyright © 2016年 com/ZQ/mac. All rights reserved.
//

#import "CreatFatherFile.h"

@implementation CreatFatherFile

- (BOOL)judge:(NSString *)text{
    if (text.length==0||[text isEqualToString:@"请填写"]||[text isEqualToString:@"<#请填写#>"]) {
        return NO;
    }
    return YES;
}
- (NSString *)getInfoFromDic:(NSArray *)arr{
    
    NSMutableString *strM=[NSMutableString string];
    
    [strM setString:@"{\n"];
    for (NSInteger i=0; i<arr.count; i++) {
        if (i!=arr.count-1) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"\"%@\":\"<#请填写#>\",",arr[i]]] ToStrM:strM];
        }else{
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"\"%@\":\"<#请填写#>\"",arr[i]]] ToStrM:strM];
        }
    }
    [strM appendString:@"}"];
    
    return strM;
}
- (NSDictionary *)getDicFromFileName:(NSString *)fileName{
    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    
    if ([fileName hasSuffix:@".m"]) {
        filePath =[filePath stringByAppendingPathComponent:fileName];
    }else{
        filePath =[filePath stringByAppendingPathComponent:[fileName stringByAppendingString:@".m"]];
    }
    
    NSString *strTemp=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return [NSJSONSerialization JSONObjectWithData:[strTemp dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}
- (NSString *)creatFatherFile:(NSString *)fileName andData:(NSArray *)arrData{
    
    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    
    if ([fileName hasSuffix:@".m"]) {
        filePath =[filePath stringByAppendingPathComponent:fileName];
    }else{
        filePath =[filePath stringByAppendingPathComponent:[fileName stringByAppendingString:@".m"]];
    }
    
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self getInfoFromDic:arrData]dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    return filePath;
}
- (void)saveText:(NSString *)text toFileName:(NSArray *)fileNameDegree{
    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    
    for (NSInteger i=0; i<fileNameDegree.count; i++) {
        if (![fileNameDegree[i] hasPrefix:@"."]) {
            filePath =[filePath stringByAppendingPathComponent:fileNameDegree[i]];
        }else{
            filePath =[filePath stringByAppendingString:fileNameDegree[i]];
        }
    }
    
    NSLog(@"保存的文件:%@",filePath);
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:[text dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}
- (NSString *)getDirectoryPath:(NSString *)fileName{
    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    filePath =[filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

- (void)saveStoryBoardCollectionViewToFileName:(NSArray *)fileNameDegree{
    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    
    for (NSInteger i=0; i<fileNameDegree.count; i++) {
        if (![fileNameDegree[i] hasPrefix:@"."]) {
            filePath =[filePath stringByAppendingPathComponent:fileNameDegree[i]];
        }else{
            filePath =[filePath stringByAppendingString:fileNameDegree[i]];
        }
    }
    
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self CollectionViewController] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}
- (void)saveStoryBoard:(NSString *)ViewController TableViewCells:(NSArray *)tableviewCells toFileName:(NSArray *)fileNameDegree{
    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    
    for (NSInteger i=0; i<fileNameDegree.count; i++) {
        if (![fileNameDegree[i] hasPrefix:@"."]) {
            filePath =[filePath stringByAppendingPathComponent:fileNameDegree[i]];
        }else{
            filePath =[filePath stringByAppendingString:fileNameDegree[i]];
        }
    }
    
    NSLog(@"保存的文件:%@",filePath);
    
    if (ViewController.length<=0) {
        [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self NoViewController] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }else if (ViewController.length>0){
        if (tableviewCells.count==0) {
            [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self ViewController] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }else if(tableviewCells.count>0){
            [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self ViewController:ViewController TableViewCells:tableviewCells] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
    }
}

- (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM{
    
    if (strM==nil) {
        strM=[NSMutableString string];
    }
    
    for (NSString  *str in values) {
        [strM appendFormat:@"%@\n",str];
    }
    
}
+ (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM{
    
    if (strM==nil) {
        strM=[NSMutableString string];
    }
    
    for (NSString  *str in values) {
        [strM appendFormat:@"%@\n",str];
    }
    
}
- (NSString *)creatFatherFileDirector:(NSString *)directorName toFatherDirector:(NSString *)fatherDirectorName{
    NSString *filePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    
    if (fatherDirectorName.length==0) {
        filePath =[filePath stringByAppendingPathComponent:directorName];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }
        [[NSFileManager defaultManager]createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        filePath = [fatherDirectorName stringByAppendingPathComponent:directorName];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }
        [[NSFileManager defaultManager]createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}

/**打开某个文件*/
- (void)openFile:(NSString *)fileName{
    if ([[NSFileManager defaultManager]fileExistsAtPath:fileName]) {
        NSString *open=[NSString stringWithFormat:@"open %@",fileName];
        system([open UTF8String]);
    }
}

#pragma mark- StoryBoard生成相关函数
- (NSString *)ViewController{
    return @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" initialViewController=\"BYZ-38-t0r\">\n\
    <dependencies>\n\
    <deployment identifier=\"iOS\"/>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
    </dependencies>\n\
    <scenes>\n\
    <!--View Controller-->\n\
    <scene sceneID=\"tne-QT-ifu\">\n\
    <objects>\n\
    <viewController id=\"BYZ-38-t0r\" customClass=\"ViewController\" sceneMemberID=\"viewController\">\n\
    <layoutGuides>\n\
    <viewControllerLayoutGuide type=\"top\" id=\"y3c-jy-aDJ\"/>\n\
    <viewControllerLayoutGuide type=\"bottom\" id=\"wfy-db-euE\"/>\n\
    </layoutGuides>\n\
    <view key=\"view\" contentMode=\"scaleToFill\" id=\"8bC-Xf-vdC\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
    <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"calibratedWhite\"/>\n\
    </view>\n\
    </viewController>\n\
    <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"dkx-z0-nzr\" sceneMemberID=\"firstResponder\"/>\n\
    </objects>\n\
    </scene>\n\
    </scenes>\n\
    </document>";
}
- (NSString *)NoViewController{
    return @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">\n\
    <dependencies>\n\
    <deployment identifier=\"iOS\"/>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
    </dependencies>\n\
    <scenes/>\n\
    </document>\n";
}

- (NSString *)CollectionViewController{
    return @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" initialViewController=\"BYZ-38-t0r\">\n\
    <dependencies>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
    </dependencies>\n\
    <scenes>\n\
    <!--View Controller-->\n\
    <scene sceneID=\"tne-QT-ifu\">\n\
    <objects>\n\
    <viewController id=\"BYZ-38-t0r\" customClass=\"ViewController\" sceneMemberID=\"viewController\">\n\
    <layoutGuides>\n\
    <viewControllerLayoutGuide type=\"top\" id=\"y3c-jy-aDJ\"/>\n\
    <viewControllerLayoutGuide type=\"bottom\" id=\"wfy-db-euE\"/>\n\
    </layoutGuides>\n\
    <view key=\"view\" contentMode=\"scaleToFill\" id=\"8bC-Xf-vdC\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
    <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
    <subviews>\n\
    <collectionView clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"scaleToFill\" dataMode=\"prototypes\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"HbT-4V-9Tc\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
    <collectionViewFlowLayout key=\"collectionViewLayout\" minimumLineSpacing=\"10\" minimumInteritemSpacing=\"10\" id=\"QP9-Ck-1hA\">\n\
    <size key=\"itemSize\" width=\"179\" height=\"225\"/>\n\
    <size key=\"headerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
    <size key=\"footerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
    <inset key=\"sectionInset\" minX=\"0.0\" minY=\"0.0\" maxX=\"0.0\" maxY=\"0.0\"/>\n\
    </collectionViewFlowLayout>\n\
    <cells>\n\
    <collectionViewCell opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\" id=\"8yV-AY-QOk\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"179\" height=\"225\"/>\n\
    <autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>\n\
    <view key=\"contentView\" opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"179\" height=\"225\"/>\n\
    <autoresizingMask key=\"autoresizingMask\"/>\n\
    <subviews>\n\
    <imageView userInteractionEnabled=\"NO\" contentMode=\"scaleToFill\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"NnF-lK-YUx\">\n\
    <rect key=\"frame\" x=\"4\" y=\"8\" width=\"171\" height=\"128\"/>\n\
    </imageView>\n\
    <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"DrE-ot-FeI\">\n\
    <rect key=\"frame\" x=\"68\" y=\"155\" width=\"42\" height=\"21\"/>\n\
    <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
    <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
    <nil key=\"highlightedColor\"/>\n\
    </label>\n\
    <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"Hsq-wx-BBy\">\n\
    <rect key=\"frame\" x=\"68\" y=\"190\" width=\"42\" height=\"21\"/>\n\
    <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
    <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
    <nil key=\"highlightedColor\"/>\n\
    </label>\n\
    </subviews>\n\
    <color key=\"backgroundColor\" white=\"0.0\" alpha=\"0.0\" colorSpace=\"calibratedWhite\"/>\n\
    </view>\n\
    </collectionViewCell>\n\
    </cells>\n\
    </collectionView>\n\
    </subviews>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"calibratedWhite\"/>\n\
    <constraints>\n\
    <constraint firstItem=\"wfy-db-euE\" firstAttribute=\"top\" secondItem=\"HbT-4V-9Tc\" secondAttribute=\"bottom\" id=\"fIe-42-kHi\"/>\n\
    <constraint firstItem=\"HbT-4V-9Tc\" firstAttribute=\"top\" secondItem=\"y3c-jy-aDJ\" secondAttribute=\"bottom\" id=\"fK6-Uv-MP8\"/>\n\
    <constraint firstAttribute=\"trailing\" secondItem=\"HbT-4V-9Tc\" secondAttribute=\"trailing\" id=\"u85-h7-fxr\"/>\n\
    <constraint firstItem=\"HbT-4V-9Tc\" firstAttribute=\"leading\" secondItem=\"8bC-Xf-vdC\" secondAttribute=\"leading\" id=\"xqh-qE-f0m\"/>\n\
    </constraints>\n\
    </view>\n\
    </viewController>\n\
    <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"dkx-z0-nzr\" sceneMemberID=\"firstResponder\"/>\n\
    </objects>\n\
    <point key=\"canvasLocation\" x=\"565\" y=\"487\"/>\n\
    </scene>\n\
    </scenes>\n\
    </document>";
}

- (NSString *)ViewController:(NSString *)viewController TableViewCells:(NSArray *)tableviewCells{
    NSMutableString *text=[NSMutableString string];
    
    [text appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
     <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">\n\
     <dependencies>\n\
     <deployment identifier=\"iOS\"/>\n\
     <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
     </dependencies>\n\
     <scenes>\n\
     <!--View Controller-->\n\
     <scene sceneID=\"ln6-he-TvZ\">\n\
     <objects>\n"];
    
    
    if (viewController.length>0) {
        [text appendFormat:@"<viewController storyboardIdentifier=\"%@ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"VQU-UQ-5rH\" customClass=\"%@ViewController\" sceneMemberID=\"viewController\">\n",viewController,viewController];
    }else{
        [text appendFormat:@"<viewController storyboardIdentifier=\"ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"VQU-UQ-5rH\" customClass=\"ViewController\" sceneMemberID=\"viewController\">\n"];
    }
    
    [text appendString:@"<layoutGuides>\n\
     <viewControllerLayoutGuide type=\"top\" id=\"Fs0-p9-OwV\"/>\n\
     <viewControllerLayoutGuide type=\"bottom\" id=\"JON-mD-ZcH\"/>\n\
     </layoutGuides>\n\
     <view key=\"view\" contentMode=\"scaleToFill\" id=\"1m3-F1-jrf\">\n\
     <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
     <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
     <subviews>\n\
     <tableView clipsSubviews=\"YES\" contentMode=\"scaleToFill\" alwaysBounceVertical=\"YES\" dataMode=\"prototypes\" style=\"plain\" separatorStyle=\"default\" rowHeight=\"124\" sectionHeaderHeight=\"28\" sectionFooterHeight=\"28\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"AUd-uD-BAZ\">\n\
     <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
     <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n"];
    
    if (tableviewCells.count>0) {
        [text appendString:@"\n<prototypes>\n"];
        for (NSString *cells in tableviewCells) {
            NSString *idText=[self getStoryBoardIdString];
            NSString *idText2=[self getStoryBoardIdString];
            [text appendFormat:@"<tableViewCell clipsSubviews=\"YES\" contentMode=\"scaleToFill\" selectionStyle=\"default\" indentationWidth=\"10\" reuseIdentifier=\"%@\" rowHeight=\"124\" id=\"%@\" customClass=\"%@\">\n\
             <rect key=\"frame\" x=\"0.0\" y=\"28\" width=\"600\" height=\"124\"/>\n\
             <autoresizingMask key=\"autoresizingMask\"/>\n\
             <tableViewCellContentView key=\"contentView\" opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\" tableViewCell=\"%@\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"123\"/>\n\
             <autoresizingMask key=\"autoresizingMask\"/>\n",cells,idText,cells,idText,idText2];
            
            NSString *imageViewID=[self getStoryBoardIdString];
            NSString *LabelID=[self getStoryBoardIdString];
            NSString *ButtonID=[self getStoryBoardIdString];
            NSString *TextFiledID=[self getStoryBoardIdString];
            
            [text appendFormat:@"<subviews>\n\
             <imageView userInteractionEnabled=\"NO\" contentMode=\"scaleToFill\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"17\" y=\"8\" width=\"102\" height=\"107\"/>\n\
             </imageView>\n\
             <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"164\" y=\"51\" width=\"42\" height=\"21\"/>\n\
             <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
             <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
             <nil key=\"highlightedColor\"/>\n\
             </label>\n\
             <button opaque=\"NO\" contentMode=\"scaleToFill\" fixedFrame=\"YES\" contentHorizontalAlignment=\"center\" contentVerticalAlignment=\"center\" buttonType=\"roundedRect\" lineBreakMode=\"middleTruncation\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"506\" y=\"47\" width=\"46\" height=\"30\"/>\n\
             <state key=\"normal\" title=\"Button\"/>\n\
             </button>\n\
             <textField opaque=\"NO\" clipsSubviews=\"YES\" contentMode=\"scaleToFill\" fixedFrame=\"YES\" contentHorizontalAlignment=\"left\" contentVerticalAlignment=\"center\" borderStyle=\"roundedRect\" textAlignment=\"natural\" minimumFontSize=\"17\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"252\" y=\"13\" width=\"97\" height=\"30\"/>\n\
             <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"14\"/>\n\
             <textInputTraits key=\"textInputTraits\"/>\n\
             </textField>\n\
             </subviews>",imageViewID,LabelID,ButtonID,TextFiledID];
            
            [text appendString:@"</tableViewCellContentView>\n\
             </tableViewCell>\n"];
            
        }
        [text appendString:@"\n</prototypes>\n"];
    }
    
    [text appendString:@"</tableView>\n\
     </subviews>\n\
     <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n\
     <constraints>\n\
     <constraint firstItem=\"AUd-uD-BAZ\" firstAttribute=\"leading\" secondItem=\"1m3-F1-jrf\" secondAttribute=\"leading\" id=\"IFI-ix-5mE\"/>\n\
     <constraint firstItem=\"AUd-uD-BAZ\" firstAttribute=\"top\" secondItem=\"Fs0-p9-OwV\" secondAttribute=\"bottom\" id=\"ZBG-g6-JnN\"/>\n\
     <constraint firstItem=\"JON-mD-ZcH\" firstAttribute=\"top\" secondItem=\"AUd-uD-BAZ\" secondAttribute=\"bottom\" id=\"gtw-gO-Drr\"/>\n\
     <constraint firstAttribute=\"trailing\" secondItem=\"AUd-uD-BAZ\" secondAttribute=\"trailing\" id=\"rHu-tH-pGX\"/>\n\
     </constraints>\n\
     </view>\n\
     </viewController>\n\
     <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"J53-ai-Zgt\" userLabel=\"First Responder\" sceneMemberID=\"firstResponder\"/>\n\
     </objects>\n\
     <point key=\"canvasLocation\" x=\"413\" y=\"554\"/>\n\
     </scene>\n\
     </scenes>\n\
     </document>\n"];
    return text;
}
- (NSString *)getStoryBoardIdString{
//    gSS-Oy-SNc
    NSMutableString *idText=[NSMutableString string];
    while (idText.length<3) {
        [idText appendString:[self getCharacter]];
    }
    [idText appendString:@"-"];
    while (idText.length<6) {
        [idText appendString:[self getCharacter]];
    }
    [idText appendString:@"-"];
    while (idText.length<10) {
        [idText appendString:[self getCharacter]];
    }
    return idText;
}
- (NSString *)getCharacter{
    NSInteger count=arc4random()%3+1;
    
    unichar ch;
    if (count==1) {
        ch='0'+arc4random()%10;
    }else if (count==2){
        ch='A'+arc4random()%26;
    }else if (count==3){
        ch='a'+arc4random()%26;
    }
    return [NSString stringWithFormat:@"%C",ch];
}
@end