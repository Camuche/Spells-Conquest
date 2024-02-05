using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetPlayerAsChildObject : MonoBehaviour
{
    public Transform parentGO;

    void OnTriggerEnter(Collider other)
    {
        if (other.name == "Player")
        {
            other.transform.parent = parentGO;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.name == "Player")
        {
            other.transform.parent = null;
        }
    }
}
