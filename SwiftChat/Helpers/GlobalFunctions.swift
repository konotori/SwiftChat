//
//  GlobalFunctions.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 21/08/2021.
//

import Foundation

func fileNameFrom(fileUrl: String) -> String {
//    if let name = ((fileUrl.components(separatedBy: "_").last)?.components(separatedBy: "?").first)?.components(separatedBy: ".").first! {
//        return name
//    }
    
    if let token = fileUrl.components(separatedBy: "-").last {
        return token
    }
    
    return ""
}
