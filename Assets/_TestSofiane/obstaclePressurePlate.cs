using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class obstaclePressurePlate : MonoBehaviour
{
    [SerializeField] GameObject trigger;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "IceExplosion")
        {
            trigger.GetComponent<AnimationPressurePlate>().stopAnim = true;

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "IceExplosion")
        {
            trigger.GetComponent<AnimationPressurePlate>().stopAnim = false;
        }
    }
}
