using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireClone : MonoBehaviour
{

    public float speed;
    public float timer;


    [HideInInspector]
    public Vector3 direction;

    [HideInInspector]
    public GameObject player;

    CharacterController controller;



    // Start is called before the first frame update
    void Start()
    {
        direction = player.transform.right;

        transform.position = player.transform.position+player.transform.right;



        controller = GetComponent<CharacterController>();

        controller.enabled = false;
        controller.transform.position = transform.position;
        controller.enabled = true;
    }

    // Update is called once per frame
    void Update()
    {
        controller.Move(direction * speed *Time.deltaTime);

        timer -= Time.deltaTime;

        if (timer <= 0)
        {
            Destroy(gameObject);
        }
    }

    
}
