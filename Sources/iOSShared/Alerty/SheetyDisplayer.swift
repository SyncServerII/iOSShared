//
//  SheetyDisplayer.swift
//  
//
//  Created by Christopher G Prince on 2/14/21.
//

import Foundation
import SwiftUI

// Because I'm not getting the callbacks for displaying/hiding view when displaying a sheet. And because I want to display errors/alerts on these sheets.

extension View {
    public func sheetyDisplayer<V: View>(show: Binding<Bool>, subscriber: AlertySubscriber, view: V) -> some View {
    
        self.sheet(isPresented: show, onDismiss: {
            subscriber.screenDisplayed = true
        }, content: { ()->(V) in
            subscriber.screenDisplayed = false
            return view
        })
    }
    
    public func sheetyDisplayer<Item, Content>(item: Binding<Item?>, subscriber: AlertySubscriber, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View {
    
        self.sheet(item: item, onDismiss: {
            subscriber.screenDisplayed = true
        }, content: { (item: Item) -> Content in
            subscriber.screenDisplayed = false
            return content(item)
        })
    }
}
