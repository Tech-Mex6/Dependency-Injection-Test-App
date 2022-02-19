//
//  ErrorMessage.swift
//  Dependency Injection App
//
//  Created by meekam okeke on 2/18/22.
//

import Foundation

enum DIError: String, Error {
case unableToComplete   = "Unable to complete your request. Please check your internet connection."
case invalidResponse    = "Invalid response from the server. Please try again."
case invalidData        = "The data received from the server is invalid. Please try again."
}
