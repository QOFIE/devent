//
//  ImageCropper.swift
//  iSquare
//
//  Created by Can Ceran on 28/10/15.
//  Copyright © 2015 Ceran. All rights reserved.
//

import UIKit

func squareImage (image: UIImage) -> UIImage {
    
    let originalWidth  = image.size.width
    print("Original Width: \(originalWidth)")
    let originalHeight = image.size.height
    print("Original Height: \(originalHeight)")
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var edge: CGFloat = 0.0
    
    if (originalWidth > originalHeight) {
        // landscape
        edge = originalHeight
        x = (originalWidth - edge) / 2.0
        y = 0.0
        
    } else if (originalHeight > originalWidth) {
        // portrait
        edge = originalWidth
        x = 0.0
        y = (originalHeight - originalWidth) / 2.0
    } else {
        // square
        edge = originalWidth
    }
    let cropSquare = CGRectMake(x, y, edge, edge)
    print("x = \(x), y = \(y), edge = \(edge) ")
    
    let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
    
    let squaredImage = UIImage(CGImage: imageRef!)
    
    return squaredImage
}

//Resize Image using UIKit (this might lead to quality loss)
private func resizeImage (image: UIImage, targetSize: CGSize) -> UIImage {
    
    let size = image.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRectMake(0, 0, newSize.width, newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.drawInRect(rect)
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage
}

//Use the function below instead if you want to resize using UIKit instead
func squareImage (image: UIImage, toSize: CGSize) -> UIImage {
    let squaredImage = squareImage(image)
    return resizeImage(squaredImage, targetSize: toSize)
}
