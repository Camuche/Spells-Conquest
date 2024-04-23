using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyCloseAttack : MonoBehaviour
{
    GameObject player;

    bool isAttacking;

    public float attackDelay;
    float timer =0;

    public float enemyRange ;
    public float damage;

    bool playerDead;

    public AnimatorBasicEnemy animatorBasicEnemy;


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
        }
        else
        {
            timer = 0f;
        }
    }

    void CloseAttack()
    {
        animatorBasicEnemy.AttackAnimation();

        if(Vector3.Distance(transform.position,player.transform.position) < enemyRange)
        {
            player.GetComponent<PlayerController>().life -= damage;
        }
    }
}
