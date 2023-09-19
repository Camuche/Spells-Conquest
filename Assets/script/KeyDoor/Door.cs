using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{

    public GameObject doorMesh;

    public string keyNeededString;

    bool doorOpen = false;

    [HideInInspector]
    public bool hasKey = false;
    public Transform target;
    public float speed = 1;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (doorOpen == true)
        {
            doorMesh.transform.position = Vector3.MoveTowards(doorMesh.transform.position, target.transform.position, 0.01f * speed);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(doorOpen == false && other.tag == "Player")
        {
            if (hasKey == true)
            {
                doorOpen = true;
                //Destroy(DoorMesh);
                
            }
            else
            {
                //Debug.Log(keyNeededString);
            }
        }
    }

}
