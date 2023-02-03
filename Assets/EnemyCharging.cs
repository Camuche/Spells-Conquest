using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyCharging : MonoBehaviour
{
    public float chargeSpeed;
    private float speed=0;
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


            charging();

            speed -= Time.deltaTime * chargeSpeed;
            speed = Mathf.Clamp(speed, 0, Mathf.Infinity);


            controller.Move(dir * speed * Time.deltaTime);



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


    [SerializeField] float ChargeDelay;
    float RemainingDelay = 0;
    private void charging()
    {
        RemainingDelay += Time.deltaTime;
        if (RemainingDelay >= ChargeDelay)
        {


            GameObject teleclone = GameObject.Find("TelekinesisClone(Clone)");
            if (teleclone == null)
            {
                dir = (player.transform.position - transform.position).normalized;
            }
            else
            {
                dir = (teleclone.transform.position - transform.position).normalized;

            }

            speed = chargeSpeed;

            RemainingDelay = 0;
        }
    }
}
