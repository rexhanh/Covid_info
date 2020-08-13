//
//  Data.swift
//  Covid Information
//
//  Created by Yuanrong Han on 7/30/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import Foundation
import Charts

class coronaData {
    var worldtotaldata = [String:Int]()
    var ustotaldata = [String:Int]()
    var updatedDate : String!
    var restworld =  Place(name: "Other", cases: 0, active: 0, deaths: 0, recovered: 0)
    var reststate = Place(name: "Other", cases: 0, active: 0, deaths: 0, recovered: 0)
    var topcountries = [Place]()
    var topstates = [Place]()
    var statescases = [Place]()
//    var ushistorical = [Date:Int]()
    var ushistorical = [Date:[String:Int]]()
    let usstateabrv =     ["Alabama": "AL",
    "Alaska": "AK",
    "American Samoa": "AS",
    "Arizona": "AZ",
    "Arkansas": "AR",
    "California": "CA",
    "Colorado": "CO",
    "Connecticut": "CT",
    "Delaware": "DE",
    "District of Columbia": "DC",
    "Florida": "FL",
    "Georgia": "GA",
    "Guam": "GU",
    "Hawaii": "HI",
    "Idaho": "ID",
    "Illinois": "IL",
    "Indiana": "IN",
    "Iowa": "IA",
    "Kansas": "KS",
    "Kentucky": "KY",
    "Louisiana": "LA",
    "Maine": "ME",
    "Maryland": "MD",
    "Massachusetts": "MA",
    "Michigan": "MI",
    "Minnesota": "MN",
    "Mississippi": "MS",
    "Missouri": "MO",
    "Montana": "MT",
    "Nebraska": "NE",
    "Nevada": "NV",
    "New Hampshire": "NH",
    "New Jersey": "NJ",
    "New Mexico": "NM",
    "New York": "NY",
    "North Carolina": "NC",
    "North Dakota": "ND",
    "Northern Mariana Islands":"MP",
    "Ohio": "OH",
    "Oklahoma": "OK",
    "Oregon": "OR",
    "Pennsylvania": "PA",
    "Puerto Rico": "PR",
    "Rhode Island": "RI",
    "South Carolina": "SC",
    "South Dakota": "SD",
    "Tennessee": "TN",
    "Texas": "TX",
    "Utah": "UT",
    "Vermont": "VT",
    "Virgin Islands": "VI",
    "Virginia": "VA",
    "Washington": "WA",
    "West Virginia": "WV",
    "Wisconsin": "WI",
    "Wyoming": "WY"]
    // Get world total cases, deaths, recovered
    // refreshworlddata() -> getTotalWorldData
    func getTotalWorldData(completion: @escaping () -> Void) {
        let urlstr = "https://disease.sh/v3/covid-19/all"
        guard let url = URL(string: urlstr) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let alldata = data else {return}
            let json = try? JSONSerialization.jsonObject(with: alldata, options: [])
            guard let dictionary = json as? [String:Any] else {return}
            guard let cases = dictionary["cases"] as? Int else {return}
            guard let todayCases = dictionary["todayCases"] as? Int else {return}
            guard let deaths = dictionary["deaths"] as? Int else {return}
            guard let todayDeaths = dictionary["todayDeaths"] as? Int else {return}
            guard let recovered = dictionary["recovered"] as? Int else {return}
            guard let todayRecovered = dictionary["todayRecovered"] as? Int else {return}
            guard let active = dictionary["active"] as? Int else {return}
            guard let updated = dictionary["updated"] as? TimeInterval else {return}
            self.updatedDate = Date(timeIntervalSince1970: updated / 1000).formatteddate
            self.worldtotaldata["cases"] = cases
            self.worldtotaldata["todayCases"] = todayCases
            self.worldtotaldata["deaths"] = deaths
            self.worldtotaldata["todayDeaths"] = todayDeaths
            self.worldtotaldata["recovered"] = recovered
            self.worldtotaldata["todayRecovered"] = todayRecovered
            self.worldtotaldata["active"] = active
            self.restworld = Place(name: "Other", cases: cases, active: active, deaths: deaths, recovered: recovered)
            completion()
            }.resume()
    }
    
    // Top three countries with most cases
    // topthreecountrydatarefreash -> getTopCountriesData
    func getTopCountriesData(completion: @escaping () -> Void) {
        let urlstr = "https://disease.sh/v3/covid-19/countries?sort=cases"
        guard let url = URL(string: urlstr) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let alldata = data else {return}
            let json = try? JSONSerialization.jsonObject(with: alldata, options: [])
            guard let array = json as? [[String:Any]] else {return}
            let topthree = Array(array[0..<3])
            for c in topthree {
                guard let cases = c["cases"] as? Int else {return}
                guard let active = c["active"] as? Int else {return}
                guard let deaths = c["deaths"] as? Int else {return}
                guard let recovered = c["recovered"] as? Int else {return}
                guard let name = c["country"] as? String else {return}
                let translatedName = NSLocalizedString(name, comment: "Country name")
                self.topcountries.append(Place(name: translatedName, cases: cases, active: active, deaths: deaths, recovered: recovered))
                self.restworld.cases -= cases
                self.restworld.active -= active
                self.restworld.deaths -= deaths
                self.restworld.recovered -= recovered
            }
            completion()
        }.resume()
    }
    
    // Get Piechart data from the top countries
    // getPieChartData -> toPieChartData
    func toPieChartData(isforworld world: Bool) -> PieChartData {
        var chartData = [PieChartDataEntry]()
        let places = world ? self.topcountries : self.topstates
        for p in places {
            if !world {
                chartData.append(PieChartDataEntry(value: Double(p.cases), label: NSLocalizedString(usstateabrv[p.name]!, comment: "Country name")))
            } else {
                chartData.append(PieChartDataEntry(value: Double(p.cases), label: p.name))
            }
        }
        let value = world ? Double(self.restworld.cases) : Double(self.reststate.cases)
        let other = world ? NSLocalizedString("Other Countries", comment: "Other Countries title") : NSLocalizedString("Other States", comment: "Other States title")
        chartData.append(PieChartDataEntry(value: value, label: other))
        let set = PieChartDataSet(entries: chartData, label: "Top 3 Covid-19 Cases Countries")
        
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.5
        set.valueLinePart2Length = 0.3
        set.valueLineColor = .label
        set.drawIconsEnabled = false
        set.sliceSpace = 1
        set.yValuePosition = world ? .insideSlice : .outsideSlice
        set.colors = world ? [UIColor.systemRed, UIColor.systemTeal, UIColor.systemOrange, UIColor.systemGray] : [UIColor.systemRed, UIColor.systemTeal, UIColor.systemOrange, UIColor.systemGreen, UIColor.systemPurple, UIColor.systemGray]
        
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        
        let data = PieChartData(dataSet: set)
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueTextColor(.label)
        data.setValueFont(UIFont(name: "Arial", size: 13)!)
        return data
    }
    
    //Get USA Cases
    // refreshUSA -> getUSTotalData
    func getUSTotalData(completion: @escaping () -> Void) {
        let urlstr = "https://disease.sh/v3/covid-19/countries/USA"
        guard let url = URL(string: urlstr) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let usdata = data else {return}
            let json = try? JSONSerialization.jsonObject(with: usdata, options: [])
            guard let dictionary = json as? [String:Any] else {return}
            guard let cases = dictionary["cases"] as? Int else {return}
            guard let todayCases = dictionary["todayCases"] as? Int else {return}
            guard let deaths = dictionary["deaths"] as? Int else {return}
            guard let todayDeaths = dictionary["todayDeaths"] as? Int else {return}
            guard let recovered = dictionary["recovered"] as? Int else {return}
            guard let todayRecovered = dictionary["todayRecovered"] as? Int else {return}
            guard let active = dictionary["active"] as? Int else {return}
            
            self.ustotaldata["cases"] = cases
            self.ustotaldata["todayCases"] = todayCases
            self.ustotaldata["deaths"] = deaths
            self.ustotaldata["todayDeaths"] = todayDeaths
            self.ustotaldata["recovered"] = recovered
            self.ustotaldata["todayRecovered"] = todayRecovered
            self.ustotaldata["active"] = active
            
            self.reststate = Place(name: "Other", cases: cases, active: active, deaths: deaths, recovered: recovered)
            completion()
        }.resume()
    }
    
    // Top three states with most cases
    //topstatesdatarefresh -> getTopStatesData
    func getTopStatesData(completion: @escaping () -> Void) {
        let urlstr = "https://disease.sh/v3/covid-19/states?sort=cases"
        guard let url = URL(string: urlstr) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let alldata = data else {return}
            let json = try? JSONSerialization.jsonObject(with: alldata, options: [])
            guard let array = json as? [[String:Any]] else {return}
            let topthree = Array(array[0..<5])
            for c in topthree {
                guard let cases = c["cases"] as? Int else {return}
                guard let active = c["active"] as? Int else {return}
                guard let deaths = c["deaths"] as? Int else {return}
                guard let name = c["state"] as? String else {return}
                self.topstates.append(Place(name: name, cases: cases, active: active, deaths: deaths, recovered: 0))
                self.reststate.cases -= cases
                self.reststate.active -= active
                self.reststate.deaths -= deaths
            }
            completion()
        }.resume()
    }

    // getushistorical -> getUSHistoricalData
    func getUSHistoricalData(completion: @escaping () -> Void) {
        let urlString = "https://covidtracking.com/api/v1/us/daily.json"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let coronadata = data else {return}
            let json = try? JSONSerialization.jsonObject(with: coronadata, options: [])
            guard let array = json as? [[String:Any]] else {return}
            for i in 0..<(array.count - 40) {
                guard let dateint = array[i]["date"] as? Int else {return}
                let date = String(dateint).formatteddate0
                guard let cases = array[i]["positive"] as? Int else {return}
                guard let newcases = array[i]["positiveIncrease"] as? Int else {return}
                guard let deaths = array[i]["death"] as? Int else {return}
                guard let newdeaths = array[i]["deathIncrease"] as? Int else {return}
                self.ushistorical[date] = ["cases":cases, "newcases":newcases, "deaths":deaths, "newdeaths":newdeaths]
            }
            completion()
        }.resume()
    }
    
    // tocovidcaseLineData -> toCovidCaseLineData
    func toCovidCaseLineData() -> LineChartData {
        var casedata = [ChartDataEntry]()
        var newcasedata = [ChartDataEntry]()
        let sortedDates = self.ushistorical.keys.sorted()
        
        for i in 0 ..< sortedDates.count {
            let dateNumber = Double(sortedDates[i].timeIntervalSince1970)
            casedata.append(ChartDataEntry(x: dateNumber, y: Double(self.ushistorical[sortedDates[i]]!["cases"]!)))
            newcasedata.append(ChartDataEntry(x: dateNumber, y: Double(self.ushistorical[sortedDates[i]]!["newcases"]!)))
        }
        let caseset = LineChartDataSet(entries: casedata, label: NSLocalizedString("Cumulative Cases", comment: "Cumulative case title"))
        let newcaseset = LineChartDataSet(entries: newcasedata, label: NSLocalizedString("New Cases", comment: "New case title"))

        caseset.lineWidth = 1.8
        caseset.circleRadius = 5.0
        caseset.setColor(.systemRed)
        caseset.drawValuesEnabled = false
        caseset.valueFont = UIFont(name: "Arial", size: 10)!
        caseset.valueColors = [.label]
        caseset.mode = .cubicBezier
        caseset.drawCirclesEnabled = false
        caseset.axisDependency = .left
        caseset.highlightColor = .label
        
        newcaseset.lineWidth = 1.8
        newcaseset.circleRadius = 5.0
        newcaseset.setColor(.systemOrange)
        newcaseset.drawValuesEnabled = false
        newcaseset.valueFont = UIFont(name: "Arial", size: 10)!
        newcaseset.valueColors = [.label]
        newcaseset.mode = .cubicBezier
        newcaseset.drawCirclesEnabled = false
        newcaseset.axisDependency = .right
        newcaseset.highlightColor = .label
        
        let data = LineChartData(dataSets: [caseset, newcaseset])
        data.setValueFont(UIFont(name: "Arial", size: 9)!)
        data.setDrawValues(false)
        return data
    }
    // tocoviddeathLineData() -> toCovidDeathLineData()
    func toCovidDeathLineData() -> LineChartData {
        var casedata = [ChartDataEntry]()
        var newcasedata = [ChartDataEntry]()
        let sortedDates = self.ushistorical.keys.sorted()
        
        for i in 0 ..< sortedDates.count {
            let dateNumber = Double(sortedDates[i].timeIntervalSince1970)
            casedata.append(ChartDataEntry(x: dateNumber, y: Double(self.ushistorical[sortedDates[i]]!["deaths"]!)))
            newcasedata.append(ChartDataEntry(x: dateNumber, y: Double(self.ushistorical[sortedDates[i]]!["newdeaths"]!)))
        }
        let caseset = LineChartDataSet(entries: casedata, label: NSLocalizedString("Cumulative Deaths", comment: "Cumulative Deaths title"))
        let newcaseset = LineChartDataSet(entries: newcasedata, label: NSLocalizedString("New Deaths", comment: "New Deaths title"))

        caseset.lineWidth = 1.8
        caseset.circleRadius = 5.0
        caseset.setColor(.linechartRed)
        
        caseset.drawValuesEnabled = false
        caseset.valueFont = UIFont(name: "Arial", size: 10)!
        caseset.valueColors = [.label]
        caseset.mode = .cubicBezier
        caseset.drawCirclesEnabled = false
        caseset.axisDependency = .left
        caseset.highlightColor = .label
        
        newcaseset.lineWidth = 1.8
        newcaseset.circleRadius = 5.0
        newcaseset.setColor(.linechartDarkBlue)
        newcaseset.drawValuesEnabled = false
        newcaseset.valueFont = UIFont(name: "Arial", size: 10)!
        newcaseset.valueColors = [.label]
        newcaseset.mode = .cubicBezier
        newcaseset.drawCirclesEnabled = false
        newcaseset.axisDependency = .right
        newcaseset.highlightColor = .label
        
        let data = LineChartData(dataSets: [caseset, newcaseset])
        data.setValueFont(UIFont(name: "Arial", size: 9)!)
        data.setDrawValues(false)
        return data
    }
    
    // getstatesdata -> getAllStatesData
    func getAllStatesData(completion: @escaping () -> Void) {
        let urlstr = "https://covidtracking.com/api/v1/states/current.json"
        guard let url = URL(string: urlstr) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let alldata = data else {return}
            let json = try? JSONSerialization.jsonObject(with: alldata, options: [])
            guard let array = json as? [[String:Any]] else {return}
            for s in array {
                guard let name = s["state"] as? String else {return}
                guard let cases = s["positive"] as? Int else {return}
                guard let death = s["death"] as? Int else {return}
//                guard let recover = s["recovered"] as? Int else {return}
                if let recover = s["recovered"] as? Int {
                    self.statescases.append(Place(name: name, cases: cases, active: 0, deaths: death, recovered: recover))
                } else {
                    self.statescases.append(Place(name: name, cases: cases, active: 0, deaths: death, recovered: 0))
                }
            }
            completion()
        }.resume()
    }
}

