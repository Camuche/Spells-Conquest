using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageZone : MonoBehaviour
{
    public bool continuous;
    public float damage;
    public bool instaKill;


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

        if (continuous)
        {
            if (other.name == "Player")
            {
                if (!other.GetComponent<PlayerController>().CheckShield())
                {
                    other.GetComponent<PlayerController>().life -= damage * Time.deltaTime;

                    if (instaKill && damage>0)
                    {
                        other.GetComponent<PlayerController>().life = 0;
                    }
                }
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {

        
        if (other.name == "Player")
        {

            if (!other.GetComponent<PlayerController>().CheckShield())
            {

                if (instaKill && damage > 0)
                {
                    other.GetComponent<PlayerController>().life = 0;
                }

                if (!continuous)
                {
                    other.GetComponent<PlayerController>().life -= damage;
                }
            }
        
        }

    }
}
