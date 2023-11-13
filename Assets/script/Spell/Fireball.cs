using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fireball : MonoBehaviour
{
    public float speed;
    float movespeed;

    GameObject shootAimPoint;
    float rayDistance;
    float distance = 0;

    Vector3 destination;

    public GameObject player;

    Vector3 startpos;

    public float timer;

    Vector3 previousTransform;

    bool following = true;

    Vector3 dir;

    float inispeed;

    //private Animator animator;

    //float holdTimer;
    //public float pressVsHoldTime;

    public float cooldown;
    [HideInInspector] public bool doNotFollow;
    //public float fastCooldown;
    CastSpellNew castSpellNewScript;
    

    // Start is called before the first frame update
    void Start()
    {
        //animator = player.GetComponent<CastSpell>().animator;

        /*if (player == null) 
        {
            Debug.LogError(this + " has no player!!!");
        }*/
        shootAimPoint = GameObject.Find("ShootAimPoint").gameObject;
        //Instantiate(gameObject, shootAimPoint.transform.position, shootAimPoint.transform.rotation) ;
        

        transform.position = player.transform.position + /*player.transform.right +*/ (Vector3.up * 0.5f) + (-player.transform.forward * 0.2f);
        previousTransform = transform.position;
        startpos = transform.position;
        //holdTimer = 0f;
        //cooldownFireball = player.GetComponent<CastSpell>().cooldownFireball;
        castSpellNewScript = player.GetComponent<CastSpellNew>();
        doNotFollow = castSpellNewScript.doNotFollow;
        //doNotFollow = true;
        
    }

    // Update is called once per frame

    [SerializeField] LayerMask aimingIgnore;
    void Update()
    {
        //doNotFollow = castSpellScript.doNotFollow;
        //holdTimer += Time.deltaTime;
        //Debug.Log(shootAimPoint.transform.position);
        
        
        distance += speed / 2 * Time.deltaTime;


        timer -= Time.deltaTime;

        Vector3 oldPos = transform.position;
        

        if (following)
        {
            player.GetComponent<CastSpellNew>().timerFireball = 0f;
            /*previousTransform = transform.position;
            player.GetComponent<CastSpellNew>().timerFireball = 0f;
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
            }*/



            dir = (shootAimPoint.transform.position - transform.position).normalized;

            //movement
            //transform.position = Vector3.MoveTowards(transform.position, destination, movespeed * Time.deltaTime);
            //transform.rotation = Quaternion.LookRotation((transform.position - shootAimPoint.transform.position).normalized);
            transform.position += dir * (speed/2) * Time.deltaTime;
            transform.rotation = Quaternion.LookRotation((transform.position - shootAimPoint.transform.position).normalized);
            //player.GetComponent<PlayerController>().speedscale = 0.2f;

            //transform.position = Vector3.MoveTowards(transform.position, shootAimPoint.transform.position, movespeed * Time.deltaTime);
            //transform.position += dir * speed * Time.deltaTime;

        }
        else
        {

            /*if (player.GetComponent<PlayerController>().speedscale == 0.2f)
            {
                player.GetComponent<PlayerController>().speedscale = 1;
            }*/


            //movement
            transform.position += dir * speed * Time.deltaTime;
            //transform.position = Vector3.MoveTowards(transform.position, shootAimPoint.transform.position, movespeed * Time.deltaTime);
        }

        //transform.rotation = Quaternion.LookRotation((transform.position - shootAimPoint.transform.position).normalized);        DIRECTION !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


        if (timer <= 0)
        {
            transform.position = new Vector3(666, -666, 666);
            //animator.SetBool("HoldSpell", false);
            Destroy(gameObject, 0.1f);
        }


        /*if (following)
            {

                dir = (transform.position - previousTransform).normalized;
                following = false;

                player.GetComponent<CastSpell>().cooldownFireball = cooldown;
                player.GetComponent<CastSpell>().timerFireball = 0f;

                if (holdTimer <= pressVsHoldTime)
                {
                    player.GetComponent<CastSpell>().cooldownFireball = fastCooldown;
                }
                else player.GetComponent<CastSpell>().cooldownFireball = cooldown;

            }*/
        if (doNotFollow)
        {
            if (following)
            {

                dir = (shootAimPoint.transform.position - transform.position).normalized;
                transform.rotation = Quaternion.LookRotation((transform.position - shootAimPoint.transform.position).normalized);
                following = false;

                player.GetComponent<CastSpellNew>().cooldownFireball = cooldown;                    //THIS DOES NOT WORK
                player.GetComponent<CastSpellNew>().timerFireball = 0f;

                //if (holdTimer <= pressVsHoldTime)
                {
                   // player.GetComponent<CastSpell>().cooldownFireball = fastCooldown;
                }
                //else player.GetComponent<CastSpell>().cooldownFireball = cooldown;

            }

            
        }

        if(!doNotFollow)
        {
            player.GetComponent<PlayerController>().speedscale = 0.2f;
            //animator.SetBool("HoldSpell", true);
            //Debug.Log(player.GetComponent<PlayerController>().speedscale);
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
        if (player !=null && player.GetComponent<PlayerController>().speedscale == 0.2f && !doNotFollow)
        {
            
            player.GetComponent<PlayerController>().speedscale = 1;
            //animator.SetBool("HoldSpell", false);
        }
    }

}