class StateData {
    var statehisroticaldata = [Date:[String:Int]]()
    var state: Place
    init(state: Place) {
        self.state = state
    }
    func getStateHistoricalData(completion: @escaping () -> Void) {
        let urlstr = "https://covidtracking.com/api/v1/states/" + self.state.name.lowercased() + "/daily.json"
        guard let url = URL(string: urlstr) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let alldata = data else {return}
            let json = try? JSONSerialization.jsonObject(with: alldata, options: [])
            guard let array = json as? [[String:Any]] else {return}
            for i in 0..<(array.count - 40) {
                guard let dateint = array[i]["date"] as? Int else {return}
                let date = String(dateint).formatteddate0
                guard let cases = array[i]["positive"] as? Int else {return}
                guard let newcases = array[i]["positiveIncrease"] as? Int else {return}
                guard let deaths = array[i]["death"] as? Int else {return}
                guard let newdeaths = array[i]["deathIncrease"] as? Int else {return}
                self.statehisroticaldata[date] = ["cases":cases, "newcases":newcases, "deaths":deaths, "newdeaths":newdeaths]
            }
            completion()
        }.resume()
    }
    
    func toCovidCaseLineData() -> LineChartData {
        var casedata = [ChartDataEntry]()
        var newcasedata = [ChartDataEntry]()
        let sortedDates = self.statehisroticaldata.keys.sorted()
        
        for i in 0 ..< sortedDates.count {
            let dateNumber = Double(sortedDates[i].timeIntervalSince1970)
            casedata.append(ChartDataEntry(x: dateNumber, y: Double(self.statehisroticaldata[sortedDates[i]]!["cases"]!)))
            newcasedata.append(ChartDataEntry(x: dateNumber, y: Double(self.statehisroticaldata[sortedDates[i]]!["newcases"]!)))
        }
        let caseset = LineChartDataSet(entries: casedata, label: NSLocalizedString("Cumulative Cases", comment: "Cumulative case title"))
        let newcaseset = LineChartDataSet(entries: newcasedata, label: NSLocalizedString("New Cases", comment: "New Cases title"))

        caseset.lineWidth = 1.8
        caseset.circleRadius = 5.0
        caseset.setColor(.systemRed)
        caseset.drawValuesEnabled = false
        caseset.valueFont = UIFont(name: "Arial", size: 10)!
        caseset.valueColors = [.label]
        caseset.mode = .cubicBezier
        caseset.drawCirclesEnabled = false
        caseset.axisDependency = .left
        caseset.highlightColor = .label
        
        newcaseset.lineWidth = 1.8
        newcaseset.circleRadius = 5.0
        newcaseset.setColor(.systemOrange)
        newcaseset.drawValuesEnabled = false
        newcaseset.valueFont = UIFont(name: "Arial", size: 10)!
        newcaseset.valueColors = [.label]
        newcaseset.mode = .cubicBezier
        newcaseset.drawCirclesEnabled = false
        newcaseset.axisDependency = .right
        newcaseset.highlightColor = .label
        
        let data = LineChartData(dataSets: [caseset, newcaseset])
        data.setValueFont(UIFont(name: "Arial", size: 9)!)
        data.setDrawValues(false)
        return data
    }
    
    func toCovidDeathLineData() -> LineChartData {
        var casedata = [ChartDataEntry]()
        var newcasedata = [ChartDataEntry]()
        let sortedDates = self.statehisroticaldata.keys.sorted()
        
        for i in 0 ..< sortedDates.count {
            let dateNumber = Double(sortedDates[i].timeIntervalSince1970)
            casedata.append(ChartDataEntry(x: dateNumber, y: Double(self.statehisroticaldata[sortedDates[i]]!["deaths"]!)))
            newcasedata.append(ChartDataEntry(x: dateNumber, y: Double(self.statehisroticaldata[sortedDates[i]]!["newdeaths"]!)))
        }
        let caseset = LineChartDataSet(entries: casedata, label: NSLocalizedString("Cumulative Deaths", comment: "Cumulative Deaths title"))
        let newcaseset = LineChartDataSet(entries: newcasedata, label: NSLocalizedString("New Deaths", comment: "New Deaths title"))

        caseset.lineWidth = 1.8
        caseset.circleRadius = 5.0
        caseset.setColor(.linechartRed)
        
        caseset.drawValuesEnabled = false
        caseset.valueFont = UIFont(name: "Arial", size: 10)!
        caseset.valueColors = [.label]
        caseset.mode = .cubicBezier
        caseset.drawCirclesEnabled = false
        caseset.axisDependency = .left
        caseset.highlightColor = .label
        
        newcaseset.lineWidth = 1.8
        newcaseset.circleRadius = 5.0
        newcaseset.setColor(.linechartDarkBlue)
        newcaseset.drawValuesEnabled = false
        newcaseset.valueFont = UIFont(name: "Arial", size: 10)!
        newcaseset.valueColors = [.label]
        newcaseset.mode = .cubicBezier
        newcaseset.drawCirclesEnabled = false
        newcaseset.axisDependency = .right
        newcaseset.highlightColor = .label
        
        let data = LineChartData(dataSets: [caseset, newcaseset])
        data.setValueFont(UIFont(name: "Arial", size: 9)!)
        data.setDrawValues(false)
        return data
    }
}

struct Place {
    var name: String
    var cases: Int
    var active: Int
    var deaths: Int
    var recovered: Int
}



