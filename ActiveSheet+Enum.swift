//
//  ActiveSheet+Enum.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 15.02.2023.
//

import Foundation

enum ActiveSheet: Int, Identifiable {
    case newAccount
    case settings
    case statistics
    case transaction
    
    var id: Int { self.rawValue }
}
