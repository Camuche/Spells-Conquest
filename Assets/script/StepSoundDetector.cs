using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StepSoundDetector : MonoBehaviour
{
    public AudioEvent[] stepSounds;
    private int index;
    public AudioSource refSource;
    RaycastHit hit;
    public LayerMask groundMask;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Physics.Raycast(transform.position, Vector3.down, out hit, 100, groundMask, QueryTriggerInteraction.Ignore))
        {
            index = 0;
            
            switch (hit.collider.tag)
            {
                case "Rock": index = 0; break;
                case "Sand": index = 1; break;
            }
        }
    }

    public void PlayStepSound()
    {
        stepSounds[index].Play(refSource);
    }
}
