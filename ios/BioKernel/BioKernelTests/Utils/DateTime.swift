//
//  DateTime.swift
//  BioKernelTests
//
//

import Foundation

@testable import BioKernel

extension Date {
    static func f(_ input: String) -> Date {
        return ClockDateTime().parse(input, formatter: .humanReadable)!
    }
}
