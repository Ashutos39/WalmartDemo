//
//  WalmartVoidResult.swift
//  WalmartDemoApp
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import Foundation

enum WalmartVoidResult<Failure> where Failure: Error {
    case success
    case failure(Failure)
}
