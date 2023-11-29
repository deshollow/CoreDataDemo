//
//  ViewController.swift
//  CoreDataDemoL3
//
//  Created by deshollow on 29.11.2023.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // 1. Получаем ссылку(доступ) на наш контейнер persistentContainer через прослойку viewContext
    
    var items: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPeople()
        
    }

    // функция обновления БД
    func fetchPeople() {
        do {
            self.items = try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch let error {
            print("Error: \(error)")
            
            // 2. Метод для извлечения данных из постоянного контейнера для отображения в таблице
        }
    }
    
    @IBAction func AddTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { action in
            let textField = alert.textFields![0]
            
            let newPerson = Person(context: self.context)
            // 3. создаем экземпляр Person с помощью context
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            // 4. Созраняем данные в нашем percistenContainer
            do {
                try self.context.save()
            } catch let error {
                print("Error: \(error)")
            }
            
            self.fetchPeople()
        }
        
        alert.addAction(submitButton)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let persons = items else {return UITableViewCell()}
        let person = persons[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = person.name
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // делаем удаление свайпом
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            let personToRemove = self.items?[indexPath.row]
            // выбираем какой элемент будет удален
            
            self.context.delete(personToRemove!)
            // удаление элемента из базы данных
            
            // сохраняем данные
            
            do {
                try self.context.save()
            } catch let error {
                print("Error: \(error)")
            }
            
            self.fetchPeople()
            //обновляем БД
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // выбираем данные по ячейке
        let person = self.items![indexPath.row]
        
        // создаем аллерт
        let alert = UIAlertController(title: "Edit Person", message: "Edit name", preferredStyle: .alert)
        alert.addTextField()
        
        let textfield = alert.textFields![0]
        textfield.text = person.name
        
        // настраиваем кнопку сохранения данных в алерте
        let saveButton = UIAlertAction(title: "Save", style: .default) { action in
            
            let textfield = alert.textFields![0]
            
            // изменяем данные в бз для выбранного экземпляра модели в ячейке
            person.name = textfield.text
            
            // сохраняем данные в БЗ
            
            do {
                try self.context.save()
            } catch let error {
                print("Error: \(error)")
            }
            
            self.fetchPeople()
            // обновляем БД
        }
        alert.addAction(saveButton)
        self.present(alert, animated: true, completion: nil)
    }
}
