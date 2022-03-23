//
//  AppState.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class AppState: ObservableObject {
    var objectWillChange = PassthroughSubject<AppState, Never>()
    
    var moviesState: MoviesState
    
    init(moviesState: MoviesState = MoviesState()) {
        self.moviesState = moviesState
    }
    
    func dispatch(action: Action) {
        moviesState = MoviesStateReducer().reduce(state: moviesState, action: action)
        DispatchQueue.main.async {
            self.objectWillChange.send(self)
        }
    }
}

let store = AppState()
