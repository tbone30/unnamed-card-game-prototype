using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using tbone;
using UnityEngine.UI;
using TMPro;

public class CardDisplay : MonoBehaviour
{
    public Card cardData;
    public Image cardImage;
    public TMP_Text nameText;
    public TMP_Text healthText;
    public TMP_Text damageText;
    public Image[] typeImages;
    private Color[] cardColors =
    {
        Color.red, //fire
        new Color(0.80f, 0.52f, 0.24f), //earth
        Color.blue, //water
        new Color(0.23f, 0.06f, 0.21f), //dark
        Color.yellow, //light
        Color.cyan //air
    };
    private Color[] typeColors =
    {
        Color.red, //fire
        new Color(0.80f, 0.52f, 0.24f), //earth
        Color.blue, //water
        new Color(0.47f, 0.00f, 0.40f), //dark
        Color.yellow, //light
        Color.cyan //air
    };

    void Start()
    {
        UpdateCardDisplay();    
    }

    public void UpdateCardDisplay()
    {
        //update card color based on first type
        cardImage.color = cardColors[(int)cardData.cardType[0]];

        nameText.text = cardData.cardName;
        healthText.text = cardData.health.ToString();
        damageText.text = $"{cardData.damageMin} - {cardData.damageMax}";

        //update type images
        for (int i = 0; i < typeImages.Length; i++)
        {
            if(i < cardData.cardType.Count)
            {
                typeImages[i].gameObject.SetActive(true);
                typeImages[i].color = typeColors[(int)cardData.cardType[i]];
            } else {
                typeImages[i].gameObject.SetActive(false);
            }
        }
    }
}
