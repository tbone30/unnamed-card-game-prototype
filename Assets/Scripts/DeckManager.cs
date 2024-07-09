using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using tbone;

public class DeckManager : MonoBehaviour
{
    public List<Card> allCards = new List<Card>(); //List of all cards in the deck
    private int currentIndex = 0; //Index of the current location in the deck

    void Start()
    {
        //Load all card assets from the Resources folder
        Card[] cards = Resources.LoadAll<Card>("Cards");
        print(cards.Length);
        //Add the loaded cards to the allCards list
        allCards.AddRange(cards); 

        HandManager handManager = FindObjectOfType<HandManager>(); //Find the HandManager in the scene
        for(int i = 0; i<handManager.startingHandSize; i++) //draw starting hand
        {
            DrawCard(handManager);
        }
    }
    
    public void DrawCard(HandManager handManager)
    {
        if(allCards.Count == 0)
        {
            return;
        }
        
        Card nextCard = allCards[currentIndex]; //Get the next card in the deck
        handManager.AddCardToHand(nextCard); //Add the card to the hand
        currentIndex = (currentIndex + 1) % allCards.Count; //Increment the index and loop back to the start if necessary
    }
}
