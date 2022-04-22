//
//  TripController.swift
//  copays
//
//  Created by Evelin Evelin on 05/04/22.
//

import UIKit

class TripController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    var editDate: String?
    var editName: String?
    var isEditTrip = false
    var isDone: Bool?
    var indexTrip:Int! 
    
    var names: [Member] = []
    var tripList = [Trip]()
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var tripImage: UIImageView!
    
    @IBOutlet weak var memberTable: UITableView!
    @IBOutlet weak var memberField: UITextField!
    @IBOutlet weak var tabelLabel: UILabel!

    @IBOutlet weak var addMemberField: UITextField!
    @IBOutlet weak var addMemberBtn: UIButton!
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditTrip {
            navTitle.title = "Edit Trip"
            prepareViewForEdit()
        } else {
            configMember()
            navTitle.title = "Add Trip"
        }
        
        getData()
        configureTripImage()
        configureDatePicker()
        configureTable()

        memberTable.dataSource = self
        memberTable.delegate = self
                
        //auto close pas tap screen
        let screenTapped = UITapGestureRecognizer(
            target: view,
            action: #selector(view.endEditing))
        
        //add gesturnya ke view
        view.addGestureRecognizer(screenTapped)

    }

    func getData(){
        if let tripListData = defaults.data(forKey: "TripList"){
            do{
                //array of trip
                let trip = try decoder.decode([Trip].self, from: tripListData)
                //assign
                tripList = trip
                print("TRIPPPPPP \(tripList.count)")
            }
            catch{
                print("ERROR")
            }
        }
    }
    
    func configMember(){
        names.insert(Member(name: "Me"), at: 0)
    }
    
    func prepareViewForEdit() {
        tripName.text = editName
    }
    
    @IBAction func cancelPressed(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    func configureTripImage(){
        if isDone == true{
            tripImage.image = UIImage(systemName: "airplane.arrival")
        }
        else{
            tripImage.image = UIImage(systemName: "airplane.departure")
        }
        tripImage.layer.cornerRadius = tripImage.frame.size.width/2
    }
    
    func configureTable(){
        if names.isEmpty {
            tabelLabel.text = "There is no member!"
            tabelLabel.isHidden = false
            memberTable.isHidden = true
        }
        else{
            tabelLabel.isHidden = true
            memberTable.isHidden = false
        }
    }
    
    //Buat Date Picker
    func configureDatePicker(){
        if isEditTrip{
            dateField.text = dateToString(date: stringToDate(eDate: editDate!))
        } else{
            dateField.text = dateToString(date: Date())
        }
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(updateDate(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        
        dateField.inputView = datePicker
    }
    
    func stringToDate(eDate: String) -> Date {
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: eDate)!
    }
    
    func dateToString(date: Date) -> String{
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    @objc func updateDate(datePicker: UIDatePicker){
        dateField.text = dateToString(date: datePicker.date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        cell.textLabel!.text = names[indexPath.row].name
        
        //as itu typecasting, ? itu kalo bisa nil, tapi kalo ! bener bener ga bisa nil
        let btnDelete = cell.contentView.viewWithTag(2) as? UIButton
        btnDelete!.addTarget(self, action: #selector(deleteRow(_ :)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteRow(_ sender: UIButton){
        let rowChoosen = sender.convert(CGPoint.zero, to: memberTable)
            
        print("rowChoosen \(rowChoosen)")
        
        //buat tau row yang mana yang dipilih dari table [col, row]
        guard let indexPath = memberTable.indexPathForRow(at: rowChoosen) else {
            return
        }
        print("indexPath \(indexPath)")

        names.remove(at: indexPath.row)
        memberTable.deleteRows(at: [indexPath], with: .left)
        configureTable()
    }
    
    @IBAction func addMemberPressed(_ sender: UIButton) {
        if let memberInput = memberField.text, memberInput.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Please enter the member correctly", preferredStyle: .alert)
            
            let okBtn = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okBtn)
            self.present(alert, animated: true)
            
            return
        }
        
        let memTemp = Member(name: memberField.text!)

        
        names.append(memTemp)
        memberTable.insertRows(at: [IndexPath(row:names.count-1, section:0)], with: .top)
        
        memberField.text = ""
        configureTable()
    }
    
    
    //auto close pas enter
    @IBAction func tripReturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func addMemberReturn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    //Save
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        guard !names.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Member can not be empty", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okBtn)
            self.present(alert, animated: true)
            
            return
        }
        
        if !isEditTrip{
            tripList.insert(Trip(name: tripName.text!, date: dateField.text!, totalExpenses: 0.0, totalMembers: names.count, isDone: false, members: names, transactions: []), at: 0)
        } else {
            tripList[indexTrip].name = tripName.text
            tripList[indexTrip].date = dateField.text
            tripList[indexTrip].members = names
            tripList[indexTrip].totalMembers = names.count
        }
        
        if let encodedUser = try? encoder.encode(tripList) {
            defaults.set(encodedUser, forKey: "TripList")
        }
        self.dismiss(animated: true)
        print("TRIP SAVED")
        print("Trip coun \(tripList.count)")
        NotificationCenter.default.post(name: Notification.Name("refreshTableViewData"), object: nil)

    }
}
