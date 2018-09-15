//
//  Style.swift
//  MMSegmentControl
//
//  Created by Mohsinali Matiya on 05/25/2017.
//  Copyright (c) 2017 Mohsinali Matiya. All rights reserved.
//

import Foundation

// Style enums for the bundled MMSegmentControl: how segments are laid out
// (fixed vs. dynamic width), whether they render text or images, and where/if
// the selection indicator and box are drawn.

public enum MMSegmentedControlLayoutPolicy {
    case fixed
    case dynamic
}

public enum MMSegmentedControlStyle {
    case text
    case image
}

public enum MMSegmentedControlSelectionIndicatorStyle {
    case none
    case top
    case bottom
}

public enum MMSegmentedControlSelectionBoxStyle {
    case none
    case `default`
}
