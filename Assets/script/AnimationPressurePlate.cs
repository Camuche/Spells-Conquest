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


    public GameObject rendererGameObject;
    public float speedRenderer;
    Vector3 targetRenderer;
    Vector3 posInitRenderer;

    // Start is called before the first frame update
    void Start()
    {
        posInit = obstacle.transform.position;

        posInitRenderer = rendererGameObject.transform.position;
        targetRenderer = new Vector3(rendererGameObject.transform.position.x, rendererGameObject.transform.position.y - (rendererGameObject.transform.localScale.y )+0.01f, rendererGameObject.transform.position.z);
    }

    // Update is called once per frame
    void Update()
    {
        if (isTrigger == true)
        {
            obstacle.transform.position = Vector3.MoveTowards(obstacle.transform.position, target.position, 0.01f * speed);
            rendererGameObject.transform.position = Vector3.MoveTowards(rendererGameObject.transform.position, targetRenderer , 0.01f* speedRenderer);
        }
        else
        {
            obstacle.transform.position = Vector3.MoveTowards(obstacle.transform.position, posInit, 0.01f * speed);
            rendererGameObject.transform.position = Vector3.MoveTowards(rendererGameObject.transform.position, posInitRenderer, 0.01f * speedRenderer);
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
