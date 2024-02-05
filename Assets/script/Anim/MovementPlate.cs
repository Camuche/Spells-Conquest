using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MovementPlate : MonoBehaviour
{
    //float sinMove;
    Vector3 posInit;//, posTarget;
    public float speed, waitingTime;
    //float timer;
    bool canMove = true;
    public Transform target;
    bool goForward = true , isWaiting;


    // Start is called before the first frame update
    void Start()
    {
        posInit = transform.position;
        //posTarget = target.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        
        if(canMove && goForward && !isWaiting)
        {
            transform.position = Vector3.MoveTowards(transform.position, target.position , 0.01f * speed);

            if(transform.position == target.position)
            {
                isWaiting = true;
                Invoke("StopWaiting", waitingTime);
            }
        }
        else if (canMove && !goForward && !isWaiting)
        {
            transform.position = Vector3.MoveTowards(transform.position, posInit , 0.01f * speed);

            if(transform.position == posInit)
            {
                isWaiting = true;
                Invoke("StopWaiting", waitingTime);
            }
        }
    }

    void StopWaiting()
    {
        isWaiting = false;

        if(goForward)
        {
            goForward = false;
        }
        else
        {
            goForward = true;
        }
    }



    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "IceExplosion")
        {
            canMove = false;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "IceExplosion")
        {
            canMove = true;
        }
    }
    
}
