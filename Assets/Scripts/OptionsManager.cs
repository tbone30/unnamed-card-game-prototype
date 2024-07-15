using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OptionsManager : MonoBehaviour
{
    public bool muteAudio = false;

    private AudioManager AudioManager;

    void Start()
    {
        AudioManager = GameManager.Instance.AudioManager;
    }

    void Update()
    {
        
    }
}
