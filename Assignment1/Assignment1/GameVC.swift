//
//  GameViewController.swift
//  Assignment1
//
//  Created by Moldovan, Eusebiu on 10/11/2022.
//

import UIKit

    var totalPointsGO = 0       //Global variable as it will used in the game over scene, and keeps track of total score


class GameVC: UIViewController {

    //UIElements whose tet is change throughout this viewcontroller
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var shownPhrase: UILabel!
    
    @IBOutlet weak var inputPhrase: UITextField!

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var LivesLabel: UILabel!
    
    
    var displayPhraseArray = [Character]()                      //Use this to store and change the phrase that will be shown to the player
    var displayPhraseWord = ""                                  //This is the phrase that will be printed
    var chosenPhraseWord = ""                                   //Variable will store a randomlyselected phrase from the JSON files
    var chosenPhraseArray: [Character] = []                     //Keeps the chosen phrase as an array of characters making it easier tocompare to guesses and hidden phrase
    var usedLetters = [Character]()                             //keeps track of the letters you guessed
    var totalLives = 10                                         //Keep track of how many lives you haave left for the game
    var pointMultipliers = [Int](arrayLiteral: 1,2,5,10,20)     //An array of the possible scores (points per letter)
    var letterCount = 0                                         //Max points for a phrase,so that the user can guess it first try
    var scorePL = 0                                             //Global variable for score per letter guessed
    var totalPoints = 0                                         //Keps track of points gained
    var over = false                                            //Determines if the game is over
    
