using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnerAttractedObject : MonoBehaviour
{
    public GameObject attractedObject;
    public Transform spawnLocation;
    GameObject go;

    // Start is called before the first frame update
    void Start()
    {
        go = Instantiate(attractedObject, spawnLocation.position, Quaternion.identity);
    }

   

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Aura")
        {
            Destroy(go);
            go = Instantiate(attractedObject, spawnLocation.position, Quaternion.identity);
        }
    }
}
