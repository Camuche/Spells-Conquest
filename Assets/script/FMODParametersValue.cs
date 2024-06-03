using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FMODParametersValue : MonoBehaviour
{
    //USE IT TO ACCESS FMOD STUDIO EVENT EMITTER AND CHANGE VALUES
    private static FMOD.Studio.EventInstance instance;

    public FMODUnity.EventReference fmodEvent;

    public static bool isPlaying;

    [SerializeField] [Range(0, 1)] private float volume;

    [SerializeField] [Range(0,100)] private float intensity;
    [SerializeField] [Range(0,100)] private float health;
    [SerializeField] [Range(0,1)] private float combat;


    void Start()
    {
        if(!isPlaying)
        {
            instance = FMODUnity.RuntimeManager.CreateInstance(fmodEvent);
            instance.start();
            isPlaying = true;
            Debug.Log("instancefmod");
        }
        instance.setVolume(volume);
    }

    void Update()
    {       
        if(PlayerController.instance.enemyTriggered > 0)
        {
            combat = 1;
            //Debug.Log("CombatMode");
        }
        else
        {
            combat = 0;
            //Debug.Log("NoCombatMode");
        }

        health = PlayerController.instance.life;
        health = Mathf.Clamp(health, 0.1f, 100);

        instance.setParameterByName("Intensity", intensity);
        instance.setParameterByName("Health", health);
        //instance.setParameterByName("Combat", combat);
    }

    private void OnDestroy()
    {
        
    }
}
