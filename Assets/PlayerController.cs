﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public float mouseSensitivity;
    public float playerSpeed;
    float speed;
    float dodgespeed = 0;
    Vector3 newpos;

    public float grav = 1;
    public float jumpForce = 10;
    float ySpeed = 0;

    CharacterController Controller;

    // Start is called before the first frame update
    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;

        speed = playerSpeed;

        Controller = GetComponent<CharacterController>();


    }

    // Update is called once per frame
    void Update()
    {

        rotateCamera();
        rotatePlayer();
        movements();

        updateY();

        gravity();


    }



    float movementprecision=1f;
    void movements()
    {


        //dodge input
        if (Input.GetButtonDown("Dodge"))
        {
            if (dodgespeed == 0) {
                dodgespeed = 200;
            }
        }

        //dodge
        if (dodgespeed > 1.5)
        {
            dodgespeed /= 1.1f;
        }
        else
        {
            dodgespeed = 0;
        }


        //set speed

        if (Input.GetAxis("Vertical")==0 || Input.GetAxis("Horizontal") == 0)
        {
            speed = playerSpeed;
        }
        else
        {
            speed = playerSpeed * Mathf.Cos(45 * Mathf.PI / 180);
        }

        /*
        //vertical input

        //forward
        newpos = new Vector3(
        (Input.GetAxisRaw("Vertical") * (speed + dodgespeed) * Mathf.Cos(transform.eulerAngles.y * Mathf.PI / 180)),0,0) * Time.deltaTime;
        for (int i = 0; i < movementprecision; i++)
        {
            if (!RaycastRange(15, newpos / movementprecision))
            {
                transform.position += (newpos / movementprecision);
            }
        }

        //side
        newpos = new Vector3(0,0,(Input.GetAxisRaw("Vertical") * (speed + dodgespeed) * -Mathf.Sin(transform.eulerAngles.y * Mathf.PI / 180))) * Time.deltaTime;
        for (int i = 0; i < movementprecision; i++)
        {
            if (!RaycastRange(15, newpos / movementprecision))
            {
                transform.position += (newpos / movementprecision);
            }
        }


        //horizontal input

        //forward
        newpos = new Vector3((Input.GetAxisRaw("Horizontal") * (speed + dodgespeed) * -Mathf.Sin(transform.eulerAngles.y * Mathf.PI / 180)),0,0) * Time.deltaTime;


        for (int i = 0; i < movementprecision; i++)
        {
            if (!RaycastRange(15, newpos/ movementprecision))
            {
                transform.position += (newpos/ movementprecision);
            }
        }


        //side
        newpos = new Vector3(0,0,(Input.GetAxisRaw("Horizontal") * (speed + dodgespeed) * -Mathf.Cos(transform.eulerAngles.y * Mathf.PI / 180))) * Time.deltaTime;

        for (int i = 0; i < movementprecision; i++)
        {
            if (!RaycastRange(15, newpos / movementprecision))
            {
                transform.position += (newpos / movementprecision);
            }
        }
        */


        //newpos = new Vector3(Input.GetAxisRaw("Vertical") * (speed + dodgespeed), 0, 0) * Time.deltaTime;

        /*
        newpos = transform.right* Input.GetAxisRaw("Vertical") * (speed + dodgespeed) *Time.deltaTime;
        
        if (!RaycastRange(15, newpos))
        {
            transform.position += newpos;
        }

        newpos = transform.forward * Input.GetAxisRaw("Horizontal") * (speed + dodgespeed) * Time.deltaTime;

        if (!RaycastRange(15, newpos))
        {
            transform.position += newpos;
        }
        */

        Vector3 movedir = Vector3.zero;

        movedir += transform.right * Input.GetAxisRaw("Vertical") * (speed + dodgespeed) * Time.deltaTime;
        movedir += transform.forward * -Input.GetAxisRaw("Horizontal") * (speed + dodgespeed) * Time.deltaTime;

        Controller.Move(movedir);



        //jump
        if (Input.GetButtonDown("Jump"))
        {
            if (ySpeed == 0)
            {
                ySpeed = jumpForce;
            }
        }

        
    }


    bool RaycastRange(int detail, Vector3 direction)
    {

        direction *= 10;
        Vector3 dirRotated = Quaternion.Euler(0, -90, 0) * direction;
        for (int i = 0; i < detail; i++)
        {
            //new Ray(transform.position + dirRotated / 2 - (dirRotated / detail) * i, Vector3.up * 5);
            Debug.DrawRay(transform.position, Quaternion.Euler(0, -45 + ((float)(90 / detail)) * i, 0) * direction *5, Color.yellow);
            if (Physics.Raycast(transform.position, Quaternion.Euler(0, -45 + ((float)(90/detail))*i, 0) * direction, .5f)){
                return true;
            }
        }

        return false;
    }

    float rotY=0;
    public float CamDistance;
    
    void rotateCamera()
    {

        //change angle

        

        rotY += Input.GetAxis("Mouse Y") * mouseSensitivity*Time.deltaTime;

        rotY = Mathf.Clamp(rotY, -15f, 45f);

        Camera.main.transform.rotation = Quaternion.Euler(-rotY, Camera.main.transform.eulerAngles.y, Camera.main.transform.eulerAngles.z);



        //change cam position
        Camera.main.transform.localPosition = new Vector3(-Mathf.Cos(rotY*Mathf.PI/180)* CamDistance, 0.8f-Mathf.Sin(rotY * Mathf.PI / 180)* CamDistance, Camera.main.transform.localPosition.z);

    }

    void rotatePlayer()
    {
        transform.eulerAngles += new Vector3(
            0,
            Input.GetAxis("Mouse X"),
            0
        ) * Time.deltaTime * mouseSensitivity;
    }

    void updateY()
    {
        
        //simple fonction pour remonter des pentes (a ameliorer pour adapter la vitesse de deplacement en fonction de l'intensité de la pente)
        if (Physics.Raycast(transform.position,Vector3.down,.9f))
        {
            print("ccc");
            while(Physics.Raycast(transform.position, Vector3.down,.9f))
            {
                transform.position += Vector3.up * .0001f;
            }
        }

        //pour descendre les pentes
        RaycastHit hit;
        if (Physics.Raycast(transform.position, Vector3.down, out hit, Mathf.Infinity) && ySpeed<=0)
        {
            if (hit.distance < 1.3f && hit.distance>1)
            {
                Controller.Move(Vector3.down*hit.distance);
            }
        }
    }


    void gravity()
    {



        /*
        //si le joueur n'est pas au sol
        Debug.DrawRay(transform.position+ Vector3.down, Vector3.down*1);
        RaycastHit hit;
        Physics.Raycast(transform.position, Vector3.down, out hit, Mathf.Infinity);

        //si le player est suffisamant loin du sol
        if (hit.distance>=1f)
        {

            //collision au dessus de la tete
            if (ySpeed > 0)
            {
                if (Physics.Raycast(transform.position, Vector3.up * 1.1f, 1))
                {
                    ySpeed = 0;
                }

            }

            //si le joueur ne sera pas au sol a la frame d'après
            if (!Physics.Raycast(transform.position, (Vector3.down* 1.01f + Vector3.down * ySpeed)*Mathf.Sign(-ySpeed), 1))
            {
                
                ySpeed -= grav*Time.deltaTime;//changement de la vitesse y pour que le player tombe de plus en plus
            }




        }

        //si le player tombe et est proche du sol
        else if ( ySpeed < 0)
        {
            //transform.position += new Vector3(0, hit.distance*Mathf.Sign(ySpeed)+1, 0); //placement precis sur le sol
            ySpeed = 0;//reset de la vitesse Y

        }
        

        //deplacement du transform en fonction de la vitesse Y
        //transform.position += Vector3.up * (float)(ySpeed) * Time.deltaTime;
         
        */


        RaycastHit hit;
        Physics.Raycast(transform.position, Vector3.down, out hit, Mathf.Infinity);
        
        //si le player est suffisamant loin du sol
        if (hit.distance >= 1.3f)
        {
            {

                if (Physics.Raycast(transform.position, Vector3.up, 1.1f)&&ySpeed>0){
                    ySpeed = 0;
                }

                ySpeed -= grav * Time.deltaTime;
            }

        }
        else if( ySpeed<0)
        {
            print("cc");
            ySpeed = 0;
        }


        Controller.Move(Vector3.up*ySpeed*Time.deltaTime);


    }
}
