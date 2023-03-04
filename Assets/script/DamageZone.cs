using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageZone : MonoBehaviour
{
    public bool continuous;
    public float damage;
    public bool instaKill;
    [SerializeField] bool canDamageEnemies;

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
            

            if (other.gameObject.layer == LayerMask.NameToLayer("enemi") && canDamageEnemies)
            {

                

                other.GetComponent<EnemyLife>().life -= damage * Time.deltaTime;
                if (instaKill && damage > 0)
                {
                    other.GetComponent<EnemyLife>().life = 0;
                }
            }

            if (canDamageEnemies)
                print("enculmé");


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

        if (other.gameObject.layer == LayerMask.NameToLayer("enemi") && canDamageEnemies)
        {

            

            if (instaKill && damage > 0)
            {
                other.GetComponent<EnemyLife>().life = 0;
            }

            if (!continuous)
            {
                other.GetComponent<EnemyLife>().life -= damage;
            }
        }

        if(canDamageEnemies)
            print("abrutin");

    }



}
