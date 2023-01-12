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

    Vector3 previousTransform;

    bool following = true;

    Vector3 dir;

    // Start is called before the first frame update
    void Start()
    {

        transform.position = player.transform.position+Vector3.up;

        previousTransform = transform.position;
        startpos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        distance += speed/2*Time.deltaTime;


        timer -= Time.deltaTime;

        

        if (following)
        {
            previousTransform = transform.position;

            //move forward
            transform.position = Vector3.MoveTowards(transform.position, startpos, -speed * Time.deltaTime);

            //move towards aiming point
            movespeed = 5 + Vector3.Distance(transform.position, player.transform.position) / 3;
            destination = startpos + Camera.main.transform.forward * distance;
            transform.position = Vector3.MoveTowards(transform.position, destination, movespeed * Time.deltaTime);


        }
        else
        {
            transform.position +=dir*speed*Time.deltaTime;
        }

        if (timer <= 0)
        {
            transform.position = new Vector3(666, -666, 666);
            Destroy(gameObject,0.1f);
        }

        print(Input.GetAxis("Fire"));

        if (Input.GetAxis("Fire") ==0 && !Input.GetMouseButton(0))
        {
            if (following) {
                
                dir = (transform.position - previousTransform).normalized;
                following = false;

            }
        }


    }


    private void OnTriggerEnter(Collider other)
    {

        if(other.gameObject.transform.name!="Player" && other.tag!="FireballTrigger" && !other.isTrigger)

        {
            transform.position = new Vector3(666, -666, 666);
            Destroy(gameObject, 0.1f);

        }
            

    }

}
