//
//  ContentView.swift
//  Animations
//
//  Created by Bruce Gilmour on 2021-07-01.
//

import SwiftUI

struct ContentView: View {
    // State for animated gesture examples
    let letters = Array("Hello, SwiftUI!")
    @State private var enabled = false
    @State private var dragging = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        VStack(spacing:10) {
            ShowHideRectangleView()
            AnimatedRectangleView()
            ScalingRectangleView()
            AsymmetricRectangleView()
            PivotRectangleView()
            snakeDrag
        }
    }

    var baseGradient: some View {
        LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
    }

    var snakeDrag: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< letters.count) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(dragging ? Color.green : enabled ? Color.blue : Color.red)
                    .animation(Animation.default.delay(Double(num) / 10))
                    .offset(dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged {
                    dragAmount = $0.translation
                    dragging = true
                }
                .onEnded { _ in
                    dragAmount = .zero
                    dragging = false
                    enabled.toggle()
                }
        )
    }

    var dragGesture1: some View {
        baseGradient
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in dragAmount = .zero }
            )
            .animation(.spring())
    }

    var dragGesture2: some View {
        baseGradient
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            dragAmount = .zero
                        }
                    }
            )
    }
}

struct ShowHideRectangleView: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("Show / hide") {
                isShowingRed.toggle()
            }

            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
            }
        }
    }
}

struct AnimatedRectangleView: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("With animation") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
            }
        }
    }
}

struct ScalingRectangleView: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("Scaling transition") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .transition(.scale)
            }
        }
    }
}

struct AsymmetricRectangleView: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("Asymmetric transition") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .transition(.asymmetric(insertion: .pivot, removal: .opacity))
            }
        }
    }
}

struct PivotRectangleView: View {
    @State private var isShowingRed = false

    var body: some View {
        VStack {
            Button("Custom pivot transition") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }

            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                    .transition(.pivot)
            }
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
