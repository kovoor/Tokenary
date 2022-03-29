// Copyright © 2022 Tokenary. All rights reserved.

import SwiftUI

/// Adds ability to react to touch gesture, on a whole object not only for Control-based objects(like `Button`), but for any object
///  Also adds ability to chain gestures
private struct TouchGestureViewModifier: ViewModifier {
    /// `(isInside, hasEnded)`
    let touchChanged: (Bool, Bool) -> Void
    let useHighPriorityGesture: Bool
    let longPressDuration: CGFloat
    let longPressActionClosure: (() -> Void)?
    
    private let viewId = UUID()

    @State
    private var contentBounds: CGRect = .zero

    func body(content: Content) -> some View {
        func checkBoundaries(for value: DragGesture.Value, isEndGesture: Bool) {
            if value.location.x < .zero ||
                value.location.y < .zero ||
                value.location.x > contentBounds.size.width ||
                value.location.y > contentBounds.size.height {
                touchChanged(false, isEndGesture)
            } else {
                touchChanged(true, isEndGesture)
            }
        }
        let dragGesture = DragGesture(minimumDistance: .zero, coordinateSpace: .local)
            .onChanged { checkBoundaries(for: $0, isEndGesture: false) }
            .onEnded { checkBoundaries(for: $0, isEndGesture: true) }
        let longPressGesture = LongPressGesture(minimumDuration: longPressDuration)
            .onEnded { _ in
                longPressActionClosure?()
            }

        let viewWithSavedBounds = content
            .saveBounds(viewId: viewId, coordinateSpace: .local)
            .retrieveBounds(viewId: viewId, $contentBounds)
        
        if useHighPriorityGesture {
            return AnyView(
                viewWithSavedBounds
                    .highPriorityGesture(dragGesture)
                    .simultaneousGesture(longPressGesture)
            )
        } else {
            return AnyView(
                viewWithSavedBounds
                    .gesture(dragGesture)
                    .simultaneousGesture(longPressGesture)
            )
        }
    }
}

extension View {
    func onTouchGesture(
        touchChanged: @escaping (Bool, Bool) -> Void,
        useHighPriorityGesture: Bool = false,
        longPressDuration: CGFloat = 2,
        longPressActionClosure: (() -> Void)? = nil
    ) -> some View {
        modifier(TouchGestureViewModifier(
            touchChanged: touchChanged,
            useHighPriorityGesture: useHighPriorityGesture,
            longPressDuration: longPressDuration,
            longPressActionClosure: longPressActionClosure
        ))
    }
}
