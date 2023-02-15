//
//  TypeTransaction+Enum.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2023.
//

import Foundation

// MARK: - Типы транзакции
enum TypeTransaction: String, CaseIterable {
    
    case costs = "Expense"
    case income = "Income"
    //case transfer = "Translation"
}
