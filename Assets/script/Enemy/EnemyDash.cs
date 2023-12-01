using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyDash : MonoBehaviour
{
    GameObject player;
    EnemyFollower enemyFollower;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("player");
        enemyFollower = GetComponent<EnemyFollower>();
    }

    // Update is called once per frame
    void Update()
    {
        /*if(Vector3.Distance(player.transform.position, transform.position) < enemyFollower.followDistance);
        {
            Debug.Log("chaaarge");
        }*/
        
    }
}
