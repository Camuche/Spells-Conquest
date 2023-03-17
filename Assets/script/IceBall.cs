using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IceBall : MonoBehaviour
{
    public float speed;
    float movespeed;

    float defalutSpeed;

    float distance = 0;
    Vector3 destination;
    public GameObject player;
    Vector3 startpos;
    public float timer;
    Vector3 previousTransform;
    bool following = true;
    Vector3 dir;
    float inispeed;
    float y_pos;

    [SerializeField] GameObject trace;
    private float spawnTimer =1;

    // Start is called before the first frame update
    void Start()
    {
        
        RaycastHit slopeHit;
        if (Physics.Raycast(transform.position + Vector3.up * 1, Vector3.down, out slopeHit, 999f, LayerMask.GetMask("Default")))
        {
            transform.position = new Vector3(transform.position.x, slopeHit.point.y, transform.position.z);
        }
        
        previousTransform = transform.position;
        startpos = transform.position;
        y_pos = startpos.y;

        defalutSpeed = speed;

    }

    // Update is called once per frame
    void Update()
    {

        spawnTimer -= speed / 2 * Time.deltaTime;

        if (spawnTimer <= 0)
        {
            GameObject t = Instantiate(trace);
            t.transform.position = transform.position;
            spawnTimer = 2;

            
            
        }


        


        distance += speed / 2 * Time.deltaTime;

        timer -= Time.deltaTime;

        Vector3 oldPos = transform.position;

        if (following)
        {
            previousTransform = transform.position;

            //move forward

            //startpos = transform.position;

            if (transform.position != startpos)
            {
                transform.position = Vector3.MoveTowards(transform.position, new Vector3(startpos.x,y_pos,startpos.z), -speed * Time.deltaTime);
            }

            //move towards aiming point
            movespeed = 5 + Vector3.Distance(transform.position, player.transform.position) / 3;

            destination = startpos + Camera.main.transform.forward * distance;
            destination = new Vector3(destination.x, y_pos, destination.z);

            RaycastHit hit;

            Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 999999);

            if (distance < Vector3.Distance(Camera.main.transform.position, transform.position) && hit.distance != 999999 && hit.distance!=0)
            {
                transform.position += transform.right * Time.deltaTime * -1 / (hit.distance / 10);
            }




            //movement
            transform.position = Vector3.MoveTowards(transform.position, destination, movespeed * Time.deltaTime);

            player.GetComponent<PlayerController>().speedscale = 0.2f;

        }
        else
        {

            if (player.GetComponent<PlayerController>().speedscale == 0.2f)
            {
                player.GetComponent<PlayerController>().speedscale = 1;
            }


            //movement
            previousTransform = transform.position;

            transform.position += dir * speed * Time.deltaTime;
        }

        //transform.rotation = Quaternion.LookRotation((oldPos - transform.position).normalized);

        //collide wall
        if(
            Physics.Raycast(previousTransform,(transform.position-previousTransform).normalized,speed) &&
            Physics.Raycast(previousTransform+Vector3.up, (transform.position + Vector3.up - previousTransform + Vector3.up).normalized, speed)
            )
        {
            Destroy(gameObject);
        }

        //detect slopes
        RaycastHit slopeHit;
        if (Physics.Raycast(transform.position + Vector3.up*.5f, Vector3.down,  out slopeHit, 999f, LayerMask.GetMask("Default","ground", "CollideOnlyWithIceBall")))
        {
            if (y_pos != slopeHit.point.y)
            {

                speed = defalutSpeed - Mathf.Abs(y_pos - slopeHit.point.y)*200;

                speed = Mathf.Clamp(speed, 1, Mathf.Infinity);

                y_pos = slopeHit.point.y;


                transform.position = new Vector3(transform.position.x, y_pos, transform.position.z);
            }
            else
            {
                speed = defalutSpeed;
            }
        }

        //timer end
        if (timer <= 0)
        {
            transform.position = new Vector3(666, -666, 666);
            Destroy(gameObject, 0.1f);
        }

        //detect lava
        int lava_mask = LayerMask.GetMask("lava");

        if (Physics.Raycast(transform.position + Vector3.up, Vector3.down, 1.1f,lava_mask))
        {
            transform.position = new Vector3(666, -666, 666);
            Destroy(gameObject, 0.1f);
        }

        


        if (Input.GetAxis("Fire") == 0 && !Input.GetMouseButton(0))
        {
            if (following)
            {

                dir = (transform.position - previousTransform).normalized;
                dir.y = 0;
                following = false;

            }
        }




    }


    private void OnTriggerStay(Collider other)
    {


        if (other.gameObject.transform.name != "Player" && !other.isTrigger)

        {
            //transform.position = new Vector3(666, -666, 666);
            //Destroy(gameObject, 0.1f);

        }


    }

    private void OnDestroy()
    {
        if (player.GetComponent<PlayerController>().speedscale == 0.2f)
        {
            player.GetComponent<PlayerController>().speedscale = 1;
        }
    }

}
