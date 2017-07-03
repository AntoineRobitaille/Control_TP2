//=================================
import UIKit
//=================================
//--- Contrôleur pour la page d'inscription
class ViewController: UIViewController
{
    /* ---------------------------------------*/
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var amis: UIButton!
    @IBOutlet weak var radio: UIButton!
    @IBOutlet weak var pub_internet: UIButton!
    @IBOutlet weak var journaux: UIButton!
    @IBOutlet weak var moteur: UIButton!
    @IBOutlet weak var sociaux: UIButton!
    @IBOutlet weak var tv: UIButton!
    @IBOutlet weak var autres: UIButton!
    /* ---------------------------------------*/
    var pickerChoice: String = ""
    var arrMediaButtons:[UIButton]!
    /* ---------------------------------------*/
    var arrForButtonManagement: [Bool] = []
    let arrProgramNames: [String] = [
        "DEC - Techniques de production et postproduction télévisuelles (574.AB)",
        "AEC - Production télévisuelle et cinématographique (NWY.15)",
        "AEC - Techniques de montage et d’habillage infographique (NWY.00)",
        "DEC - Techniques d’animation 3D et synthèse d’images (574.BO)",
        "AEC - Production 3D pour jeux vidéo (NTL.12)",
        "AEC - Animation 3D et effets spéciaux (NTL.06)",
        "DEC - Techniques de l’informatique, programmation nouveaux médias (420.AO)",
        "DEC - Technique de l’estimation en bâtiment (221.DA)",
        "DEC - Techniques de l’évaluation en bâtiment (221.DB)",
        "AEC - Techniques d’inspection en bâtiment (EEC.13)",
        "AEC - Métré pour l’estimation en construction (EEC.00)",
        "AEC - Sécurité industrielle et commerciale (LCA.5Q)"]
    //let jsonManager = JsonManager(urlToJsonFile: "http://localhost/xampp/geneau/ig_po/json/data.json")
    let jsonManager = JsonManager(urlToJsonFile: "http://www.igweb.tv/ig_po/json/data.json")
    /* ---------------------------------------*/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrMediaButtons = [amis, radio, pub_internet, journaux, moteur, sociaux, tv, autres]
        
        jsonManager.importJSON()
        
        fillUpArray()
    }
    /* ---------------------------------------*/
    func fillUpArray()
    {
        for _ in 0...11
        {
            arrForButtonManagement.append(false)
        }
    }
    /* ---------------------------------------*/
    //--- Gère les programmes sélectionné par l'utilisateur
    func manageSelectedPrograms() -> String
    {
        var stringToReturn: String = ". "
        
        for x in 0 ..< arrProgramNames.count
        {
            if arrForButtonManagement[x]
            {
                stringToReturn += arrProgramNames[x] + "\n. "
            }
        }
       
        // Supprime le retour de charriot a la fin du dernier élément
        if stringToReturn != ""
        {
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
        }
        
        return stringToReturn
    }
    /* ---------------------------------------*/
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    /* ---------------------------------------*/
    //--- Fonction lorsqu'on appui sur le bouton du choix du programme
    @IBAction func buttonManager(_ sender: UIButton)
    {
        let buttonIndexInArray = sender.tag - 100
        
        if !arrForButtonManagement[buttonIndexInArray]
        {
            sender.setImage(UIImage(named: "case_select.png"), for: UIControlState())
            arrForButtonManagement[buttonIndexInArray] = true
        }
        else
        {
            sender.setImage(UIImage(named: "case.png"), for: UIControlState())
            arrForButtonManagement[buttonIndexInArray] = false
        }
    }
    /* ---------------------------------------*/
    //--- Désélectionne tout les programmes après une sauvegarde
    func deselectAllButtons()
    {
        for x in 0 ..< arrForButtonManagement.count
        {
            arrForButtonManagement[x] = false
            let aButton: UIButton = (view.viewWithTag(100 + x) as? UIButton)!
            aButton.setImage(UIImage(named: "case.png"), for: UIControlState())
        }
    }
    /* ---------------------------------------*/
    //--- Fonction qui s'exécute lorsqu'on appuie sur le bouton sauvegarder
    @IBAction func saveInformation(_ sender: UIButton)
    {
        if name.text == "" || phone.text == "" || email.text == ""
        {
            alert("Veuillez ne pas laisser aucun champ vide...")
            return
        }
        
        if !checkMediaSelection()
        {
            alert("Veuillez nous indiquer comment vous avez entendu parler de nous...")
            return
        }
        
        let progs = manageSelectedPrograms()
        
        let stringToSend = "name=\(name.text!)&phone=\(phone.text!)&email=\(email.text!)&how=\(pickerChoice)&progs=\(progs)"
        //jsonManager.upload(stringToSend, urlForAdding: "http://localhost/xampp/geneau/ig_po/php/add.php")
        jsonManager.upload(stringToSend, urlForAdding: "http://www.igweb.tv/ig_po/php/add.php")
        clearFields()
        deselectAllButtons()
        resetAllMediaButtonAlphas()
        
        alert("Les données ont été sauvegardées...")
    }
    /* ---------------------------------------*/
    //--- Message d'alerte si les données ont bien été sauvegardés
    func alert(_ theMessage: String)
    {
        let refreshAlert = UIAlertController(title: "Message...", message: theMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        refreshAlert.addAction(OKAction)
        present(refreshAlert, animated: true){}
    }
    /* ---------------------------------------*/
    //--- Réinitialise les données entrées par l'utilisateur
    func clearFields()
    {
        name.text = ""
        phone.text = ""
        email.text = ""
    }
    /* ---------------------------------------*/
    //--- Permet de cacher le clavier lorsqu'on appuie sur "done"
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    /* ---------------------------------------*/
    //--- Lorsqu'on choisi un media
    @IBAction func mediaButtons(_ sender: UIButton)
    {
        resetAllMediaButtonAlphas()
        
        pickerChoice = (sender.titleLabel?.text)!
        
        if sender.alpha == 0.5
        {
            sender.alpha = 1.0
        }
        else
        {
            sender.alpha = 0.5
        }
    }
    /* ---------------------------------------*/
    //--- Réinitialise les boutons media
    func resetAllMediaButtonAlphas()
    {
        for index in 0 ..< arrMediaButtons.count
        {
            arrMediaButtons[index].alpha = 0.5
        }
    }
    /* ---------------------------------------*/
    //--- vérifie si l'utilisateur a bien choisi un media
    func checkMediaSelection() -> Bool
    {
        var chosen = false
        
        for index in 0 ..< arrMediaButtons.count
        {
            if arrMediaButtons[index].alpha == 1.0
            {
                chosen = true
                break
            }
        }
        
        return chosen
    }
    /* ---------------------------------------*/
}
//=================================












