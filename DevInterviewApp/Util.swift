//
//  Util.swift
//  DevInterviewApp
//
//  Created by Vincent Zhou on 9/15/22.
//

import Foundation
import SwiftUI

extension View {
    func fullscreenBackground<Content: View>(_ content: Content) -> some View {
        ZStack {
            content.ignoresSafeArea()

            self
        }
    }
    
    func fullscreenBackground<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            content().ignoresSafeArea()

            self
        }
    }
}
