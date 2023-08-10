//
//  Currency+Enum.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 10/08/2023.
//


import Foundation
import SwiftUI

// MARK: - Типы транзакции
enum Currency: String, Equatable, CaseIterable {
    
    case usd = "USD" // доллар
    case eur = "EUR" // євро
    case uah = "UAH" // гривня
    
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
