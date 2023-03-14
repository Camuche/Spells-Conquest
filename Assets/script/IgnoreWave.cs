using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class IgnoreWave : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (GameObject.Find("Wave(Clone)") != null)
        {
            Physics.IgnoreCollision(gameObject.GetComponent<CapsuleCollider>(), GameObject.Find("Wave(Clone)").GetComponent<BoxCollider>());
            Physics.IgnoreCollision(gameObject.GetComponent<CapsuleCollider>(), GameObject.Find("Wave(Clone)").GetComponentInChildren<BoxCollider>());
            Physics.IgnoreCollision(gameObject.GetComponent<CapsuleCollider>(), GameObject.Find("Wave(Clone)").GetComponent<CharacterController>());

        }
    }
}
