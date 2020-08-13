//
//  CountryTableViewCell.swift
//  Covid Information
//
//  Created by Yuanrong Han on 8/3/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    let statenamelabel : UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Arial", size: 15)!
        l.textColor = .label
        l.numberOfLines = 0
        return l
    }()
    
    let statecaselabel : UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Arial", size: 15)!.bold()
        l.textColor = .label
        return l
    }()
    
    let statedeathlabel : UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Arial", size: 15)!.bold()
        l.textColor = .label
        return l
    }()
    
    let staterecoverlabel : UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Arial", size: 15)!.bold()
        l.textColor = .label
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupcell()
    }
    
    private func setupcell() {
        let stackview : UIStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.translatesAutoresizingMaskIntoConstraints = false
            view.spacing = 5
            view.distribution = .fillEqually
            return view
        }()
        self.addSubview(stackview)
        stackview.addArrangedSubview(self.statenamelabel)
        stackview.addArrangedSubview(self.statecaselabel)
        stackview.addArrangedSubview(self.statedeathlabel)
        stackview.addArrangedSubview(self.staterecoverlabel)
        
        stackview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5).isActive = true
        stackview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        stackview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
