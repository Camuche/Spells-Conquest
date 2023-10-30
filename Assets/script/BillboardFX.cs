using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BillboardFX : MonoBehaviour
{

    Transform camTransform;

    

    void Start()
    {
        camTransform = Camera.main.transform;
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
