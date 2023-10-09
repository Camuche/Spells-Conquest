using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireClone : MonoBehaviour
{
    [SerializeField] Material matLave;
    public Material fireShieldMat;
    

    public float speed;
    public float timer;

    [SerializeField]float grav;
    float ySpeed=0;


    [HideInInspector]
    public Vector3 direction;

    [HideInInspector]
    public GameObject player;

    CharacterController controller;

    public float breakingShieldFeedbackTime;



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
            matLave.SetVector("_SpherePosition", new Vector4(0, 9999999999999, 0, 0));
            transform.position = new Vector3(100000, -100000, 100000);
            Destroy(gameObject,0.1f);
        }
        else if (timer <= breakingShieldFeedbackTime)
        {
            fireShieldMat.SetFloat("_Opacity", 0.2f);
        }
        else fireShieldMat.SetFloat("_Opacity", 0.4f);



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
