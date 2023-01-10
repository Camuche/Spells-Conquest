using System.Collections;
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

    // Start is called before the first frame update
    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;

        speed = playerSpeed;


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


        //vertical input

        //forward
        newpos = new Vector3(
        (Input.GetAxisRaw("Vertical") * (speed + dodgespeed) * Mathf.Cos(transform.eulerAngles.y * Mathf.PI / 180)),0,0) * Time.deltaTime;
        if (!RaycastRange(15,newpos))
        {
            transform.position += newpos;
        }

        //side
        newpos = new Vector3(0,0,(Input.GetAxisRaw("Vertical") * (speed + dodgespeed) * -Mathf.Sin(transform.eulerAngles.y * Mathf.PI / 180))) * Time.deltaTime;
        if (!RaycastRange(15, newpos))
        {
            transform.position += newpos;
        }


        //horizontal input

        //forward
        newpos = new Vector3((Input.GetAxisRaw("Horizontal") * (speed + dodgespeed) * -Mathf.Sin(transform.eulerAngles.y * Mathf.PI / 180)),0,0) * Time.deltaTime;

        if (!RaycastRange(15, newpos))
        {
            transform.position += newpos;
        }


        //side
        newpos = new Vector3(0,0,(Input.GetAxisRaw("Horizontal") * (speed + dodgespeed) * -Mathf.Cos(transform.eulerAngles.y * Mathf.PI / 180))) * Time.deltaTime;

        if (!RaycastRange(15, newpos))
        {
            transform.position += newpos;
        }


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


    void rotateCamera()
    {

        //change angle
        Camera.main.transform.eulerAngles += new Vector3(
            -Input.GetAxis("Mouse Y"),
            0,
            0
        ) * Time.deltaTime * mouseSensitivity;

        //change position
        Camera.main.transform.localPosition += new Vector3(
            -Input.GetAxis("Mouse Y") / 40,
            -Input.GetAxis("Mouse Y")/30,
            0
        ) * Time.deltaTime * mouseSensitivity;

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
    }


    void gravity()
    {


        
        
        //si le joueur n'est pas au sol
        Debug.DrawRay(transform.position+ Vector3.down, Vector3.down*1);

        RaycastHit hit;
        Physics.Raycast(transform.position, Vector3.down, out hit, Mathf.Infinity);

        //si le player est suffisamant loin du sol
        if (hit.distance>1)
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

                ySpeed -= grav *Time.deltaTime;//changement de la vitesse y pour que le player tombe de plus en plus
            }




        }

        //si le player tombe et est proche du sol
        else if ( ySpeed < 0)
        {
            transform.position += new Vector3(0, hit.distance*Mathf.Sign(ySpeed)+1, 0); //placement precis sur le sol
            ySpeed = 0;//reset de la vitesse Y

        }


        //deplacement du transform en fonction de la vitesse Y
        transform.position += (Vector3.up * (float)(ySpeed / 10f));
        



    }
}
