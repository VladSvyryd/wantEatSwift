//
//  File.swift
//  wantEat
//
//  Created by Vlad Svyryd on 20.11.19.
//  Copyright © 2019 Vladyslav Svyrydonov. All rights reserved.
//

import Foundation
import SwiftUI
   final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published var readyToAppear = false

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        readyToAppear = true
    }

    @objc func keyBoardWillHide(notification: Notification) {
        readyToAppear = false
    }

}
