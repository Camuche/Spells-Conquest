using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BillboardFX : MonoBehaviour
{

    Transform camTransform;

    

    void Start()
    {
        camTransform = GameObject.Find("Player").transform.Find("Main Camera").transform; //Camera.main.transform;
    }

    void Update()
    {
        if(camTransform != null)
        {
            transform.rotation = Quaternion.LookRotation(transform.position - camTransform.position);
        }
        //transform.rotation = Quaternion.LookRotation(transform.position - camTransform.position);
    }
}
