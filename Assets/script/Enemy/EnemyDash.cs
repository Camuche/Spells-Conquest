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

    [SerializeField] float range;

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
        if(Vector3.Distance(player.transform.position, transform.position) <= range && Vector3.Distance(player.transform.position, transform.position) >= dashRange && !isCharging)// && hit.GameObject.tag == "Player")
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
            Debug.Log("CHAARGE");
        }

        
        
    }
}
