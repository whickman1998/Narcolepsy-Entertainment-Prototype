//
//  SleepAnalysisViewController.swift
//  Nudge
//
//  Created by William Hickman on 5/26/19.
//  Copyright © 2019 William Hickman Ent. All rights reserved.
//

import UIKit
import HealthKit


class SleepAnalysisViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ChartDelegate {
    
    let healthStore = HKHealthStore()
    var nights = [Night]()
    
    let dateFormatter = DateFormatter()
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("savedNights")
    var ourDefaults = UserDefaults.standard

    @IBOutlet weak var sleepChart: Chart!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var dataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        //Asks for read and write permissions from HealthKit
        getHKAccess()
        
        //Current API use is set up assuming that there is current data in HealthStore
        //Uncomment line below to put in placeholder data into HealthStore
        //saveSleepData()
        
        //Obtains HealthStoreData
        getSleepData()
        
        findSavedNights()
        
        //Sets up Chart
        sleepChart.delegate = self
        dataLabel.text = ""
        initSleepChart()
        
        self.navigationController?.topViewController?.navigationItem.title = "Sleep Data Analysis"
        
    }
    
    func findSavedNights() {
        if (ourDefaults.object(forKey: "lastUpdate") as? Date) != nil {
            let dialog = UIAlertController(title: "Welcome Back!", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Go Away", style: .cancel, handler: nil)
            dialog.addAction(action)
            present(dialog, animated: true, completion: nil)
            
            do {
                let data = try Data(contentsOf: SleepAnalysisViewController.archiveURL)
                let decoder = JSONDecoder()
                let tempArr = try decoder.decode([Night].self, from: data)
                
                for night in tempArr {
                    updateNightList(night: night)
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func updatePersistentStorage() {
        //persist data
        let encoder = JSONEncoder()
        var tempArr = [Night]()
        for night in nights {
            if night.didSet {
                tempArr.append(night)
            }
        }
        do {
            let jsonData = try encoder.encode(tempArr)
            try jsonData.write(to: SleepAnalysisViewController.archiveURL)
            
            //timestamp last update
            ourDefaults.set(Date(), forKey: "lastUpdate")
        } catch {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let imageView = UIImageView(image: UIImage(named: "icon.png"))
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)])
    }
    
    // MARK: - SwiftChart Methods
    
    private func initSleepChart() {
        //Gets hours into their own array
        var hours = [Double]()
        for night in nights {
            hours.append(night.asleepHours)
        }
        hours.reverse()
        
        sleepChart!.minX = -1
        sleepChart!.maxX = Double(hours.count)
        sleepChart!.minY = 4
        
        let series = ChartSeries(hours)
        series.area = true
        
        var tempArr = [Double]()
        for i in 0..<hours.count {
            tempArr.append(Double(i))
        }
        
        sleepChart.xLabels = tempArr.sorted().reversed()
        sleepChart.xLabelsFormatter = { (Int, Double) -> String in return ""}
        sleepChart.yLabelsFormatter = { String(Int($1)+1) + "h"}
        
        series.colors = (
            above: ChartColors.blueColor(),
            below: ChartColors.redColor(),
            zeroLevel: 7
        )
        
        sleepChart.add(series)
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (serisIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                let value = chart.valueForSeries(serisIndex, atIndex: dataIndex)
                dataLabel.text = "\(dateFormatter.string(from: nights[nights.count - 1 - dataIndex!].startDate)): \(Int(value!)) hours"
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    // MARK: - UIPickerViewDataSource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterNights().count
    }
    
    // MARK: - UIPickerViewDelegate Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateFormatter.string(from: filterNights()[row].startDate)
    }
    
    // MARK: - HealthKit Data Methods
    
    private func getHKAccess() {
        //HealthKit authorization setup
        if HKHealthStore.isHealthDataAvailable() {
            let typestoRead = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!])
            let typestoShare = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!])
            self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead, completion: {(success, error) in
                if !success {
                    print("error in authorization")
                }
            })
        }
    }
    
    private func getSleepData() {
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor], resultsHandler: {(query, tmpResult, error) -> Void in
                
                if error != nil {
                    print("query error")
                    return
                }
                
                if let result = tmpResult {
                    for item in result {
                        if let sample = item as? HKCategorySample {
                            let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                            if value == "Asleep" {
                                self.nights.append(Night(asleepHours: sample.endDate.timeIntervalSince(sample.startDate) / 3600.0, startDate: sample.startDate))
                            }
                        }
                    }
                }
            })
            healthStore.execute(query)
        }
    }
    
    private func saveSleepData() {
        
        let startTime = Date(timeIntervalSinceNow: -46800)
        let endTime = Date(timeIntervalSinceNow: -10800)
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) {
            
            let object = HKCategorySample(type: sleepType, value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: startTime, end: endTime)
            
            healthStore.save(object, withCompletion: { (success, error) -> Void in
                if error != nil {
                    return
                }
                if success {
                    print("inBed saved")
                }
            })
            
            let object2 = HKCategorySample(type: sleepType, value: HKCategoryValueSleepAnalysis.asleep.rawValue, start: startTime, end: endTime)
            
            healthStore.save(object2, withCompletion: { (success, error) -> Void in
                if error != nil {
                    return
                }
                if success {
                    print("asleep saved")
                }
            })
            
        }
        
    }
    
    @IBAction func recordPressed(_ sender: Any) {
        if filterNights().count > 0 {
            performSegue(withIdentifier: "toRecord", sender: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? ReportViewController {
            destVC.night = filterNights()[pickerView.selectedRow(inComponent: 0)]
        }
        if let destVC = segue.destination as? ForecastViewController {
            destVC.night = nights[0]
        }
    }
    
    func filterNights() -> [Night] {
        var filtered = [Night]()
        for night in nights {
            if !night.didSet {
                filtered.append(night)
            }
        }
        return filtered
    }
    
    func updateNightList(night: Night) {
        for i in 0..<nights.count {
            if nights[i].startDate == night.startDate {
                nights[i] = night
            }
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        pickerView.reloadComponent(0)
        updatePersistentStorage()
    }

}
