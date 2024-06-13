using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FMODParametersValue : MonoBehaviour
{
    //USE IT TO ACCESS FMOD STUDIO EVENT EMITTER AND CHANGE VALUES
    [HideInInspector] public static FMOD.Studio.EventInstance instance;

    public FMODUnity.EventReference fmodEvent;

    public static bool isPlaying;

    [SerializeField] [Range(0, 1)] private float volume;
    [SerializeField] [Range(0,100)] private float health;
    [SerializeField] [Range(0,1)] private float combat;

    float time;
    public bool soundIsChanging;

    public float speed;


    void Start()
    {
        if(!isPlaying)
        {
            instance = FMODUnity.RuntimeManager.CreateInstance(fmodEvent);
            instance.start();
            isPlaying = true;
        }
        instance.setVolume(volume);
    }

    void Update()
    {
        if (PlayerController.instance.enemyTriggered > 0)
        {
            combat = 1;
        }
        else
        {
            combat = 0;
        }

        health = PlayerController.instance.life;
        health = Mathf.Clamp(health, 0.1f, 100);

        

        if (soundIsChanging)
        {
            float previousTime = time;

            time += Time.deltaTime * speed;
            volume = time * time;

            if (volume >= 1)
            {
                soundIsChanging = false;
                volume = 1;
            }

            if (previousTime <= 0 && time >= 0)
            {
                ResetInstance();
            }
        }


        instance.setParameterByName("Health", health);
        instance.setParameterByName("Combat", combat);
        instance.setVolume(volume);
    }

    public void SwitchToBiome1()
    {
        time = -1;
        soundIsChanging = true;
        fmodEvent = FMODUnity.EventReference.Find("event:/B1");
    }
    public void SwitchToBiome2()
    {
        time = -1;
        soundIsChanging = true;
        fmodEvent = FMODUnity.EventReference.Find("event:/B2");
    }

    void ResetInstance()
    {
        instance.release();
        instance.stop(FMOD.Studio.STOP_MODE.IMMEDIATE);

        instance = FMODUnity.RuntimeManager.CreateInstance(fmodEvent);
        instance.start();
    }
}
