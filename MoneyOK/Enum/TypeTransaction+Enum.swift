//
//  TypeTransaction+Enum.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2023.
//

import Foundation
import SwiftUI

// MARK: - Типы транзакции
enum TypeTrancaction: String, Equatable, CaseIterable {
    
    case expenses = "Expense"
    case income = "Income"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
