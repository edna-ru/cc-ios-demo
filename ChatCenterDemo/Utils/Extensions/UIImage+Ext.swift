//
// UIImage+Ext.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

extension UIImage {
    class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        let frameCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []

        for image in 0 ..< frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, image, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }

        return UIImage.animatedImage(with: images, duration: 0.0)
    }
}
