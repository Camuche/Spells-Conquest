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


    void Start()
    {
        volume = audioSource.volume;
        maxVolume = volume;
        x = -1;
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
}
