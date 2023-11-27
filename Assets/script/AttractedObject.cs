using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttractedObject : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        transform.parent = AttractedObjectManager.instance.transform;
    }

    
}
