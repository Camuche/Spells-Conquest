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
    float timer = 0;

    [HideInInspector]
    public bool isAttacking = false;




    // Start is called before the first frame update
    void Awake()
    {
        player = GameObject.Find("Player");
        controller = GetComponent<CharacterController>();

        navMeshAgent = GetComponent<NavMeshAgent>();

        _LayersToIgnore = LayerMask.GetMask("FireShield","enemi");
        LayersToIgnore = ~_LayersToIgnore;
        

    }

    LayerMask _LayersToIgnore;
    LayerMask LayersToIgnore;

    // Update is called once per frame
    void Update()
    {


        if (player != null)
        {
            RaycastHit hit;
            bool isHit = Physics.Raycast(transform.position, (player.transform.position - transform.position).normalized, out hit, Mathf.Infinity, LayersToIgnore, QueryTriggerInteraction.Ignore);

            if (Vector3.Distance(player.transform.position, transform.position) > minDistance && isAttacking == false)
            {

                if (Vector3.Distance(player.transform.position, transform.position) < followDistance && isHit && (hit.transform.gameObject == player))
                {
                    dir = (player.transform.position - transform.position).normalized;

                    if (GetComponent<EnemyCharging>() == null && navMeshAgent != null)
                    {
                        navMeshAgent.SetDestination(player.transform.position);
                        navMeshAgent.speed = speed;
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
                    if (Vector3.Distance(player.transform.position, transform.position) < followDistance && isHit && (hit.transform.gameObject == player))
                    {
                        //Debug.Log("Stop");
                        navMeshAgent.SetDestination(transform.position);
                        gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, rotationSpeed * Time.deltaTime, 0.0f));

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
}
