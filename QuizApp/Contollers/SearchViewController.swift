//
//  SearchViewController.swift
//  QuizApp
//
//  Created by sara on 22/06/2020.
//  Copyright © 2020 sara. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController:UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UITextField!
    var quizzesDataModels: [NSManagedObject] = []
    var shownDataModels: [NSManagedObject] = []
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "QuizModel")
      
      //3
      do {
        quizzesDataModels = try managedContext.fetch(fetchRequest)
        shownDataModels = quizzesDataModels
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    @IBAction func searchClicked(_ sender: Any) {
        if let text = textLabel.text{
            refineTable(label:text)
        }
        
    }
    func refineTable(label: String){
            var title=""
            shownDataModels.removeAll()
            for (i,obj) in quizzesDataModels.enumerated().reversed()
            {
                for key in obj.entity.attributesByName.keys{
                               let value: Any? = obj.value(forKey: key)
                            if("\(key)" == "title"){
                                title = value as! String
                               if title.contains(label){
                                   //nemoj brisat
                                    print("stavili kviz")
                                    shownDataModels.append(obj)
                               }else{
                                   //izbrisi
                                   print("priskocili kviz")
                               }
                }
            }
                self.tableView.reloadData()
        }
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shownDataModels.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        // set the text from the data model
        var title = ""
        let kviz = self.shownDataModels[indexPath.row]
               for key in kviz.entity.attributesByName.keys{
                   let value: Any? = kviz.value(forKey: key)
                if("\(key)" == "title"){
                    title = value as! String
                }
                   print("\(key) = \(value)")
               }
      cell.textLabel?.text = title
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    
       
       
       // cell reuse id (cells that scroll out of view can be reused)
       let cellReuseIdentifier = "cell"
    override func viewDidLoad() {
           super.viewDidLoad()
           
           // Register the table view cell class and its reuse id
           self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
           
           // (optional) include this line if you want to remove the extra empty cell divider lines
           // self.tableView.tableFooterView = UIView()

           // This view controller itself will provide the delegate methods and row data for the table view.
           tableView.delegate = self
           tableView.dataSource = self
        getQuizObjectsFromCoreData()
       }
    func getQuizObjectsFromCoreData(){
       //1
             guard let appDelegate =
               UIApplication.shared.delegate as? AppDelegate else {
                 return
             }
             
             let managedContext =
               appDelegate.persistentContainer.viewContext
             
             //2
        let fetchRequestK =
                      NSFetchRequest<NSManagedObject>(entityName: "QuizModel")
        let fetchRequestQ =
               NSFetchRequest<QuestionModel>(entityName: "QuestionModel")
        
        
        do{
            let questions = try managedContext.fetch(fetchRequestQ)
            
            for question in questions{
                print(question.questionTxt)
                print(question.parentQuiz?.id)
            }
        }catch let error as NSError{
            print("could not fetch")
        }
        
    }
}
