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

    NavMeshAgent navMeshAgent;

    


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

            if (Vector3.Distance(player.transform.position, transform.position) < followDistance && isHit && (hit.transform.gameObject == player))
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
                if (hit.transform != null)
                {
                    print(hit.transform.name);
                }
                dir = Vector3.zero;
            }


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
