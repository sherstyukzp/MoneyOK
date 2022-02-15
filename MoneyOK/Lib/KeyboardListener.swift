//
//  KeyboardListener.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 25.01.2022.
//

import Combine
import SwiftUI

private class KeyboardListener: ObservableObject {
    @Published var keyabordIsShowing: Bool = false
    var cancellable = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self ] _ in
                self?.keyabordIsShowing = true
            }
            .store(in: &cancellable)
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self ] _ in
                self?.keyabordIsShowing = false
            }
            .store(in: &cancellable)
    }
}

private struct DismissingKeyboard: ViewModifier {
    @ObservedObject var keyboardListener = KeyboardListener()
    
    fileprivate func body(content: Content) -> some View {
        ZStack {
            content
            Rectangle()
                .background(Color.clear)
                .opacity(keyboardListener.keyabordIsShowing ? 0.01 : 0)
                //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .onTapGesture {
                    let keyWindow = UIApplication.shared.connectedScenes
                        .filter({ $0.activationState == .foregroundActive })
                        .map({ $0 as? UIWindowScene })
                        .compactMap({ $0 })
                        .first?.windows
                        .filter({ $0.isKeyWindow }).first
                    keyWindow?.endEditing(true)
                }
        }
    }
}

extension View {
    func dismissingKeyboard() -> some View {
        ModifiedContent(content: self, modifier: DismissingKeyboard())
    }
}