    //Function alreay provided
    func getFilesInBundleFolder(named fileOrFolderName:String,
    withExt: String) -> [URL] {
            var fileURLs = [URL]() //the retrieved file-based URLs will be placed here
            let path = Bundle.main.url(forResource: fileOrFolderName,
    withExtension: withExt)
            //get the URL of the item from the Bundle (in this case a folder
            //whose name was passed as an argument to this function)
            do {// Get the directory contents urls (including subfolders urls)
                fileURLs = try FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: nil, options: [])
            } catch {
                print(error.localizedDescription)
            }
            return fileURLs
        }
        
        func getJSONDataIntoArray() -> ([String],String) {
            var theGamePhrases = [String]() //empty array which will evenutally hold our phrases
            //and which we will use to return as part of the result of this function.
            var theGameGenre = ""
            //get the URL of one of the JSON files from the JSONdatafiles folder, at random
            let aDataFile = getFilesInBundleFolder(named:"JSONdatafiles",withExt: "").randomElement()
            do {
                let theData = try Data(contentsOf: aDataFile!) //get the contents of that file as data
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: theData,options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    let theTopicData = (jsonResult as? NSDictionary)
                    let gameGenre = theTopicData!["genre"] as! String
                    theGameGenre = gameGenre //copied so we can see the var outside of this block
                    let tempArray = theTopicData!["list"]
                    let gamePhrases = tempArray as! [String]
                                    //compiler complains if we just try to assign this String array to a standard Swift one
                                    //so instead, we extract individual strings and add them to our larger scope var
                                for aPhrase in gamePhrases { //done so we can see the var outside of this block
                                        theGamePhrases.append(aPhrase)
                                    }
                                } catch {
                                    print("couldn't decode JSON data")
                                }
                            } catch {
                                print("couldn't retrieve data from JSON file")
                            }
                            return (theGamePhrases,theGameGenre) //tuple composed of Array of phrase Strings and genre
                        }
    
    
    func joinArray(arrayChar1: [Character]) -> String{                  //This is a function that joins an array of characters into a string as the .joined function seems to ork only on strings
        
        var tempString = ""                                             //Variable will be returned once each element of the array is added to it
        for i in 0...arrayChar1.count-1{                                //Loops through the array in order to reach each element
            tempString.insert(arrayChar1[i], at:tempString.endIndex)    //Inserts the element of the array at the end of the string
        }
        return tempString                                               //Returns the string which is justa string format of the array parameter
    }
    
    func revealLetter(arrayChar2: [Character], char: Character) -> String{  //This function will replace a hidden letter with the actual answer, adding points in the process
        var tempString = ""                         //Temporary string made to hold the data to be returned
        var tempArrayChar = arrayChar2              //We make another array, similar to the parameter we have (parameter elements cannot be changed)
        for i in 0..<arrayChar2.count{              //Loops through the array in order to reach each element
            if char == chosenPhraseArray[i]{        //Checks if 'char' was found in the array at specific index 'i'
                usedLetters += String(char)         //We add this letter to the string of used letters. Even if it appears multiple times, it is fine, rather than using more computational power
                totalPoints += scorePL              //We add the point per letter, to the total score.
                letterCount -= 1                    //We keep track of how manyletters are left to guess
                tempArrayChar[i] = char             //We change the element in the cahracter array to the character we checked for
            }
        }
        scoreLabel.text = "Score:    "+String(totalPoints)      //We print out the score after all the letters for that one guess have been revealed
        displayPhraseArray = tempArrayChar                      //Display phrase is now the array we worked with as our array has revealed letters
        tempString = joinArray(arrayChar1: tempArrayChar)       //We use the joinArray function to make the array of letters into a string
        return tempString                                       //We then return this string, to be used for printing to the user
    }
    
    func makeDisplayPhrase() -> String{        //This function creates the initial display phrase array
        displayPhraseArray = chosenPhraseArray                  //We make this array equal to the array with the revealed letters for now
        for i in 0...chosenPhraseWord.count-1{                  //We loop through the string/array (they have the same number of elements
            if chosenPhraseArray[i] == " "{                     //We check if the specific array element is a space
                displayPhraseArray[i] = " "                     //If it is, then we do the same to the array we will display
            } else {                                            //If the elemenet at 'i' is not space(so a letter)
                letterCount += 1                                //We keep track of how mnay letters there are in the phrase
                displayPhraseArray[i] = "🗅"                    //We then add 🗅 to the array instead of a letter
            }
        }
        return (joinArray(arrayChar1: displayPhraseArray))      //We return a joined string whose elements are the elements from the display array built up
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let (x, y) = getJSONDataIntoArray()                     //Gets data from the json files
        chosenPhraseWord = (x.randomElement()!.uppercased())    //Picks a random phrase and makes it upper case
        print("Current phrase: "+chosenPhraseWord)              //Print of the actual phrase of the console
        chosenPhraseArray = Array(chosenPhraseWord)             //Stores chosenPhraseWord as an array making it easier to manipulate
        
        print("Score multiplier: "+String(scorePL))             //I print this in the console for debugging and score checking
        displayPhraseWord = makeDisplayPhrase()                 //Generates the displaystring with hidden letters
        
        //Does necessary setup for the labels in the game scene
        shownPhrase.text = displayPhraseWord        //Shows the initial hidden phrase
        category.text = y                           //Changes the categorylabel to the actual category of the phrase
        LivesLabel.text = "Lives:   "+String(totalLives)
        
    }
    
    
    @IBAction func guessButton(_ sender: AnyObject) {           //Actions happen everytime the guess button is pressed
        
        let scorePerGuess = pointMultipliers.randomElement()    //This picks a random score that we willuse for each letter guessed
        scorePL = scorePerGuess!                                //We store this in scorePL to use it in the functions
        print("Score multiplier: "+String(scorePL))             //We print this to the console to track the scoresand how they change
        
        let guess = inputPhrase.text?.uppercased()              //We take in a guess made by the user,and we make sure it is uppercased
        inputPhrase.placeholder = "Enter you guess here..."     //We also change placeholder text to make sure it is back to its default message
        
        if over == true{                                                //This is done so that actual phrase can be shown before user is taken to the game over screen
            totalPointsGO = totalPoints                                 //We make totalPointsGO equal to totalPoints to use it in GameOverVC and display it to the user
            totalPoints = 0;                                            //We make totalPoints equal to 0 to be ready for the next game
            performSegue(withIdentifier: "toGameOver", sender: nil)     //We perform the seque in order to end the game, and move onto the end game screen
        } else if guess == chosenPhraseWord {                   //User might enter the full phrase,and the game shouldn't punish them for it. If the guess is correct the game ends
            totalPoints += letterCount * 20                     //Give them 20 points for each hidden letter they have revealed by guessing the phrase
            scoreLabel.text = "Score:    "+String(totalPoints)  //Show this score to the user
            displayPhraseWord = chosenPhraseWord                //Make displayWord equal to chosenWord in order to show the user the actual phrase after they have entered it
            sender.setTitle("FINISH", for: .normal)             //Change the button to a 'finish' button as the user has to click it again in order to move to the game over screen
            inputPhrase.placeholder = "Game over..."            //Placeholder text is also changed to 'Game over' to signal the player thatthe game has finished
            over = true                                         //Over can now be equalto true
        } else if displayPhraseWord == chosenPhraseWord || totalLives<=1{   //If they have guessed every letter or their lives have reached bellow 1, then the game ends
            displayPhraseWord = chosenPhraseWord                            //Display them the phrase that they were suppose to guess
            sender.setTitle("FINISH", for: .normal)                         //Make the guess button into a finish button as theyneed to press it again to continue
            inputPhrase.placeholder = "Game over..."                        //Tells them that the game is over
            over = true                                                     //Over is now true
        } else if guess!.count > 1 || guess!.count < 1{     //Narrows down the length of the guess as if it is not the full phrase, then the guess should only be one letter
            inputPhrase.placeholder = "One letter..."       //Tells the user they should only enter a sigle letter
            totalLives -= 1                                 //Decreases the amount of lives the user has as they made an incorrectinput
        } else if usedLetters.contains(guess!){
            inputPhrase.placeholder = "Guessed that before..."      //Tells the user that they have made thatguess before
            totalLives -= 1                                         //Decreases the amount of lives the user has as they made an incorrectinput
        } else if !chosenPhraseWord.contains(guess!) {
            inputPhrase.placeholder = "Wrong letter..."     //Tells the user that this letter is not part of the phrase
            usedLetters += String(guess!)                   //We add said letter to  the string of used letters to make sure the user doesn't enter it again
            totalLives -= 1                                 //Decreases the amount of lives the user has as they made an incorrectinput
        } else if guess!.count == 1 && !usedLetters.contains(guess!){                       //User enters one letter that has not been used before as a guess, and its taken into consideration if the guess is part of the phrase
            let guess1 = Character(inputPhrase.text!.capitalized)                           //We make this guess a character type
            displayPhraseWord = revealLetter(arrayChar2: displayPhraseArray, char: guess1)  //We process the letter through the function 'revealLetter' and make a new displayPhrase to show to the player
        }
        
        LivesLabel.text = "Lives:   "+String(totalLives)    //Lives are updated accordingly
        inputPhrase.text = ""                               //After guess is submitted, input field is cleared
        shownPhrase.text = displayPhraseWord                //The phrase the player sees is also updated
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
