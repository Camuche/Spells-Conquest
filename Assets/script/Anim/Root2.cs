using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Root2 : MonoBehaviour
{
    [SerializeField] Renderer root;

    private float startFloat = 1;
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
            if (startFloat > 0)
            {
                startFloat -= speed * Time.deltaTime;

            }
            else startFloat = 0;

            
            
        }

       

        root.material.SetFloat("_Dissolve", startFloat);
        

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Fireball")
        {
            boolEnable = true;

        }
    }
}
