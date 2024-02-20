using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;


public class EnemyFollower : MonoBehaviour
{

    public float speed;
    GameObject player;
    CharacterController controller;

    public Vector3 dir;

    public float ySpeed;
    public float grav;
    public float followDistance;
    public float minDistance = 2f;
    public float rotationSpeed = 5f;

    NavMeshAgent navMeshAgent;

    
    public float attackDuration;
    bool isStun = false;
    public float stunDuration;
    float timer = 0;
    float stunTimer = 0f;

    [HideInInspector]
    public bool isAttacking = false;

    bool isAttracted = false;

    Rigidbody rb;

    


    // Start is called before the first frame update
    void Awake()
    {
        player = GameObject.Find("Player");
        controller = GetComponent<CharacterController>();

        navMeshAgent = GetComponent<NavMeshAgent>();

        _LayersToIgnore = LayerMask.GetMask("FireShield","enemi");
        LayersToIgnore = ~_LayersToIgnore;
        

    }

    void Start()
    {
        transform.parent = EnemyManager.instance.transform;
        rb = GetComponent<Rigidbody>();
    }

    LayerMask _LayersToIgnore;
    LayerMask LayersToIgnore;

    // Update is called once per frame
    void Update()
    {
        if (!navMeshAgent.enabled || !navMeshAgent.isOnNavMesh)
        {
            dir = (player.transform.position - transform.position).normalized;
            gameObject.transform.forward = dir;

            GetComponent<CharacterController>().enabled = true;

            //Vector3 closestPointOnMesh = 

            /*rb.isKinematic = false;
            rb.useGravity = true;
            rb.velocity= new Vector3 (rb.velocity.x , rb.velocity.y, rb.velocity.z);*/
            return;
        }
        else
        {
            GetComponent<CharacterController>().enabled = false;
        }
        

        if(isStun)
        {
            navMeshAgent.SetDestination(transform.position);
            stunTimer += Time.deltaTime;

            if(stunTimer >= stunDuration)
            {
                stunTimer = 0f;
                isStun = false;
            }

        }

        if (player != null && !isStun)
        {
            RaycastHit hit;
            bool isHit = Physics.Raycast(transform.position, (player.transform.position - transform.position).normalized, out hit, Mathf.Infinity, LayersToIgnore, QueryTriggerInteraction.Ignore);

            if (Vector3.Distance(player.transform.position, transform.position) > minDistance && isAttacking == false)
            {

                if (Vector3.Distance(player.transform.position, transform.position) < followDistance && isHit && (hit.transform.gameObject == player))
                {
                    dir = (player.transform.position - transform.position).normalized;

                    if (GetComponent<EnemyDash>() == null && navMeshAgent != null)
                    {
                        navMeshAgent.SetDestination(player.transform.position);
                        navMeshAgent.speed = speed;
                        //gameObject.transform.forward = dir;
                        gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, rotationSpeed * Time.deltaTime, 0.0f));
                    }
                }
                else dir = Vector3.zero;

            }
            else
            {

                if (isAttacking == false)
                {
                    isAttacking = true;
                    //Debug.Log("atta");
                }

                else
                {
                    if (Vector3.Distance(player.transform.position, transform.position) < followDistance && isHit && (hit.transform.gameObject == player) && ! isStun)
                    {
                        //Debug.Log("Stop");
                        if (GetComponent<EnemyDash>() == null && navMeshAgent != null)
                        {
                            navMeshAgent.SetDestination(transform.position);
                            gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, rotationSpeed * Time.deltaTime, 0.0f));

                        }


                        timer += Time.deltaTime;
                        if (timer >= attackDuration)
                        {
                            isAttacking = false;
                            timer = 0;
                        }
                    }

                }

                /*if (Vector3.Distance(player.transform.position, transform.position) < followDistance && isHit && (hit.transform.gameObject == player))
                {
                    //Debug.Log("Stop");
                    navMeshAgent.SetDestination(transform.position);
                    gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, rotationSpeed * Time.deltaTime, 0.0f));
                }*/
            }

            /*if (Vector3.Distance(player.transform.position, transform.position) < followDistance && isHit && (hit.transform.gameObject == player))
            {
                dir = (player.transform.position - transform.position).normalized;
                //controller.Move(dir * speed * Time.deltaTime);
                if (GetComponent<EnemyCharging>() == null && navMeshAgent!=null)
                {
                    navMeshAgent.SetDestination(player.transform.position);

                    navMeshAgent.speed = speed;
                }
            }
            else
            {
                dir = Vector3.zero;
            }*/


            //gravity
            //controller.Move(Vector3.up * ySpeed * Time.deltaTime);

            if (Physics.Raycast(transform.position - Vector3.up, -Vector3.up * 0.1f, 0.1f))
            {
                ySpeed = 0;
            }
            else
            {
                ySpeed -= grav * Time.deltaTime;
            }
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Fireball")
        {
            isStun = true;
        }
    }
}
