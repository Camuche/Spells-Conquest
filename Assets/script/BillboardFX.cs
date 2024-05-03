using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BillboardFX : MonoBehaviour
{

    Transform camTransform;
    //public bool yAxisOnly;
    

    

    void Start()
    {
        camTransform = GameObject.Find("Player").transform.Find("Main Camera").transform;
    }

    void Update()
    {
        
        if(camTransform != null)
        {
            
            
            transform.rotation = Quaternion.LookRotation(transform.position - camTransform.position);

            /*if(yAxisOnly)
            {
                //transform.rotation = Quaternion.LookRotation(transform.position - camTransform.position, Vector3.forward);
                
                //transform.rotation = Quaternion.Euler(transform.rotation.x, transform.rotation.y, transform.rotation.z);
                Quaternion myrotation = Quaternion.identity;
                myrotation.eulerAngles = new Vector3(-90, transform.rotation.y,0);
                transform.rotation = myrotation;
            }*/
            //transform.rotation = Quaternion.LookRotation(transform.position - camTransform.position);

            /*if(yAxisOnly)
            {
                transform.rotation = Quaternion.Euler(0 , transform.rotation.y, 0);
            }*/
            
        }
        //transform.rotation = Quaternion.LookRotation(transform.position - camTransform.position);
    }
}
