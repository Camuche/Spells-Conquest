using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyFlying : MonoBehaviour
{

    Vector3 newDir;


    [SerializeField] float speed;

    [SerializeField] float _timer;
    float timer;

    GameObject player;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        timer = _timer;
    }

    // Update is called once per frame
    void Update()
    {
        timer-=Time.deltaTime;

        

        if (timer <= 0)
        {
            SetNewDir(0);

            timer = _timer;
        }


        transform.position += newDir*speed*Time.deltaTime;


    }

    void SetNewDir(int iterations)
    {
        if (iterations >= 10)
        {
            newDir = Vector3.zero;
            return;
        }

        newDir = (player.transform.position - transform.position).normalized;

        newDir = Quaternion.Euler(Random.Range(-45, 45), Random.Range(-45, 45), Random.Range(-45, 45)) * newDir;

        if (Physics.Raycast(transform.position, newDir, speed * _timer, ~0, QueryTriggerInteraction.Ignore))
        {
            SetNewDir(iterations+1);
        }
    }
}
