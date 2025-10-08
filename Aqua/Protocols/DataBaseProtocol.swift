//
//  DataBaseProtocol.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 07/10/25.
//


import Foundation
import SwiftData

protocol DataBaseProtocol {
    func add<T: PersistentModel>(element: T)
    func delete<T: PersistentModel>(element: T)
    func update<T: PersistentModel>(element: T)
    func getAllElements<T: PersistentModel>(fetchDescriptor: FetchDescriptor<T>) -> [T]
}



