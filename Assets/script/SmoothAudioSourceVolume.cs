using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SmoothAudioSourceVolume : MonoBehaviour
{
    public AudioSource audioSource;
    public float speed;

    [Range(0,1)] float volume;
    float maxVolume;
    bool soundIsChanging;

    float x;

    GameObject mainCam;

    void Start()
    {
        volume = audioSource.volume;
        maxVolume = volume;
        x = -1;
        mainCam = GameObject.Find("Main Camera");
    }

    void Update()
    {
        if(soundIsChanging)
        {
            x += Time.deltaTime * speed;
            volume = x * x;            

            if(volume >= maxVolume)
            {
                soundIsChanging = false;
                audioSource.volume = maxVolume;
            }
            else
            {
                audioSource.volume = volume;
            }
        }
    }

    public void SmoothVolume()
    {
        x = -1;
        soundIsChanging = true;
    }

    public void SwitchToBiome1()
    {
        mainCam.GetComponent<FMODParametersValue>().SwitchToBiome1();
    }
    public void SwitchToBiome2()
    {
        mainCam.GetComponent<FMODParametersValue>().SwitchToBiome2();
    }
}
