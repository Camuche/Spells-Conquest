using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class EnemyDash : MonoBehaviour
{
    GameObject player;
    EnemyFollower enemyFollower;
    NavMeshAgent navMeshAgent;
    public float speed, dashRange;
    bool isCharging;
    public float chargeAnimationTime;
    public int raycastIterations, raycastDist;

    [SerializeField] float range;
    bool rotate;


    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        enemyFollower = GetComponent<EnemyFollower>();
        navMeshAgent = GetComponent<NavMeshAgent>();
    }

    // Update is called once per frame
    void Update()
    {
        if (rotate == true)
        {
            gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, GetComponent<EnemyFollower>().rotationSpeed * Time.deltaTime, 0.0f));
        }

        if (Vector3.Distance(player.transform.position, transform.position) <= range && Vector3.Distance(player.transform.position, transform.position) >= dashRange && !isCharging)// && hit.GameObject.tag == "Player")
        {   
            RaycastHit hit;
            Physics.Raycast(player.transform.position,(transform.position - player.transform.position).normalized, out hit,range);
            if(hit.collider == gameObject.GetComponent<Collider>() && navMeshAgent != null)
            {
                Debug.Log("Walk");
                // DOIT AVANCER JUSQU'A UNE CERTAINE RANGE , EN DESSOUS, CHARGE
                navMeshAgent.SetDestination(player.transform.position);
                navMeshAgent.speed = speed;
                gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, GetComponent<EnemyFollower>().rotationSpeed * Time.deltaTime, 0.0f));
            }
            //Debug.DrawLine(Vector3.Distance(player.transform.position, transform.position) <= range && Physics.Raycast(transform.position,(player.transform.position - transform.position).normalized, out hit, range));
        }
        else if(Vector3.Distance(player.transform.position, transform.position) <= dashRange && !isCharging)
        { //DO ONCE
            navMeshAgent.SetDestination(transform.position);
            isCharging = true;
            gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, GetComponent<EnemyFollower>().rotationSpeed * Time.deltaTime, 0.0f));

            //Make animations
            /*for (int i=0; i < raycastIterations; i++)
            {
                RaycastHit hit;
                Physics.Raycast(transform.position + raycastDist * i * Vector3.forward, Vector3.down, out hit, Mathf.Infinity);
                //Instantiate(cylinder, hit.point.transform);
                navMeshAgent.SetDestination(hit.point);
            }*/
            Invoke("Dash", chargeAnimationTime);
        }  
    }

    public float dashspeedMultiplication;

    Vector3 dashDest;
    void Dash()
    {
        Debug.Log("CHAARGE");
        navMeshAgent.speed *= dashspeedMultiplication;
        //navMeshAgent.acceleration = 100;
        gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, GetComponent<EnemyFollower>().rotationSpeed * Time.deltaTime, 0.0f));
        for (int i=0; i < raycastIterations; i++)
        {
            RaycastHit hit;
            Physics.Raycast(transform.position + raycastDist * (i+1) * transform.forward, Vector3.down, out hit, Mathf.Infinity);
            //Instantiate(cylinder, hit.transform);
            //Debug.Log(hit.collider);
            //Debug.Log(hit.transform.gameObject.layer);
            //Debug.Log(LayerMask.NameToLayer("ground"));
            

            if(hit.collider == null || hit.transform.gameObject.layer != LayerMask.NameToLayer("ground"))
            {
                return;
            }
            dashDest = hit.point;
            //Debug.Log(i);
            //Debug.Log(hit.point);
            //Debug.Log(dashDest);
        }
        navMeshAgent.SetDestination(dashDest);//+Vector3.up);
        //navMeshAgent.speed *= dashspeedMultiplication;
        //Invoke("Decelerate", 0.2f);
        Invoke("Rotate", timeStuck);
    }

    public float timeStuck;

    void Rotate()
    {
        rotate = true;
        Invoke("StopBeingStuck", 1);
    }
    void StopBeingStuck()
    {
        //navMeshAgent.acceleration = 16;
        //gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, GetComponent<EnemyFollower>().rotationSpeed * Time.deltaTime, 0.0f));
        rotate = false;
        isCharging = false;
    }

    /*void Decelerate()
    {
        navMeshAgent.acceleration = 16;
    }*/
}
