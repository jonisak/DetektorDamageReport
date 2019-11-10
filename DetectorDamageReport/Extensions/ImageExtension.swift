//
//  ImageExtension.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-10-17.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
extension UIImage {
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }

    func resize(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height

        switch contentMode {
        case .contentFill:
            return resize(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }

    private func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
        
        
        func superCompress(_ image:UIImage, maxHeight:CGFloat, maxWidth:CGFloat)-> Data {
                
                var actualHeight : CGFloat = image.size.height
                var actualWidth : CGFloat = image.size.width
                var imgRatio : CGFloat = actualWidth/actualHeight
                let maxRatio : CGFloat = maxWidth/maxHeight
                var compressionQuality : CGFloat = 0.5
                
                if (actualHeight > maxHeight || actualWidth > maxWidth){
                    if(imgRatio < maxRatio){
                        //adjust width according to maxHeight
                        imgRatio = maxHeight / actualHeight;
                        actualWidth = imgRatio * actualWidth;
                        actualHeight = maxHeight;
                    }
                    else if(imgRatio > maxRatio){
                        //adjust height according to maxWidth
                        imgRatio = maxWidth / actualWidth;
                        actualHeight = imgRatio * actualHeight;
                        actualWidth = maxWidth;
                    }
                    else{
                        actualHeight = maxHeight;
                        actualWidth = maxWidth;
                        compressionQuality = 1;
                    }
                }
                
                let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight);
                UIGraphicsBeginImageContext(rect.size);
                image.draw(in: rect)
                let img = UIGraphicsGetImageFromCurrentImageContext();
            let imageData = img!.jpegData(compressionQuality: compressionQuality);
                UIGraphicsEndImageContext();
                return imageData!;
                //return UIImage(data:imageData!,scale:1.0)!
            }

        
        
        
        
        func scaleImage(toSize newSize: CGSize) -> UIImage? {
            let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            if let context = UIGraphicsGetCurrentContext() {
                context.interpolationQuality = .high
                let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
                context.concatenate(flipVertical)
                context.draw(self.cgImage!, in: newRect)
                let newImage = UIImage(cgImage: context.makeImage()!)
                UIGraphicsEndImageContext()
                return newImage
            }
            return nil
        }
        
            func maskWithColor(color: UIColor) -> UIImage? {
                let maskImage = cgImage!
                
                let width = size.width
                let height = size.height
                let bounds = CGRect(x: 0, y: 0, width: width, height: height)
                
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
                let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
                
                context.clip(to: bounds, mask: maskImage)
                context.setFillColor(color.cgColor)
                context.fill(bounds)
                
                if let cgImage = context.makeImage() {
                    let coloredImage = UIImage(cgImage: cgImage)
                    return coloredImage
                } else {
                    return nil
                }
            }
     
        
      
        
        func fixOrientation(_image:UIImage) -> UIImage {
            
            if (_image.imageOrientation == UIImage.Orientation.up) {
                return _image;
            }
            
            UIGraphicsBeginImageContextWithOptions(_image.size, false, _image.scale);
            let rect = CGRect(x: 0, y: 0, width: _image.size.width, height: _image.size.height)
            _image.draw(in: rect)
            
            let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext();
            return normalizedImage;
        }
 
}
