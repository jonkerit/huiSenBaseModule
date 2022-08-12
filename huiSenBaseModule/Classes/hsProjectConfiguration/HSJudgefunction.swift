//
//  HSJudgefunction.swift
//  huiSenSmart
//
//  Created by jonker.sun on 2022/2/23.
//

import UIKit

public class HSJudgefunction: NSObject {
    // MARK: - Public
    //验证邮箱
    public static func validateEmail(email: String) -> Bool {
        if email.count == 0 {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    //验证手机号
    public static func isPhoneNumber(phoneNumber:String) -> Bool {
        if phoneNumber.count != 11 {
            return false
        }
        let mobile = "^1([3578][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        }else
        {
            return false
        }
    }
    
    //密码正则  8-16位字母、特殊字符、数字两个组合
    public static func isPasswordRuler(password:String) -> Bool {
        let rule = "^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)(?![@,\\.#%'\\+\\*\\-:;^_`]+$)[@,\\.#%'\\+\\*\\-:;^_`0-9A-Za-z]{8,16}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",rule)
        return regexPassword.evaluate(with: password)
    }
    
    // 数字
    public static func isnumber(input:String) -> Bool {
        let rule = "^^[0-9]*$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",rule)
        return regexPassword.evaluate(with: input)
    }
    
    // 表情
    public static func isEmoji(input:String) -> Bool {
        let rule = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",rule)
        return regexPassword.evaluate(with: input)
    }
    
    // 特殊符号
    public  static func isSpecialString(input:String) -> Bool {
        let rule = "~,￥,#,&,*,<,>,《,》,(,),[,],{,},【,】,^,@,/,￡,¤,,|,§,¨,「,」,『,』,￠,￢,￣,（,）,——,+,|,$,_,€,¥,？,/,|,，,。,!,！"
        var tempArray = rule.components(separatedBy: ",")
        tempArray.append(",")
        for i in 0..<input.count {
            if tempArray.contains(input.as[i..<1+i]) {
                return true
            }
        }
        return false
    }
    
    /// 所有输入的规则--数字、字母、汉字,➋➌➍➎➏➐➑➒9宫格汉字输入
    public static func inputRule(input: String) -> Bool {
        if "➋➌➍➎➏➐➑➒".contains(input) {
            return true
        }
        let rule = "^[\\u4e00-\\u9fa5a-zA-Z0-9]+$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",rule)
        return regexPassword.evaluate(with: input)
    }
}
