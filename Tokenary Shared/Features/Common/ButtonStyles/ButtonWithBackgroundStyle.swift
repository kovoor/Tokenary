// Copyright © 2022 Tokenary. All rights reserved.

import SwiftUI

struct ButtonWithBackgroundStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let isActive: Bool

    init(
        backgroundColor: Color,
        foregroundColor: Color,
        isActive: Bool = true
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.isActive = isActive
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(
                foregroundColor.opacity(configuration.isPressed ? 0.75 : 1)
            )
            .padding([.leading, .trailing], 50)
            .padding([.top, .bottom], 15)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        backgroundColor
                            .opacity(isActive && !configuration.isPressed ? 1 : 0.75)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
    }
}

struct Buttons_Previews: PreviewProvider {
    private static let adaptiveWhite: Color = Color(
        light: Color(white: 0.2), dark: Color(white: 0.8)
    )
    private static let adaptiveBlack: Color = Color(
        light: Color(white: 0.8), dark: Color(white: 0.2)
    )
    
    static var previews: some View {
        let view = NavigationView {
            VStack {
                Section(header: Text("Active")) {
                    Button("Button") {}
                    NavigationLink("Navigation link", destination: EmptyView())
                }
                .buttonStyle(ButtonWithBackgroundStyle(
                    backgroundColor: adaptiveWhite, foregroundColor: adaptiveBlack
                ))

                Section(header: Text("In-active")) {
                    Button("Button") {}
                    NavigationLink("Navigation link", destination: EmptyView())
                }
                .buttonStyle(ButtonWithBackgroundStyle(
                    backgroundColor: adaptiveWhite, foregroundColor: adaptiveBlack, isActive: false
                ))
            }
        }

        return Group {
            view
                .environment(\.colorScheme, .light)
            view
                .environment(\.colorScheme, .dark)
        }
    }
}
