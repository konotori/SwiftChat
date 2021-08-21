//
//  Extentions.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 21/08/2021.
//

import UIKit

extension UIImage {
    var isPortrait: Bool { return size.height > size.width }
    var isLandScape: Bool { return size.width > size.height }
    var breadth: CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize{ return  CGSize(width: breadth, height: breadth)}
    var breadthReact: CGRect {return CGRect(origin: .zero, size: breadthSize)}
    
    var circleMasked: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandScape ? floor((size.width - size.height) / 2) : 0, y: isPortrait ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        
        UIBezierPath(ovalIn: breadthReact).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthReact)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }

}
