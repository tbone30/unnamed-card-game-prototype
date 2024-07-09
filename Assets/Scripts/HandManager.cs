using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using tbone;

public class HandManager : MonoBehaviour
{
    public DeckManager deckManager; //Reference to the deck manager
    public GameObject cardPrefab; //Assign card prefab in inspector
    public Transform handTransform; //Root of the hand position
    public float fanSpread = -7.5f; //How spread out the hand is
    public float cardSpacing = 150f; //How much space is between cards
    public float verticalSpacing = 100f; //How much space is between cards
    public List<GameObject> cardsInHand = new List<GameObject>(); //Holds list of the card objects currently in hand
    public int maxHandSize = 10; //Maximum number of cards that can be held in hand
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void AddCardToHand(Card cardData)
    {
        //Do not add card if hand is full
        if(cardsInHand.Count >= maxHandSize)
        {
            return;
        }

        //Instantiate a new card object
        GameObject newCard = Instantiate(cardPrefab, handTransform.position, Quaternion.identity, handTransform);
        cardsInHand.Add(newCard); //Add the new card to the list of cards in hand

        //Set card data of instantiated card
        newCard.GetComponent<CardDisplay>().cardData = cardData;

        UpdateHandVisuals();
    }

    void Update()
    {
        UpdateHandVisuals();
    }

    private void UpdateHandVisuals()
    {
        int cardCount = cardsInHand.Count;

        if(cardCount == 1)
        {
            cardsInHand[0].transform.localRotation = Quaternion.Euler(0f, 0f, 0f);
            cardsInHand[0].transform.localPosition = new Vector3(0f, 0f, 0f);
            return;
        }

        for(int i = 0; i<cardCount; i++)
        {
            //Rotate the card around the z-axis to fan them out
            float rotationAngle = (fanSpread * (i - (cardCount - 1) / 2f));
            cardsInHand[i].transform.localRotation = Quaternion.Euler(0f, 0f, rotationAngle);

            float normalizedPosition = (2f * i / (cardCount - 1) - 1f); //Normalize card position between -1 and 1
            float horizontalOffset = (cardSpacing * (i - (cardCount - 1) / 2f)); //Spread the cards horizontally
            float verticalOffset = verticalSpacing * (1 - normalizedPosition * normalizedPosition); //Spread the cards vertically
            cardsInHand[i].transform.localPosition = new Vector3(horizontalOffset, verticalOffset, 0f);
        }
    }
}
