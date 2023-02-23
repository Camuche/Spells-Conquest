using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireProtectionStart : MonoBehaviour
{


    [SerializeField] Renderer fireProtection1;
    [SerializeField] Renderer fireProtection2;
    [SerializeField] Renderer fireProtection3;

    private float startFloat = -1;
    [SerializeField] float speed;

    private bool boolEnable = false;

    

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        
        if (boolEnable == true)
        {
            if (startFloat < 1)
            {
                startFloat += speed * Time.deltaTime;

            }
            else startFloat = 1;


            fireProtection1.material.SetFloat("_Start", startFloat);
            fireProtection2.material.SetFloat("_Start", startFloat);
            fireProtection3.material.SetFloat("_Start", startFloat);
        }
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Fireball" || other.tag == "FireShield")
        { 
            boolEnable = true;
            
        }
    }
}
