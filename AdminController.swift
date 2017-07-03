//=================================
import UIKit
//=================================
class AdminController: UIViewController{
    
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var motDePasse: UITextField!
    @IBOutlet weak var bouton: UIButton!
    
    var defaults = UserDefaults.standard
    var password: String!
//=================================
    override func viewDidLoad() {
        super.viewDidLoad()
        //*-- Code pour reset le mot de passe --*
        //defaults.removeObject(forKey: "password")
        etablirMotDePasse()
    }
//=================================
//--- Confirme si le mot de passe est bon
    @IBAction func confirmation(_ sender: UIButton) {
        if defaults.object(forKey: "password") == nil
        {
            defaults.set(motDePasse.text, forKey:"password")
            etablirMotDePasse()
        }
        else
        {
         password = defaults.object(forKey: "password") as! String
         if password == motDePasse.text
         {
            performSegue(withIdentifier: "segue", sender: nil)
         }
         else
         {
            let alerte = UIAlertController(title: "Erreur!", message: "Mauvais mot de passe", preferredStyle: UIAlertControllerStyle.alert)
            
            alerte.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.default, handler:nil))
            
            self.present(alerte,animated: true, completion: nil)
         }
        }
    }
//=================================
//---methode qui permet de créer un mot de passe
    private func etablirMotDePasse(){
        if defaults.object(forKey: "password") == nil{
            titre.text = "Créer un mot de passe "
            bouton.setTitle("CRÉER", for: .normal)
        }
        else{
            titre.text = "Section réservé à l'administration"
            bouton.setTitle("CONFIRMER", for: .normal)
            motDePasse.isSecureTextEntry = true
        }
    }
    
    
}
