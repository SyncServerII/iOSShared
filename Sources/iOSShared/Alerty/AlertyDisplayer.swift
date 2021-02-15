//
//  AlertyDisplayer.swift
//  
//
//  Created by Christopher G Prince on 2/14/21.
//

import Foundation
import SwiftUI

extension View {
    public func alertyDisplayer(show: Binding<Bool>, subscriber: AlertySubscriber) -> some View {
        self
        .alert(isPresented: show) {
            logger.debug("alertyDisplayer: Showing: \(String(describing: subscriber.debugMessage))")
            return subscriber.getAlert()
        }
        .onAppear() {
            logger.debug("onAppear: \(String(describing: subscriber.debugMessage))")
            subscriber.screenDisplayed = true
        }
        .onDisappear() {
            logger.debug("onDisappear: \(String(describing: subscriber.debugMessage))")
            subscriber.screenDisplayed = false
            
            // I had been getting duplicate error messages. e.g., on sharing account creation by an invitation. This is to avoid this.
            subscriber.alert = nil
        }
    }
}

