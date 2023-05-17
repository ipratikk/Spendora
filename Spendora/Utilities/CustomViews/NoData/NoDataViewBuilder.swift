//
//  NoDataViewBuilder.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 24/04/23.
//

import Foundation
import UIKit

public final class NoDataViewBuilder {
    public static func build( image: UIImage?, title: String ) -> UIView {
        let view = NoDataView.loadFromNib()
        view.setup(image: image, title: title)
        return view
    }
}
