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
            let result = subscriber.getAlert()
            logger.debug("About to show: \(result)")
            return result
        }
        .onAppear() {
            subscriber.screenDisplayed = true
        }
        .onDisappear() {
            subscriber.screenDisplayed = false
            
            // I had been getting duplicate error messages. e.g., on sharing account creation by an invitation. This is to avoid this.
            subscriber.alertQueue.removeAll()
        }
    }
}

