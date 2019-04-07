//
//  Result.swift
//  RDFNetworking
//
//  Created by ryan del forte on 5/4/19.
//  Copyright © 2019 ryan del forte. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}
