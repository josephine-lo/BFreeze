//
//  BFLayoutInfo.swift
//  BFreeze
//
//  Created by jlo on 10/30/24.
//

import Foundation

struct BFLayoutInfo {
    let screenSize: CGSize
//    let boxSize: CGSize = .init(width: 100, height: 100)
    var conveyorSize: CGSize {
        return CGSize(width: 125, height: screenSize.height * 1000)
    }
}
