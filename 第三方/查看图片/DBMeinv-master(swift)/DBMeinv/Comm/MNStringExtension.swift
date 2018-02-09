//
//  MNStringExtension.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/24.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import Foundation

extension String{
    func escapeSpaceTillCahractor()->String{
        return self.stringEscapeHeadTail(strs:["\r", " ", "\n"])
    }
    func escapeHeadStr(str:String)->(String, Bool){
        var result = self as NSString
        var findAtleastOne = false
        while( true ){
            let range = result.range(of: str)
            if range.location == 0 && range.length == 1 {
                result = result.substring(from: range.length) as NSString
                findAtleastOne = true
            }else{
                break
            }
        }
        return (result as String, findAtleastOne)
    }
    func escapeSpaceTillCahractor(strs:[String])->String{
        var result = self
        while( true ){
            var findAtleastOne = false
            for str in strs {
                var found:Bool = false
                (result, found) = result.escapeHeadStr(str: str)
                if found {
                    findAtleastOne = true
                    break  //for循环
                }
            }
            if findAtleastOne == false {
                break
            }
        }
        return result as String
    }
    func reverse()->String{
        var inReverse = ""
        for letter in self {
            inReverse = "\(letter)" + inReverse
        }
        return inReverse
    }
    
    func escapeHeadTailSpace()->String{
        return self.escapeSpaceTillCahractor().reverse().escapeSpaceTillCahractor().reverse()
    }
    
    func stringEscapeHeadTail(strs:[String])->String{
        return self.escapeSpaceTillCahractor(strs:strs).reverse().escapeSpaceTillCahractor(strs:strs).reverse()
    }
}
