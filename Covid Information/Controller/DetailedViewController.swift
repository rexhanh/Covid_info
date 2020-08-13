//
//  DetailedViewController.swift
//  Covid Information
//
//  Created by Yuanrong Han on 7/30/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import UIKit
import Charts

class DetailedViewController: UIViewController {
    let stateData : StateData!
    let stateDictionary = ["AL": "Alabama", "AK": "Alaska", "AS": "American Samoa", "AZ": "Arizona", "AR": "Arkansas", "CA": "California", "CO": "Colorado", "CT": "Connecticut", "DE": "Delaware", "DC": "District of Columbia", "FL": "Florida", "GA": "Georgia", "GU": "Guam", "HI": "Hawaii", "ID": "Idaho", "IL": "Illinois", "IN": "Indiana", "IA": "Iowa", "KS": "Kansas", "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland", "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi", "MO": "Missouri", "MT": "Montana", "NE": "Nebraska", "NV": "Nevada", "NH": "New Hampshire", "NJ": "New Jersey", "NM": "New Mexico", "NY": "New York", "NC": "North Carolina", "ND": "North Dakota", "MP": "Northern Mariana Islands", "OH": "Ohio", "OK": "Oklahoma", "OR": "Oregon", "PA": "Pennsylvania", "PR": "Puerto Rico", "RI": "Rhode Island", "SC": "South Carolina", "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas", "UT": "Utah", "VT": "Vermont", "VI": "Virgin Islands", "VA": "Virginia", "WA": "Washington", "WV": "West Virginia", "WI": "Wisconsin", "WY": "Wyoming"]
    var url : URL!
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
       }()

    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stateview : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return view
    }()
    
    let statechartview : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: 700).isActive = true
        return view
    }()
    
    let statecases : UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Arial", size: 20)!
        l.textColor = .label
        l.textAlignment = .center
        return l
    }()
    
    let statedeath : UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Arial", size: 20)!
        l.textColor = .label
        l.textAlignment = .center
        return l
    }()
    
    let staterecovered : UILabel = {
        let l = UILabel()
        l.font = UIFont(name: "Arial", size: 20)!
        l.textColor = .label
        l.textAlignment = .center
        return l
    }()
    
    let statecasehistorylinechart : LineChartView = {
        let view = LineChartView()
//        view.backgroundColor = .clear
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.animate(xAxisDuration: 1, yAxisDuration: 1)
        view.dragEnabled = true
        view.setScaleEnabled(true)
        view.pinchZoomEnabled = true
        view.legend.enabled = true
        view.doubleTapToZoomEnabled = true
        view.data?.highlightEnabled = true
        
        let xaxis = view.xAxis
        xaxis.granularity = 1
        xaxis.labelPosition = .bottom
        xaxis.labelRotationAngle = 45
        xaxis.labelTextColor = .label
        xaxis.drawGridLinesEnabled = false
        xaxis.valueFormatter = ChartFormatter()
        
        let yaxis = view.leftAxis
        yaxis.enabled = true
        yaxis.labelTextColor = .label
        yaxis.labelTextColor = .systemRed
        yaxis.axisMinimum = 0
        
        let rightaxis = view.rightAxis
        rightaxis.enabled = true
        rightaxis.axisMinimum = 0
        rightaxis.drawGridLinesEnabled = false
        rightaxis.labelTextColor = .systemOrange
        
        let l = view.legend
        l.textColor = .label
        
        
        return view
    }()
    
    
    let statedeathhistorylinechart : LineChartView = {
        let view = LineChartView()
//        view.backgroundColor = .clear
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.animate(xAxisDuration: 1, yAxisDuration: 1)
        view.dragEnabled = true
        view.setScaleEnabled(true)
        view.pinchZoomEnabled = true
        view.legend.enabled = true
        view.doubleTapToZoomEnabled = true
        
        let xaxis = view.xAxis
        xaxis.granularity = 1
        xaxis.labelPosition = .bottom
        xaxis.labelRotationAngle = 45
        xaxis.labelTextColor = .label
        xaxis.drawGridLinesEnabled = false
        xaxis.valueFormatter = ChartFormatter()
        
        let yaxis = view.leftAxis
        yaxis.enabled = true
        yaxis.labelTextColor = .label
        yaxis.labelTextColor = .linechartRed
        yaxis.axisMinimum = 0
        
        let rightaxis = view.rightAxis
        rightaxis.enabled = true
        rightaxis.drawGridLinesEnabled = false
        rightaxis.labelTextColor = .linechartDarkBlue
        rightaxis.axisMinimum = 0
        
        let l = view.legend
        l.textColor = .label
        
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("State: \(stateDictionary[self.stateData.state.name]!)")
        setupscrollview()
        setupstateview()
        setupstatechartview()
        stateData.getStateHistoricalData {
            DispatchQueue.main.async {
                self.statecasehistorylinechart.data = self.stateData.toCovidCaseLineData()
                self.statedeathhistorylinechart.data = self.stateData.toCovidDeathLineData()
            }
        }
        self.title = NSLocalizedString(self.stateData.state.name, comment: "State name")
    }
    
    init(ofstate state: StateData) {
        self.stateData = state
        super.init(nibName: nil, bundle: nil)
    }

    
    private func setupscrollview() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(stateview)
        scrollViewContainer.addArrangedSubview(statechartview)
        
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func setupstateview() {
        let statestackview: UIStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.distribution = .fillEqually
            view.spacing = 5
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let firstcol : UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.spacing = 5
            view.distribution = .fill
            let casedescription : UILabel = {
                let label = UILabel()
                label.text = NSLocalizedString("Case", comment: "Case title")
                label.font = UIFont(name: "Arial", size: 17)!
                label.textAlignment = .center
                label.textColor = .systemRed
                return label
            }()
            view.addArrangedSubview(casedescription)
            view.addArrangedSubview(self.statecases)
            return view
        }()
        
        let thirdcol : UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.spacing = 5
            view.distribution = .fill
            let recovereddescription : UILabel = {
                let label = UILabel()
                label.text = NSLocalizedString("Recovered", comment: "Recovered title")
                label.font = UIFont(name: "Arial", size: 17)!
                label.textAlignment = .center
                label.textColor = .systemGreen
                return label
            }()
            view.addArrangedSubview(recovereddescription)
            view.addArrangedSubview(self.staterecovered)
            return view
        }()
        
        let secondcol: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.spacing = 5
            view.distribution = .fill
            let deathdescription : UILabel = {
                let label = UILabel()
                label.text = NSLocalizedString("Deaths", comment: "Deaths title")
                label.font = UIFont(name: "Arial", size: 17)!
                label.textAlignment = .center
                label.textColor = .systemGray
                return label
            }()
            view.addArrangedSubview(deathdescription)
            view.addArrangedSubview(self.statedeath)
            return view
        }()
        
        self.statecases.text = self.stateData.state.cases.formattedWithSeparator
        self.statedeath.text = self.stateData.state.deaths.formattedWithSeparator
        self.staterecovered.text = self.stateData.state.recovered == 0 ? NSLocalizedString("N/A", comment: "N/A label text") : self.stateData.state.recovered.formattedWithSeparator
        
        statestackview.addArrangedSubview(firstcol)
        statestackview.addArrangedSubview(secondcol)
        statestackview.addArrangedSubview(thirdcol)
        self.stateview.addSubview(statestackview)
        
        statestackview.topAnchor.constraint(equalTo: stateview.topAnchor, constant: 0).isActive = true
        statestackview.leadingAnchor.constraint(equalTo: stateview.leadingAnchor, constant: 0).isActive = true
        statestackview.trailingAnchor.constraint(equalTo: stateview.trailingAnchor, constant: 0).isActive = true
        statestackview.bottomAnchor.constraint(equalTo: stateview.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupstatechartview() {
        let casetitle : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = NSLocalizedString("Case", comment: "Case title")
            label.textColor = .label
            label.font = UIFont(name: "Arial", size: 25)!
            label.textAlignment = .center
            return label
        }()
        
        let resetzoombutton : UIButton = {
            let button = UIButton(type: .system)
            button.setTitle(NSLocalizedString("Reset Zoom", comment: "Reset Zoom button text"), for: .normal)
            button.addTarget(self, action: #selector(handleresetzoom), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = .white
            button.titleLabel?.font = UIFont(name: "Arial", size: 15)!
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 5
            button.tag = 0
            return button
        }()
        
        let deathtitle : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = NSLocalizedString("Deaths", comment: "Deaths title")
            label.textColor = .label
            label.font = UIFont(name: "Arial", size: 25)!
            label.textAlignment = .center
            return label
        }()
        
        let resetzoombutton0 : UIButton = {
            let button = UIButton(type: .system)
            button.setTitle(NSLocalizedString("Reset Zoom", comment: "Reset Zoom button text"), for: .normal)
            button.addTarget(self, action: #selector(handleresetzoom), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = .white
            button.titleLabel?.font = UIFont(name: "Arial", size: 15)!
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 5
            button.tag = 1
            return button
        }()
        
        statechartview.addSubview(casetitle)
        statechartview.addSubview(self.statecasehistorylinechart)
        statechartview.addSubview(deathtitle)
        statechartview.addSubview(self.statedeathhistorylinechart)
        statechartview.addSubview(resetzoombutton)
        statechartview.addSubview(resetzoombutton0)
        
        casetitle.topAnchor.constraint(equalTo: statechartview.topAnchor, constant: 10).isActive = true
        casetitle.leadingAnchor.constraint(equalTo: statechartview.leadingAnchor, constant: 0).isActive = true
        casetitle.trailingAnchor.constraint(equalTo: statechartview.trailingAnchor, constant: 0).isActive = true
        casetitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        resetzoombutton.trailingAnchor.constraint(equalTo: statechartview.trailingAnchor, constant: 0).isActive = true
        resetzoombutton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resetzoombutton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        resetzoombutton.centerYAnchor.constraint(equalTo: casetitle.centerYAnchor).isActive = true
        
        self.statecasehistorylinechart.topAnchor.constraint(equalTo: resetzoombutton.bottomAnchor, constant: 10).isActive = true
        self.statecasehistorylinechart.leadingAnchor.constraint(equalTo: statechartview.leadingAnchor, constant: 0).isActive = true
        self.statecasehistorylinechart.trailingAnchor.constraint(equalTo: statechartview.trailingAnchor, constant: 0).isActive = true
        self.statecasehistorylinechart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        deathtitle.topAnchor.constraint(equalTo: self.statecasehistorylinechart.bottomAnchor, constant: 10).isActive = true
        deathtitle.leadingAnchor.constraint(equalTo: statechartview.leadingAnchor, constant: 0).isActive = true
        deathtitle.trailingAnchor.constraint(equalTo: statechartview.trailingAnchor, constant: 0).isActive = true
        deathtitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        resetzoombutton0.trailingAnchor.constraint(equalTo: statechartview.trailingAnchor, constant: 0).isActive = true
        resetzoombutton0.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resetzoombutton0.widthAnchor.constraint(equalToConstant: 100).isActive = true
        resetzoombutton0.centerYAnchor.constraint(equalTo: deathtitle.centerYAnchor).isActive = true
        
        self.statedeathhistorylinechart.topAnchor.constraint(equalTo: resetzoombutton0.bottomAnchor, constant: 10).isActive = true
        self.statedeathhistorylinechart.leadingAnchor.constraint(equalTo: statechartview.leadingAnchor, constant: 0).isActive = true
        self.statedeathhistorylinechart.trailingAnchor.constraint(equalTo: statechartview.trailingAnchor, constant: 0).isActive = true
        self.statedeathhistorylinechart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
    }
    
    // MARK: Handles reset zoom for Charts
    @objc func handleresetzoom(sender: UIButton) {
        switch sender.tag {
        case 0:
            self.statecasehistorylinechart.zoomToCenter(scaleX: 0, scaleY: 0)
        case 1:
            self.statedeathhistorylinechart.zoomToCenter(scaleX: 0, scaleY: 0)
        default:
            return
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
