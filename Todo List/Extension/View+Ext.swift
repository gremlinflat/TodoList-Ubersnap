//
//  View+Ext.swift
//  Todo List
//
//  Created by Fahri Novaldi on 06/08/23.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
//    View().if(:condition:) {
//        :true condition:
//    }, else: {
//        :false condition:
//    }
    
    @ViewBuilder func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        _ whenTrueTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            whenTrueTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
}
