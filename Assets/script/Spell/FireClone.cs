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

    //float cloneDuration;
    public float pressVsHoldTime;
    //private bool touchHold = true;
    float holdTimer;

    bool isMoving = false;
    CastSpellNew castSpellNew;

    [SerializeField] float cooldownFireClone;



    // Start is called before the first frame update
    void Start()
    {
        direction = player.transform.right;

        transform.position = player.transform.position+player.transform.right;



        controller = GetComponent<CharacterController>();

        controller.enabled = false;
        controller.transform.position = transform.position;
        controller.enabled = true;

        castSpellNew = player.GetComponent<CastSpellNew>();
        isMoving = castSpellNew.isMoving; 

        
        castSpellNew.cooldownFireClone = cooldownFireClone;
        

    }

    // Update is called once per frame
    void Update()
    {

        
        

        timer -= Time.deltaTime;
        //holdTimer += Time.deltaTime;

        if (isMoving)
        {
            controller.Move(direction * speed * Time.deltaTime);
        }
        
        /*if(touchHold == true && holdTimer >= pressVsHoldTime)
        {
            isMoving = true;
        }

        if (Input.GetAxis("Fire") == 0 && !Input.GetMouseButton(0) && touchHold == true)
        {
            touchHold = false;
        }*/

        

        

        if (timer <= 0)
        {
            matLave.SetVector("_SpherePosition", new Vector4(0, 9999999999999, 0, 0));
            transform.position = new Vector3(100000, -100000, 100000);
            Destroy(gameObject,0.1f);
        }
        else if (timer <= breakingShieldFeedbackTime)                                     //PREVISUALISATION
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
