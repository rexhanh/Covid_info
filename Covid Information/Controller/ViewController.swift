//
//  ViewController.swift
//  Covid Information
//
//  Created by Yuanrong Han on 7/30/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ChartViewDelegate {
    let data = coronaData()
    var stateNameSortAscending = true
    var caseNumberDecending = false
    var deathNumberDecending = false
    var recoverNumberDecending = false
    let casetitletext = NSLocalizedString("Case", comment: "Case title")
    let deathtitletext = NSLocalizedString("Deaths", comment: "Deaths title")
    let recoveredtitletext = NSLocalizedString("Recovered", comment: "Recovered title")
    let reset = NSLocalizedString("Reset Zoom", comment: "Reset Zoom title")
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
    
    let worldview: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 350).isActive = true
        view.backgroundColor = .clear
        return view
    }()

    let countryview: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1500).isActive = true
        view.backgroundColor = .clear
        return view
    }()
    
    let placedescription : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("World", comment: "World title")
        label.font = UIFont(name: "Arial", size: 30)!
        return label
    }()
    
    let updatelabel : UILabel = {
        let label = UILabel()
        label.text = "Updated on 07/30/20"
        label.font = UIFont(name: "Arial", size: 13)!
        return label
    }()
    
    
    let casedescription : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Case", comment: "Case title")
        label.font = UIFont(name: "Arial", size: 17)!
        return label
    }()
    
    let worldcase : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .systemRed
        label.font = UIFont(name: "Arial", size: 30)!
        return label
    }()
    
    let deathdescription : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Deaths", comment: "Deaths title")
        label.font = UIFont(name: "Arial", size: 17)!
        return label
    }()
    
    let worlddeath : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Arial", size: 30)!
        label.textColor = .systemGray
        return label
    }()
    
    let worldrecovereddescription : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Recovered", comment: "Recovered title")
        label.font = UIFont(name: "Arial", size: 17)!
        return label
    }()
    
    let worldrecovered : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont(name: "Arial", size: 30)!
        label.textColor = .systemGreen
        return label
    }()
    
    let worldnewcase : UILabel = {
        let label = UILabel()
        label.text = "+ 0"
        label.font = UIFont(name: "Arial", size: 12)!
        label.textColor = .systemRed
        return label
    }()
    let worldnewrecovered : UILabel = {
        let label = UILabel()
        label.text = "+ 0"
        label.font = UIFont(name: "Arial", size: 12)!
        label.textColor = .systemGreen
        return label
    }()
    
    let worldnewdeaths : UILabel = {
        let label = UILabel()
        label.text = "+ 0"
        label.font = UIFont(name: "Arial", size: 12)!
        label.textColor = .systemGray
        return label
    }()
    
    let usnewcase : UILabel = {
        let label = UILabel()
        label.text = "+ 0"
        label.font = UIFont(name: "Arial", size: 12)!
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    let usnewrecovered : UILabel = {
        let label = UILabel()
        label.text = "+ 0"
        label.font = UIFont(name: "Arial", size: 12)!
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()
    
    let usnewdeaths : UILabel = {
        let label = UILabel()
        label.text = "+ 0"
        label.font = UIFont(name: "Arial", size: 12)!
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    let worldPieChart : PieChartView = {
        let view = PieChartView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.legend.enabled = false
        view.usePercentValuesEnabled = true
        view.drawHoleEnabled = false
        view.rotationEnabled = false
        view.animate(xAxisDuration: 1.5)
        
        return view
    }()
    
    let countrylabel : UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("United States", comment: "State name")
        label.font = UIFont(name: "Arial", size: 30)!
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countryPieChart : PieChartView = {
        let view = PieChartView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.legend.enabled = false
        view.usePercentValuesEnabled = true
        view.holeColor = .systemBackground
        view.rotationEnabled = false
        view.animate(xAxisDuration: 1.5)
        return view
    }()
    
    let uscasehistorylinechart : LineChartView = {
        let view = LineChartView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.animate(xAxisDuration: 1.5)
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
        rightaxis.axisMaximum = 85000
        rightaxis.drawGridLinesEnabled = false
        rightaxis.labelTextColor = .systemOrange
        
        let l = view.legend
        l.textColor = .label
        
        
        return view
    }()
    
    
    let usdeathhistorylinechart : LineChartView = {
        let view = LineChartView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.animate(xAxisDuration: 1.5)
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
    
    let countrycase : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .systemRed
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 25)!
        return label
    }()
    let countryrecovered : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 25)!
        return label
    }()
    let countrydeath : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 25)!
        return label
    }()
    let usstatetableview : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Setups
        setupData()
        self.countryPieChart.delegate = self
        setupscrollview()
        setupworldcaseview()
        setupcountrycaseview()
        setuprefreshcontrol()
        self.title = NSLocalizedString("Summary", comment: "Title")
    }
    
    private func setupData() {
        data.getTotalWorldData {
            DispatchQueue.main.async {
                self.refreshworlddata(withdata: self.data)
            }
        }
        data.getTopCountriesData {
            DispatchQueue.main.async {
                self.worldPieChart.data = self.data.toPieChartData(isforworld: true)
            }
        }
        data.getUSTotalData {
            DispatchQueue.main.async {
                self.refreshusdata(withdata: self.data)
            }
        }
        data.getTopStatesData {
            DispatchQueue.main.async {
                self.countryPieChart.data = self.data.toPieChartData(isforworld: false)
            }
        }
        data.getUSHistoricalData {
            DispatchQueue.main.async {
                self.uscasehistorylinechart.data = self.data.toCovidCaseLineData()
                self.usdeathhistorylinechart.data = self.data.toCovidDeathLineData()
            }
        }
        data.getAllStatesData {
            DispatchQueue.main.async {
                self.usstatetableview.reloadData()
            }
        }

    }
    
    
    // MARK: Setting up country view
    private func setupcountrycaseview() {
        let countrystackview: UIStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.distribution = .fillProportionally
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
                label.text = casetitletext
                label.font = UIFont(name: "Arial", size: 17)!
                label.textAlignment = .center
                return label
            }()
            view.addArrangedSubview(casedescription)
            view.addArrangedSubview(self.countrycase)
            view.addArrangedSubview(self.usnewcase)
            return view
        }()
        
        let thirdcol: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.spacing = 5
            view.distribution = .fill
            let recovereddescription : UILabel = {
                let label = UILabel()
                label.text = recoveredtitletext
                label.font = UIFont(name: "Arial", size: 17)!
                label.textAlignment = .center
                return label
            }()
            view.addArrangedSubview(recovereddescription)
            view.addArrangedSubview(self.countryrecovered)
            view.addArrangedSubview(self.usnewrecovered)
            return view
        }()
        
        let secondcol : UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.spacing = 5
            view.distribution = .fill
            let deathdescription : UILabel = {
                let label = UILabel()
                label.text = deathtitletext
                label.font = UIFont(name: "Arial", size: 17)!
                label.textAlignment = .center
                return label
            }()
            view.addArrangedSubview(deathdescription)
            view.addArrangedSubview(self.countrydeath)
            view.addArrangedSubview(self.usnewdeaths)
            return view
        }()
        
        let casetitle : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = casetitletext
            label.textColor = .label
            label.font = UIFont(name: "Arial", size: 25)!
            label.textAlignment = .center
            return label
        }()
        
        let resetzoombutton : UIButton = {
            let button = UIButton(type: .system)
            button.setTitle(reset, for: .normal)
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
            label.text = deathtitletext
            label.textColor = .label
            label.font = UIFont(name: "Arial", size: 25)!
            label.textAlignment = .center
            return label
        }()
        
        let resetzoombutton0 : UIButton = {
            let button = UIButton(type: .system)
            button.setTitle(reset, for: .normal)
            button.addTarget(self, action: #selector(handleresetzoom), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = .white
            button.titleLabel?.font = UIFont(name: "Arial", size: 15)!
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 5
            button.tag = 1
            return button
        }()
        
        let statetitle : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = NSLocalizedString("State Tableview title", comment: "State title")
            label.textColor = .label
            label.font = UIFont(name: "Arial", size: 25)!
            label.textAlignment = .center
            return label
        }()
        
        countrystackview.addArrangedSubview(firstcol)
        countrystackview.addArrangedSubview(secondcol)
        countrystackview.addArrangedSubview(thirdcol)
        
        setupstatetableview()
        
        self.countryview.addSubview(countrystackview)
        self.countryview.addSubview(self.countrylabel)
        self.countryview.addSubview(self.countryPieChart)
        self.countryview.addSubview(self.uscasehistorylinechart)
        self.countryview.addSubview(casetitle)
        self.countryview.addSubview(resetzoombutton)
        self.countryview.addSubview(deathtitle)
        self.countryview.addSubview(resetzoombutton0)
        self.countryview.addSubview(self.usdeathhistorylinechart)
        self.countryview.addSubview(statetitle)
        self.countryview.addSubview(self.usstatetableview)

        self.countrylabel.topAnchor.constraint(equalTo: self.countryview.topAnchor, constant: 10).isActive = true
        self.countrylabel.leadingAnchor.constraint(equalTo: countryview.leadingAnchor, constant: 0).isActive = true
        self.countrylabel.trailingAnchor.constraint(equalTo: countryview.trailingAnchor).isActive = true
        self.countrylabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        countrystackview.topAnchor.constraint(equalTo: countrylabel.bottomAnchor, constant: 10).isActive = true
        countrystackview.leadingAnchor.constraint(equalTo: countryview.leadingAnchor).isActive = true
        countrystackview.trailingAnchor.constraint(equalTo: countryview.trailingAnchor).isActive = true
        countrystackview.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        countryPieChart.topAnchor.constraint(equalTo: countrystackview.bottomAnchor, constant: 10).isActive = true
        countryPieChart.leadingAnchor.constraint(equalTo: countryview.leadingAnchor, constant: 0).isActive = true
        countryPieChart.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        countryPieChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        casetitle.topAnchor.constraint(equalTo: countryPieChart.bottomAnchor, constant: 10).isActive = true
        casetitle.leadingAnchor.constraint(equalTo: countryview.leadingAnchor, constant: 0).isActive = true
        casetitle.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        casetitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        resetzoombutton.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        resetzoombutton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resetzoombutton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        resetzoombutton.centerYAnchor.constraint(equalTo: casetitle.centerYAnchor).isActive = true
        
        self.uscasehistorylinechart.topAnchor.constraint(equalTo: resetzoombutton.bottomAnchor, constant: 10).isActive = true
        self.uscasehistorylinechart.leadingAnchor.constraint(equalTo: countryview.leadingAnchor, constant: 0).isActive = true
        self.uscasehistorylinechart.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        self.uscasehistorylinechart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        deathtitle.topAnchor.constraint(equalTo: self.uscasehistorylinechart.bottomAnchor, constant: 10).isActive = true
        deathtitle.leadingAnchor.constraint(equalTo: countryview.leadingAnchor, constant: 0).isActive = true
        deathtitle.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        deathtitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        resetzoombutton0.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        resetzoombutton0.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resetzoombutton0.widthAnchor.constraint(equalToConstant: 100).isActive = true
        resetzoombutton0.centerYAnchor.constraint(equalTo: deathtitle.centerYAnchor).isActive = true
        
        self.usdeathhistorylinechart.topAnchor.constraint(equalTo: resetzoombutton0.bottomAnchor, constant: 10).isActive = true
        self.usdeathhistorylinechart.leadingAnchor.constraint(equalTo: countryview.leadingAnchor, constant: 0).isActive = true
        self.usdeathhistorylinechart.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        self.usdeathhistorylinechart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        statetitle.topAnchor.constraint(equalTo: usdeathhistorylinechart.bottomAnchor, constant: 10).isActive = true
        statetitle.leadingAnchor.constraint(equalTo: countryview.leadingAnchor, constant: 0).isActive = true
        statetitle.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        statetitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.usstatetableview.topAnchor.constraint(equalTo: statetitle.bottomAnchor, constant: 10).isActive = true
        self.usstatetableview.leadingAnchor.constraint(equalTo: countryview.leadingAnchor, constant: 0).isActive = true
        self.usstatetableview.trailingAnchor.constraint(equalTo: countryview.trailingAnchor, constant: 0).isActive = true
        self.usstatetableview.bottomAnchor.constraint(equalTo: countryview.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupstatetableview() {
        self.usstatetableview.delegate = self
        self.usstatetableview.dataSource = self
        self.usstatetableview.register(StateTableViewCell.self, forCellReuseIdentifier: "StateCell")
    }
    
    
    // MARK: Update the cases, recovered, deaths labels
    private func refreshworlddata(withdata data: coronaData) {
        self.worldcase.text = self.data.worldtotaldata["cases"]?.formattedWithSeparator
        self.worldnewcase.text = "+ " + String(self.data.worldtotaldata["todayCases"]?.formattedWithSeparator ?? "0")
        self.worldrecovered.text = self.data.worldtotaldata["recovered"]?.formattedWithSeparator
        self.worldnewrecovered.text = "+ " + String(self.data.worldtotaldata["todayRecovered"]?.formattedWithSeparator ?? "0")
        self.worlddeath.text = data.worldtotaldata["deaths"]?.formattedWithSeparator
        self.worldnewdeaths.text = "+ " + String(data.worldtotaldata["todayDeaths"]?.formattedWithSeparator ?? "0")
//        self.updatelabel.text = "Updated on " + data.updatedDate
        self.updatelabel.text = NSLocalizedString("Update", comment: "Update title") + data.updatedDate
    }
    
    private func refreshusdata(withdata data: coronaData) {
        self.countrycase.text = self.data.ustotaldata["cases"]?.formattedWithSeparator
        self.countryrecovered.text = self.data.ustotaldata["recovered"]?.formattedWithSeparator
        self.countrydeath.text = data.ustotaldata["deaths"]?.formattedWithSeparator
        
        self.usnewcase.text = "+ " + String(self.data.ustotaldata["todayCases"]?.formattedWithSeparator ?? "0")
        self.usnewdeaths.text = "+ " + String(data.ustotaldata["todayDeaths"]?.formattedWithSeparator ?? "0")
        self.usnewrecovered.text = "+ " + String(self.data.ustotaldata["todayRecovered"]?.formattedWithSeparator ?? "0")

    }
    
    // MARK: Setting up the view
    private func setupscrollview() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(worldview)
        scrollViewContainer.addArrangedSubview(countryview)
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
    
    private func setupworldcaseview() {
        let worldstackview: UIStackView = {
            let stackview = UIStackView(arrangedSubviews: [placedescription, updatelabel, casedescription, worldcase, worldnewcase, worldrecovereddescription, worldrecovered, worldnewrecovered, deathdescription, worlddeath, worldnewdeaths])
            stackview.spacing = 5
            stackview.axis = .vertical
            stackview.translatesAutoresizingMaskIntoConstraints = false
            stackview.distribution = .fillProportionally
            return stackview
        }()
        self.worldview.addSubview(worldstackview)
        self.worldview.addSubview(worldPieChart)
        
        worldPieChart.leadingAnchor.constraint(equalTo: worldstackview.trailingAnchor, constant: 0).isActive = true
        worldPieChart.topAnchor.constraint(equalTo: worldstackview.topAnchor, constant: 0).isActive = true
        worldPieChart.trailingAnchor.constraint(equalTo: worldview.trailingAnchor, constant: 0).isActive = true
        worldPieChart.bottomAnchor.constraint(equalTo: worldstackview.bottomAnchor).isActive = true
        
        worldstackview.leadingAnchor.constraint(equalTo: worldview.leadingAnchor, constant: 0).isActive = true
        worldstackview.topAnchor.constraint(equalTo: worldview.topAnchor, constant: 0).isActive = true
        worldstackview.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
    }
    
    // MARK: Refresh Control
    private func setuprefreshcontrol() {
        self.scrollView.refreshControl = UIRefreshControl()
        self.scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .allEvents)
    }
    
    @objc func handleRefreshControl() {
        data.getTotalWorldData {
            DispatchQueue.main.async {
                self.refreshworlddata(withdata: self.data)
                self.refreshusdata(withdata: self.data)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: Chartview Delegate
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        let a = chartView === self.countryPieChart ? "Yes" : "No"
        if chartView === self.countryPieChart {
            if let e = entry as? PieChartDataEntry {
                let name = e.label
                let cases = Int(e.y)
                let str = name! + "\n" + String(cases.formattedWithSeparator)
                self.countryPieChart.centerAttributedText = NSAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: "Arial", size: 20)!, NSAttributedString.Key.foregroundColor:UIColor.label])
            }
        }
    }
    
    // MARK: Handles reset zoom for Charts
    @objc func handleresetzoom(sender: UIButton) {
        switch sender.tag {
        case 0:
            self.uscasehistorylinechart.zoomToCenter(scaleX: 0, scaleY: 0)
        case 1:
            self.usdeathhistorylinechart.zoomToCenter(scaleX: 0, scaleY: 0)
//            print(self.countrylabel.center.y)
//            self.scrollView.setContentOffset(CGPoint(x: 0, y: self.worldview.frame.height + self.countrylabel.center.y - 5), animated: true)
        default:
            return
        }
    }
    
    // MARK: Tableview DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.statescases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data.statescases.count > 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "StateCell", for: indexPath) as? StateTableViewCell {
                cell.statenamelabel.text = NSLocalizedString(data.statescases[indexPath.item].name, comment: "Country name")
                cell.statecaselabel.text = String(data.statescases[indexPath.item].cases)
                cell.statedeathlabel.text = String(data.statescases[indexPath.item].deaths)
                cell.staterecoverlabel.text = data.statescases[indexPath.item].recovered == 0 ? NSLocalizedString("N/A", comment: "N/A text") : String(data.statescases[indexPath.item].recovered)
                cell.statecaselabel.textColor = .systemRed
                cell.statedeathlabel.textColor = .systemGray
                cell.staterecoverlabel.textColor = .systemGreen
                return cell
            }
        }
        return UITableViewCell()
    }
    
    // MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .systemBackground
        let stackview : UIStackView = {
            let view = UIStackView()
            view.axis = .horizontal
            view.translatesAutoresizingMaskIntoConstraints = false
            view.spacing = 5
            view.distribution = .fillEqually
            return view
        }()
        let namelabel : UIButton = {
            let b = UIButton(type: .system)
            b.setTitle(NSLocalizedString("State", comment: "State title"), for: .normal)
            b.titleLabel?.font = UIFont(name: "Arial", size: 17)!.bold()
            b.setTitleColor(.label, for: .normal)
            b.contentHorizontalAlignment = .left
            b.addTarget(self, action: #selector(handlesorttable), for: .touchUpInside)
//            b.addTarget(self, action: #selector(handlecolorchange), for: .touchDown)
            b.tag = 0
            return b
        }()
        let caselabel : UIButton = {
            let b = UIButton(type: .system)
            b.setTitle(casetitletext, for: .normal)
            b.titleLabel?.font = UIFont(name: "Arial", size: 17)!.bold()
            b.setTitleColor(.label, for: .normal)
            b.contentHorizontalAlignment = .left
            b.addTarget(self, action: #selector(handlesorttable), for: .touchUpInside)
//            b.addTarget(self, action: #selector(handlecolorchange), for: .touchDown)
            b.tag = 1
            return b
        }()
        let deathlabel : UIButton = {
            let b = UIButton(type: .system)
            b.setTitle(deathtitletext, for: .normal)
            b.titleLabel?.font = UIFont(name: "Arial", size: 17)!.bold()
            b.setTitleColor(.label, for: .normal)
            b.contentHorizontalAlignment = .left
            b.addTarget(self, action: #selector(handlesorttable), for: .touchUpInside)
//            b.addTarget(self, action: #selector(handlecolorchange), for: .touchDown)
            b.tag = 2
            return b
        }()
        let recoverlabel : UIButton = {
            let b = UIButton(type: .system)
            b.setTitle(recoveredtitletext, for: .normal)
            b.titleLabel?.font = UIFont(name: "Arial", size: 17)!.bold()
            b.setTitleColor(.label, for: .normal)
            b.contentHorizontalAlignment = .left
            b.addTarget(self, action: #selector(handlesorttable), for: .touchUpInside)
//            b.addTarget(self, action: #selector(handlecolorchange), for: .touchDown)
            b.tag = 3
            return b
        }()
        
        stackview.addArrangedSubview(namelabel)
        stackview.addArrangedSubview(caselabel)
        stackview.addArrangedSubview(deathlabel)
        stackview.addArrangedSubview(recoverlabel)
        
        header.addSubview(stackview)
        
        stackview.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 5).isActive = true
        stackview.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -5).isActive = true
        stackview.topAnchor.constraint(equalTo: header.topAnchor, constant: 0).isActive = true
        stackview.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 0).isActive = true
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let c = DetailedViewController(withdata: self.data.statescases[indexPath.item])
        let c = DetailedViewController(ofstate: StateData(state: self.data.statescases[indexPath.item]))
        c.view.backgroundColor = .systemBackground
        self.navigationController?.pushViewController(c, animated: true)
    }
    
    

    // MARK: Handles sorting the table
    @objc func handlesorttable(sender: UIButton) {
        switch sender.tag {
        case 0:
            self.stateNameSortAscending = !self.stateNameSortAscending
            if self.stateNameSortAscending {
                self.data.statescases = self.data.statescases.sorted() { (p0, p1) in
                    p0.name < p1.name
                }
            } else {
                self.data.statescases = self.data.statescases.sorted() { (p0, p1) in
                    p0.name > p1.name
                }
            }
        case 1:
            self.caseNumberDecending = !self.caseNumberDecending
            if self.caseNumberDecending {
                self.data.statescases = self.data.statescases.sorted() { (p0, p1) in
                    p0.cases > p1.cases
                }
            } else {
                self.data.statescases = self.data.statescases.sorted() { (p0, p1) in
                    p0.cases < p1.cases
                }
            }
        case 2:
            self.deathNumberDecending = !self.deathNumberDecending
            if self.deathNumberDecending {
                self.data.statescases = self.data.statescases.sorted() { (p0, p1) in
                    p0.deaths > p1.deaths
                }
            } else {
                self.data.statescases = self.data.statescases.sorted() { (p0, p1) in
                    p0.deaths < p1.deaths
                }
            }
        case 3:
            self.recoverNumberDecending = !self.recoverNumberDecending
            if self.recoverNumberDecending {
                self.data.statescases = self.data.statescases.sorted() { (p0, p1) in
                    p0.recovered > p1.recovered
                }
            } else {
                self.data.statescases = self.data.statescases.sorted() { (p0, p1) in
                    p0.recovered < p1.recovered
                }
            }
        default:
            return
        }
        self.usstatetableview.reloadData()
    }
    // MARK: Handles change of color when buttons are tapped
//    @objc func handlecolorchange(sender: UIButton) {
//        if sender.tag == 2 {
//            sender.setTitleColor(.label, for: .normal)
//        } else {
//            sender.setTitleColor(.systemGray, for: .normal)
//        }
//    }
    
}


class ChartFormatter : NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        let date = Date(timeIntervalSince1970: value)
        return date.formatteddate
    }
}
