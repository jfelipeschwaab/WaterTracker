//
//  DatabaseManager.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 07/10/25.
//
import Foundation
import SwiftData


final class DatabaseManager : DataBaseProtocol {
    
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func add<T: PersistentModel>(element: T) {
        context.insert(element)
        saveContext()
    }
    
    func delete<T: PersistentModel>(element: T) {
        context.delete(element)
        saveContext()
    }
    
    func update<T: PersistentModel>(element: T) {
        saveContext()
    }
    
    func getAllElements<T: PersistentModel>(fetchDescriptor: FetchDescriptor<T>) -> [T] {
        do {
            let elements = try context.fetch(fetchDescriptor)
            return elements
        } catch {
            print("Erro ao buscar elementos no banco de dados: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Erro crítico ao salvar contexto do banco de dados: \(error)")
        }
    }
    
}
