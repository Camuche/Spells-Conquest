using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Laser : MonoBehaviour
{



    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        SetLength();
    }


    void SetLength()
    {
        RaycastHit hit;
        
        Physics.Raycast(transform.position, transform.forward, out hit, Mathf.Infinity,~0, QueryTriggerInteraction.Ignore);

        transform.localScale = new Vector3(1, 1, hit.collider==null?9999:(hit.distance+.2f));


    }
}
