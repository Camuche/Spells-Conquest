using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class EnemyDash : MonoBehaviour
{
    GameObject player;
    EnemyFollower enemyFollower;
    NavMeshAgent navMeshAgent;

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
        /*if(Vector3.Distance(player.transform.position, transform.position) < range);
        {
            Debug.Log("chaaarge");
        }*/
        
    }
}
