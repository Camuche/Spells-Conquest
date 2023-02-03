using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyFollower : MonoBehaviour
{

    public float speed;
    GameObject player;
    CharacterController controller;

    public Vector3 dir;

    public float ySpeed;
    public float grav;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        controller = GetComponent<CharacterController>();
    }

    // Update is called once per frame
    void Update()
    {

        if (player != null)
        {

            if (Vector3.Distance(player.transform.position, transform.position) < 30)
            {
                dir = (player.transform.position - transform.position).normalized;
                controller.Move(dir * speed * Time.deltaTime);
            }


            //gravity
            controller.Move(Vector3.up * ySpeed * Time.deltaTime);

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
