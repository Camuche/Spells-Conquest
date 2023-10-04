using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyCloseAttack : MonoBehaviour
{
    public GameObject player;

    bool isAttacking;
    public GameObject attackZone;
    public float attackDelay;
    float timer =0;

    public float enemyRange ;
    public float damage;
    //public bool attack = false;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 direction = (player.transform.position - transform.position).normalized;
        Vector3 endLine = transform.position + direction * 3;
        Debug.DrawLine(transform.position, endLine, Color.red);

        isAttacking = GetComponent<EnemyFollower>().isAttacking;

        if(isAttacking == true)
        {
            //attackZone.GetComponent<MeshRenderer>().enabled = true;

            if (timer<attackDelay)
            {
                timer += Time.deltaTime;
                if(timer>=attackDelay)
                {
                    CloseAttack();
                    
                }

            }
            else
            {
                //CloseAttack();
                DoNotAttack();
            }
        }
        else
        {
            //attackZone.GetComponent<MeshRenderer>().enabled = false;
            DoNotAttack();
            timer = 0f;

        }

        

    }

    void CloseAttack()
    {
        

        if(Vector3.Distance(transform.position,player.transform.position) < enemyRange)
        {
            //Debug.Log("inrange");
            player.GetComponent<PlayerController>().life -= damage;
        }

        //attack = true;
        //Debug.Log("Closeattack");
        

    }

    void DoNotAttack()
    {
        
        //attack = false;
    }

   
}
