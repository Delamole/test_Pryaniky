import UIKit
import Alamofire
import Bond

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTable: UITableView!
    
    @IBOutlet weak var head2Label: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var headLabel: UILabel!
    
    var categories = MutableObservableArray<CategoryModelData>()
    var variants = MutableObservableArray<VariantsData>()
    
    override func viewDidLoad() {
        loadCategories()
        reloadTable()
        super.viewDidLoad()
    }
    
    func reloadTable(){
        variants.bind(to: categoryTable) {(dataSourse, indexPath, table) -> UITableViewCell in
            let cell=table.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
            let model = self.variants[indexPath.row]
            cell.nameCategortLabel.text="\(model.id)"
            cell.sortOrderLabel.text = "\(model.text)"
            return cell
        }
    }
    
    func loadCategories() {
        let loader = LoadModel()
        loader.loadTopList { [weak self] (data) in
            DispatchQueue.main.async {
                for i in data.data {
                    self?.categories.append(i)
                    
                    if i.name == "hz"{
                        self?.headLabel.text = i.data.text
                        self?.head2Label.text = i.data.text
                    }
                    if i.name == "picture"{
                        self?.descrLabel.text = i.data.text
                        loader.loadImage(icon: i.data.url){(data) in
                            self?.image.image = data
                        }
                    }
                    if i.name == "selector" {
                        for j in i.data.variants {
                            self?.variants.append(j)
                        }
                        self?.categoryTable.reloadData()
                        self?.reloadTable()
                    }
                }
            }
        }
    }
}
extension CategoryViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedName = variants[indexPath.row]
        let uiAlert = UIAlertController(title: "Title", message: selectedName.text, preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Click of default button")
        }))
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
    }
}

