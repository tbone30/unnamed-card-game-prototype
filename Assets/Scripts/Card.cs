using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace tbone
{
    [CreateAssetMenu(fileName = "New Card", menuName = "Card")]

    public class Card: ScriptableObject
    {
        public string cardName;
        public List<CardType> cardType;
        public int health;
        public int damageMin;
        public int damageMax;
        public List<DamageType> damageType;
        public Sprite cardSprite;
        public enum CardType
        {
            Fire,
            Earth,
            Water,
            Dark,
            Light,
            Air
        }

        public enum DamageType
        {
            Fire,
            Earth,
            Water,
            Dark,
            Light,
            Air
        }
    }
}