//
//  SCScrollView.swift
//  MMSegmentControl
//
//  Created by Mohsinali Matiya on 05/25/2017.
//  Copyright (c) 2017 Mohsinali Matiya. All rights reserved.
//

import UIKit

/// Scroll view (part of the bundled MMSegmentControl) that forwards touches to
/// the next responder unless it is actively dragging — lets taps pass through to
/// underlying controls while still supporting scroll gestures.
internal class SCScrollView: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragging {
            next?.touchesBegan(touches, with: event)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragging {
            next?.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragging {
            next?.touchesEnded(touches, with: event)
        } else {
            super.touchesEnded(touches, with: event)
        }
    }
}

internal extension SCScrollView {
    internal var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
