using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.Events;




public class EnemyCharging : MonoBehaviour
{
    public float chargeSpeed;
    [SerializeField]private float speed=0;
    GameObject player;
    CharacterController controller;

    NavMeshAgent navMeshAgent;

    public Vector3 dir;

    public float ySpeed;
    public float grav;


    bool touched = false;


    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        controller = GetComponent<CharacterController>();
        navMeshAgent = GetComponent<NavMeshAgent>();
    }

    // Update is called once per frame
    void Update()
    {

        if (player != null)
        {

            speed -= Time.deltaTime * chargeSpeed;


            if (Vector3.Distance(transform.position, player.transform.position) < GetComponent<EnemyFollower>().followDistance)
            {
                charging();


                //controller.Move(dir * speed * Time.deltaTime);
            }


            if (touched)
            {
                navMeshAgent.speed = 0;
                speed = 0;

                //transform.position -= speed * dir * Time.deltaTime;
                if (speed <= 0)
                {
                    setTouched(false);
                }
            }
            else
            {
                navMeshAgent.speed = speed;

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


    [SerializeField] float ChargeDelay;
    float RemainingDelay = 0;
    private void charging()
    {


        


        RemainingDelay += Time.deltaTime;


        if (RemainingDelay > ChargeDelay - 1)
        {
            if (speed >-1)
            {
                navMeshAgent.SetDestination(player.transform.position);
                dir = (player.transform.position - transform.position).normalized;
            }
            speed = Mathf.Clamp(speed, -5, Mathf.Infinity);
            transform.position += dir * speed * Time.deltaTime;
        }
        else
        {
            speed = Mathf.Clamp(speed, 0, Mathf.Infinity);
            



        }

        if (RemainingDelay >= ChargeDelay)
        {
            //dir = (player.transform.position - transform.position).normalized;
            //navMeshAgent.SetDestination(player.transform.position);

            speed = chargeSpeed;
            RemainingDelay = 0;
        }



    }



    public void setTouched(bool t)
    {
        print(t);
        touched = t;
    }


}
