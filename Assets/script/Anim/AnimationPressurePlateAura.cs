using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationPressurePlateAura : MonoBehaviour
{

    public Transform target;
    public GameObject obstacle;
    //Vector3 posInit;
    bool open;
    public float speed;

    // Start is called before the first frame update
    void Start()
    {
        //posInit = obstacle.transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        if (open == true)
        {
            obstacle.transform.position = Vector3.MoveTowards(obstacle.transform.position, target.position, 0.01f * speed);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Aura")
        {
            open = true;
        }
    }
}
