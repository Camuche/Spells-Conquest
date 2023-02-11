using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


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

    Transform previousTransform;

    public float life;


    [HideInInspector]
    public float lifeMax;
    public float speedscale = 1;



    // Start is called before the first frame update
    void Start()
    {

        Cursor.lockState = CursorLockMode.Locked;

        speed = playerSpeed;

        Controller = GetComponent<CharacterController>();

        Controller.enabled = false;
        Controller.transform.position = transform.position;
        Controller.enabled = true;

        previousTransform = transform;

        lifeMax = life;

        DefaultCamDistance = CamDistance;


    }

    // Update is called once per frame
    void Update()
    {
        aiming();
        rotateCamera();
        rotatePlayer();
        movements();

        updateY();

        gravity();

        CheckLife();


    }


    [HideInInspector] public float dashCoolDown = 0;
    void movements()
    {

        dashCoolDown -= Time.deltaTime;

        if (dashCoolDown < 0)
            dashCoolDown = 0;

        //dodge input
        if (Input.GetButtonDown("Dodge"))
        {
            if (dodgespeed == 0 && dashCoolDown<=0 && grounded==true) {
                dodgespeed = 200;
                dashCoolDown = 1.5f;
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
            speed = playerSpeed * speedscale;
        }
        else
        {
            speed = playerSpeed * Mathf.Cos(45 * Mathf.PI / 180) * speedscale;
        }


        Vector3 movedir = Vector3.zero;

        movedir += transform.right * Input.GetAxisRaw("Vertical") * (speed + dodgespeed) * Time.deltaTime;
        movedir += transform.forward * -Input.GetAxisRaw("Horizontal") * (speed + dodgespeed) * Time.deltaTime;

        Controller.Move(movedir);



        //jump
        if (Input.GetButtonDown("Jump"))
        {
            if (Physics.Raycast(transform.position,Vector3.down,1.1f))
            {
                ySpeed = jumpForce;
            }
        }

        
    }



    [SerializeField] float AimDistance;
    float DefaultCamDistance;
    private bool isAiming;

    void aiming()
    {
        if (Input.GetAxis("Aim") > 0 || Input.GetMouseButton(1))
        {

            if (CamDistance > AimDistance)
            {
                CamDistance /= 1.02f;
            }

            if (isAiming == false)
            {
                isAiming = true;

                
            }

        }
        else
        {
            if (CamDistance < DefaultCamDistance)
            {
                CamDistance *= 1.02f;
            }

            if (isAiming)
            {
                isAiming = false;
            }

            
        }
    }


    float rotY=0;
    public float CamDistance;
    
    public GameObject CamStart;

    void rotateCamera()
    {

        //change angle

        

        rotY += Input.GetAxis("Mouse Y") * mouseSensitivity*Time.deltaTime;

        rotY = Mathf.Clamp(rotY, -15f, 45f);

        Camera.main.transform.rotation = Quaternion.Euler(-rotY, Camera.main.transform.eulerAngles.y, Camera.main.transform.eulerAngles.z);



        //change cam position

        Vector3 campos = transform.TransformPoint(new Vector3(-Mathf.Cos(rotY * Mathf.PI / 180) * CamDistance, 0.8f - Mathf.Sin(rotY * Mathf.PI / 180) * CamDistance, Camera.main.transform.localPosition.z));
        Vector3 camposStart = CamStart.transform.position;

        Vector3 camdir = campos - camposStart;


        RaycastHit hit;

        Physics.Raycast(camposStart, camdir,out hit,CamDistance, obstacleMask);
        Debug.DrawRay(camposStart, camdir);

        float dist;


        if (hit.distance > CamDistance || hit.collider==null || hit.collider.transform.name=="Player")
        {
            dist = CamDistance;
        }
        else
        {
            dist = hit.distance;
        }
        /*
        RaycastHit hitz;

        Physics.Raycast(transform.position, transform.forward * -1, out hitz, CamDistance, obstacleMask);


        
        float zdistance;

        if (hitz.transform == null)
        {
            zdistance = (float)(CamDistance/2f);
        }
        else
        {
            zdistance = (float)(hitz.distance/2f)-0.25f*(CamDistance-hitz.distance)* (CamDistance - hitz.distance) / CamDistance;
        }
        */
        Camera.main.transform.localPosition = new Vector3(-Mathf.Cos(rotY * Mathf.PI / 180) * dist, 0.8f - Mathf.Sin(rotY * Mathf.PI / 180) * dist, Camera.main.transform.localPosition.z);

        //Camera.main.transform.localPosition = new Vector3(Camera.main.transform.localPosition.x, Camera.main.transform.localPosition.y, -1.16f+0.3f * (CamDistance - dist));


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
        
        //simple fonction pour remonter des pentes
        if (Physics.Raycast(transform.position,Vector3.down,.9f, obstacleMask, QueryTriggerInteraction.Ignore))
        {
            while(Physics.Raycast(transform.position, Vector3.down,.9f, obstacleMask, QueryTriggerInteraction.Ignore))
            {
                transform.position += Vector3.up * .0001f;
            }
        }

        //pour descendre les pentes
        RaycastHit hit;
        if (Physics.Raycast(transform.position, Vector3.down, out hit, Mathf.Infinity, obstacleMask) && ySpeed==0)
        {
            if (hit.distance < 1.3f && hit.distance>1)
            {
                Controller.Move(Vector3.down*hit.distance);
            }
        }

        //glisser sur les pentes raides
        
        slide(transform.position+transform.forward*.5f);
        slide(transform.position+ transform.forward*-.5f);
        slide(transform.position + transform.right * .5f);
        slide(transform.position + transform.right * -.5f);
        
        previousTransform = transform;


    }

    void slide(Vector3 t)
    {
        RaycastHit slope;
        if (Physics.Raycast(t, Vector3.down, out slope, Controller.height / 2 + 0.001f, obstacleMask))
        {

            float slopeAngle = Vector3.Angle(slope.normal, Vector3.up);
            if (slopeAngle >= Controller.slopeLimit-5)
            {

                Vector3 slopeDirection = Vector3.up - slope.normal * Vector3.Dot(Vector3.up, slope.normal);
                float slideSpeed = (ySpeed ) * Time.deltaTime;

                Vector3 moveDirection = slopeDirection * slideSpeed * (ySpeed >= 0 ? 0 : 1);
                //moveDirection.y = moveDirection.y - slope.point.y;
                
                Controller.Move(moveDirection);
            }
        }
    }


    public LayerMask obstacleMask;

    bool grounded=true;
    void gravity()
    {

        RaycastHit hit;
        Physics.Raycast(transform.position, Vector3.down, out hit, Mathf.Infinity, obstacleMask);

        RaycastHit hit2;
        Physics.Raycast(transform.position+transform.forward*.05f, Vector3.down, out hit2, Mathf.Infinity, obstacleMask);

        RaycastHit hit3;
        Physics.Raycast(transform.position + transform.forward * -.05f, Vector3.down, out hit3, Mathf.Infinity, obstacleMask);

        RaycastHit hit4;
        Physics.Raycast(transform.position + transform.right * .05f, Vector3.down, out hit4, Mathf.Infinity, obstacleMask);

        RaycastHit hit5;
        Physics.Raycast(transform.position + Vector3.right * -.05f, Vector3.down, out hit5, Mathf.Infinity, obstacleMask);

        float distToGround = 1.1f;

        grounded = true;


        //si le joueur est assez loin du sol
        if (hit.distance>= distToGround && hit2.distance >= distToGround && hit3.distance >= distToGround && hit4.distance >= distToGround && hit5.distance >= distToGround)
        {
            grounded = false;

            {

                if (Physics.Raycast(transform.position, Vector3.up, 1.1f, obstacleMask)&&ySpeed>0){
                    ySpeed = 0;
                }

                ySpeed -= grav * Time.deltaTime;
            }

        }
        else if( ySpeed<0)
        {
            ySpeed = 0;
        }


        Controller.Move(Vector3.up*ySpeed*Time.deltaTime);


    }


    void CheckLife()
    {
        if (life <= 0)
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().name);
        }
    }

    public bool CheckShield()
    {
        GameObject shield = GameObject.Find("PrefabFireShield(Clone)");

        if (shield != null)
        {
            if (Vector3.Distance(transform.position, shield.transform.position)<2.5f)
            {
                return true;
            }
            else
            {
                return false;


            }
        }
        else
        {
            return false;

        }
    }


}
