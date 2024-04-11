using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FMODParametersValue : MonoBehaviour
{
    //USE IT TO ACCESS FMOD STUDIO EVENT EMITTER AND CHANGE VALUES
    private FMOD.Studio.EventInstance instance;

    public FMODUnity.EventReference fmodEvent;
    

    [SerializeField] [Range(0,100)] private float intensity;
    [SerializeField] [Range(0,100)] private float health;
    [SerializeField] [Range(0,1)] private float combat;


    void Start()
    {
        instance = FMODUnity.RuntimeManager.CreateInstance(fmodEvent);
        instance.start();
    }

    void Update()
    {
        if(PlayerController.instance.enemyTriggered > 0)
        {
            combat = 1;
        }
        else
        {
            combat = 0;
        }

        health = PlayerController.instance.life;

        instance.setParameterByName("Intensity", intensity);
        instance.setParameterByName("Health", health);
        instance.setParameterByName("Combat", combat);
    }
}
