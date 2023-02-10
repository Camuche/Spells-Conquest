using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationPressurePlate : MonoBehaviour
{
    
    public Transform target;
    public GameObject obstacle;

    private Vector3 posInit;
    public float speed;
    bool isTrigger = false;

    // Start is called before the first frame update
    void Start()
    {
        posInit = obstacle.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        if (isTrigger == true)
        {
            obstacle.transform.position = Vector3.MoveTowards(obstacle.transform.position, target.position, 0.01f * speed);
        }
        else
        {
            obstacle.transform.position = Vector3.MoveTowards(obstacle.transform.position, posInit, 0.01f * speed);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        isTrigger = true;
    }

    private void OnTriggerExit(Collider other)
    {
        isTrigger = false;
    }
}
