using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RecastAura : MonoBehaviour
{

    public GameObject auraGo;
    public bool isEnlightened;

    void OnTriggerEnter(Collider other)
    {
        if (!isEnlightened)
        {
            Instantiate(auraGo, transform.position, Quaternion.identity);

            isEnlightened = true;
        }
    }
}
