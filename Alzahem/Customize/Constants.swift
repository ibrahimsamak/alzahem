//
//  Constants.swift
//  MMSegmentControl
//
//  Created by Mohsinali Matiya on 05/25/2017.
//  Copyright (c) 2017 Mohsinali Matiya. All rights reserved.
//

import UIKit

// MARK: - Layout constants for the custom segmented control (MMSegmentControl).
// These provide default sizing values used when a segment control is created
// without explicit configuration.

/// Defaults for the selection indicator (the moving underline below a segment).
internal struct SelectionIndicator {
    /// Height in points of the selection indicator bar.
    static let defaultHeight: CGFloat = 5
}

/// Defaults for the segments themselves.
internal struct SegmentConstant {
    /// Horizontal padding applied on each side of a segment's title.
    static let defaultSelectionHorizontalPadding: CGFloat = 15
}
