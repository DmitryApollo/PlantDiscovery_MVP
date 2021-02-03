//
//  Resolutions.swift
//  PlantDiscover
//
//  Created by Дмитрий on 03/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

extension UIDevice {
    static var aspectRatio: CGFloat {
        let deviceWidth = UIScreen.main.bounds.width * UIScreen.main.scale
        let deviceHeight = UIScreen.main.bounds.height * UIScreen.main.scale
        return deviceHeight / deviceWidth
    }
    
    static var hasNotch: Bool {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}


extension PlantCollectionViewCell {
    private struct SizeRatio {
        static let fontSizeToBoundsHeight: CGFloat = 0.065
        static let sizeOfImageViewMultiplier: CGFloat = 0.8
    }
    
    var imageViewWidth: CGFloat {
        return bounds.size.width * SizeRatio.sizeOfImageViewMultiplier
    }
    
    var topImageViewOffset: CGFloat {
        return (bounds.size.width - imageViewWidth) / 2
    }
    
    var labelsFontSize: CGFloat {
        return bounds.size.height * SizeRatio.fontSizeToBoundsHeight
    }
}


extension DetailTableViewCell {
    private struct SizeRatio {
        static let fontSizeToBoundsHeight: CGFloat = 0.45
    }
    
    var labelsFontSize: CGFloat {
        return bounds.size.height * SizeRatio.fontSizeToBoundsHeight
    }
}


extension PlantsViewController {
    private struct SizeRatio {
        static let cellWidthMultiplier: CGFloat = 3.43
    }
    
    var cellSize: CGSize {
        let width = view.bounds.width / SizeRatio.cellWidthMultiplier
        return CGSize(width: width,
                      height: width * (UIDevice.current.userInterfaceIdiom == .pad ? 1.38 : 1.60))
    }
}


extension DetailViewController {
    private struct SizeRatio {
        static let imageHeightMultiplier: CGFloat = 0.42
    }
    
    var imageViewHeight: CGFloat {
        return view.bounds.height * SizeRatio.imageHeightMultiplier
    }
}
