using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyCloseAttack : MonoBehaviour
{
    GameObject player;

    bool isAttacking;

    // PREVISUALISATION TO REMOVE !!
    public MeshRenderer attackZone;

    public float attackDelay;
    float timer =0;

    public float enemyRange ;
    public float damage;

    bool playerDead;


    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        playerDead = player.GetComponent<PlayerController>().isDead;

        Vector3 direction = (player.transform.position - transform.position).normalized;
        Vector3 endLine = transform.position + direction * 3;
        Debug.DrawLine(transform.position, endLine, Color.red);

        isAttacking = GetComponent<EnemyFollower>().isAttacking;

        if(isAttacking == true && playerDead == false)
        {
            

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
                
                DoNotAttack();
            }
        }
        else
        {
            
            DoNotAttack();
            timer = 0f;

        }

        

    }

    void CloseAttack()
    {
        

        if(Vector3.Distance(transform.position,player.transform.position) < enemyRange)
        {
            
            player.GetComponent<PlayerController>().life -= damage;

            // PREVISUALISATION TO REMOVE !!
            attackZone.enabled = true;
        }

        
        

    }

    void DoNotAttack()
    {
        // PREVISUALISATION TO REMOVE !!
        attackZone.enabled = false;
        
    }

   
}
