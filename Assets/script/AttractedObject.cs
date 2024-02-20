using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttractedObject : MonoBehaviour
{
    CharacterController refCC;
    public bool useGravity = true;

    // Start is called before the first frame update
    void Start()
    {
        refCC = GetComponent<CharacterController>();

        transform.parent = AttractedObjectManager.instance.transform;
    }

    void Update()
    {
        if(refCC != null && useGravity)
        {
            refCC.Move(Physics.gravity * Time.deltaTime);
        }
    }
}
