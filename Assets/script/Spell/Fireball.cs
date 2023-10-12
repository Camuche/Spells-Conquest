using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fireball : MonoBehaviour
{
    public float speed;
    float movespeed;

    float distance = 0;

    Vector3 destination;

    public GameObject player;

    Vector3 startpos;

    public float timer;

    Vector3 previousTransform;

    bool following = true;

    Vector3 dir;

    float inispeed;

    //float holdTimer;
    //public float pressVsHoldTime;

    public float cooldown;
    //public float fastCooldown;
    

    // Start is called before the first frame update
    void Start()
    {
        transform.position = player.transform.position + Vector3.up;
        previousTransform = transform.position;
        startpos = transform.position;
        //holdTimer = 0f;
        //cooldownFireball = player.GetComponent<CastSpell>().cooldownFireball;
        
    }

    // Update is called once per frame

    [SerializeField] LayerMask aimingIgnore;
    void Update()
    {
        //holdTimer += Time.deltaTime;
        //Debug.Log(holdTimer);
        distance += speed / 2 * Time.deltaTime;


        timer -= Time.deltaTime;

        Vector3 oldPos = transform.position;

        if (following)
        {
            previousTransform = transform.position;
            player.GetComponent<CastSpell>().timerFireball = 0f;
            //move forward

            //startpos = transform.position;

            if (transform.position != startpos)
            {
                transform.position = Vector3.MoveTowards(transform.position, startpos, -speed * Time.deltaTime);
            }

            //move towards aiming point
            movespeed = 5 + Vector3.Distance(transform.position, player.transform.position) / 3;

            destination = startpos + Camera.main.transform.forward * distance;

            RaycastHit hit;



            Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 999999, ~aimingIgnore, QueryTriggerInteraction.Ignore);

            if (distance<Vector3.Distance(Camera.main.transform.position,transform.position) && hit.distance!=999999 && hit.distance !=0)
            {
                transform.position += (transform.right*Time.deltaTime*-1/(hit.distance/10))*(Vector3.Distance(Camera.main.transform.position,player.GetComponent<PlayerController>().CamStart.transform.position)/player.GetComponent<PlayerController>().CamDistance);
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
            transform.position += dir * speed * Time.deltaTime;
        }

        transform.rotation = Quaternion.LookRotation((oldPos - transform.position).normalized);


        if (timer <= 0)
        {
            transform.position = new Vector3(666, -666, 666);
            Destroy(gameObject, 0.1f);
        }


        if (Input.GetAxis("Fire") == 0 && !Input.GetMouseButton(0))
        {
            if (following)
            {

                dir = (transform.position - previousTransform).normalized;
                following = false;

                player.GetComponent<CastSpell>().cooldownFireball = cooldown;
                player.GetComponent<CastSpell>().timerFireball = 0f;

                /*if (holdTimer <= pressVsHoldTime)
                {
                    player.GetComponent<CastSpell>().cooldownFireball = fastCooldown;
                }
                else player.GetComponent<CastSpell>().cooldownFireball = cooldown;*/

            }

            
        }


    }


    private void OnTriggerEnter(Collider other)
    {

        if (other.gameObject.transform.name != "Player" && other.tag != "FireballTrigger" && !other.isTrigger)

        {
            transform.position = new Vector3(666, -666, 666);
            Destroy(gameObject, 0.1f);

        }


    }

    private void OnDestroy()
    {
        if (player !=null && player.GetComponent<PlayerController>().speedscale == 0.2f)
        {
            player.GetComponent<PlayerController>().speedscale = 1;
        }
    }

}
