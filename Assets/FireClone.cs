using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireClone : MonoBehaviour
{

    public float speed;


    [HideInInspector]
    public Vector3 direction;

    CharacterController controller;

    public GameObject player;


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
    }
}
