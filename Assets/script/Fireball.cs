using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fireball : MonoBehaviour
{
    public float speed;
    float movespeed;

    float distance=0;

    Vector3 destination;

    public GameObject player;

    Vector3 startpos;

    public float timer;

    Transform previousTransform;

    // Start is called before the first frame update
    void Start()
    {

        transform.position = player.transform.position+Vector3.up;
        startpos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        distance += speed/2*Time.deltaTime;


        //move forward
        transform.position = Vector3.MoveTowards(transform.position, startpos, -speed * Time.deltaTime);

        //move towards aiming point
        movespeed = 5+Vector3.Distance(transform.position,player.transform.position)/3;
        destination = startpos + Camera.main.transform.forward * distance;
        transform.position = Vector3.MoveTowards(transform.position, destination, movespeed * Time.deltaTime);

        timer -= Time.deltaTime;

        if (timer <= 0)
        {
            Destroy(gameObject);
        }

        
    }


    private void OnTriggerEnter(Collider other)
    {

        if(other.gameObject.transform.name!="Player")
        Destroy(gameObject);
    }

}
