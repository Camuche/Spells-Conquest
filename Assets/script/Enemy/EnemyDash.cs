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
    Material  baseMat;
    public Material orange;
    public GameObject feedback;


    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        enemyFollower = GetComponent<EnemyFollower>();
        navMeshAgent = GetComponent<NavMeshAgent>();
        baseMat = GetComponent<Renderer>().material;
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
            GetComponent<Renderer>().material = orange;
            feedback.GetComponent<MeshRenderer>().enabled = true;

            Invoke("Dash", chargeAnimationTime);
        }  
    }

    public float dashspeedMultiplication, dashAccelerationMultiplication;

    Vector3 dashDest;
    void Dash()
    {
        navMeshAgent.speed *= dashspeedMultiplication;
        navMeshAgent.acceleration *= dashAccelerationMultiplication;
        gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, GetComponent<EnemyFollower>().rotationSpeed * Time.deltaTime, 0.0f));
        GetComponent<Renderer>().material = baseMat;
        feedback.GetComponent<MeshRenderer>().enabled = false;


        for (int i=0; i < raycastIterations; i++)
        {
            RaycastHit hit;
            Physics.Raycast(transform.position + raycastDist * (i+1) * transform.forward, Vector3.down, out hit, Mathf.Infinity);

            if(hit.collider == null || hit.transform.gameObject.layer != LayerMask.NameToLayer("ground"))
            {
                return;
            }
            dashDest = hit.point;
        }
        navMeshAgent.SetDestination(dashDest);
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
        navMeshAgent.speed = speed;
        navMeshAgent.acceleration /= dashAccelerationMultiplication;
        rotate = false;
        isCharging = false;
    }
}
