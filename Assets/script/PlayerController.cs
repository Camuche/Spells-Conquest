using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.InputSystem;
using UnityEngine.Events;

public class PlayerController : MonoBehaviour
{

    //[SerializeField] GameObject inputPlayer;//, inputMenu;
    //private NewInputSystem actionMapping;
    //public PlayerInput playerInput;
    


    public float mouseSensitivity, minSensitivity, maxSensitivity;
    public float playerSpeed;
    float speed;
    float dodgespeed = 0;
    Vector3 newpos;

    public float grav = 1;
    public float jumpForce = 10;
    float ySpeed = 0;
    [HideInInspector] public bool isAttracted = false;

    CharacterController Controller;

    Transform previousTransform;

    public float life;


    [HideInInspector]
    public static float lifeMax;
    public float speedscale = 1;


    [HideInInspector] public bool canMove = true;

    public Animator animator;

    [SerializeField] Material shaderUI;

    [HideInInspector]
    public bool isDead;

    [SerializeField] private InputActionReference cameraRotation, movement, mapInput, lockModeInput, runInput, startInput, l2Input, r2Input;

    [SerializeField] Camera mapCam;
    bool showMap = false;

    public PlayerInput refPlayerInput;

    public static PlayerController instance ;

    public Transform refModel;

    Inventory inventory;

    [HideInInspector] public bool isCasting = false;
    public bool lockMode = false;

    public float runSpeedMultiplier;
    bool isRunning = false;

    bool canControlCamera;
    gameController refGameController;

    public static bool tutoDone;

    public int enemyTriggered;

    GameObject mainCamera;
    public float modelRotationSpeed;

    bool combatModeActive;

    void Awake()
    {
        instance = this;
        refPlayerInput = GetComponent<PlayerInput>();
    }

    // Start is called before the first frame update
    void Start()
    {
        //InputActionMap.
        //actionMapping = new NewInputSystem();
        //Debug.Log(playerInput.currentActionMap.name);

        //inputMenu = GameObject.Find("InputMenu");
        //inputPlayer = GameObject.Find("InputPlayer");
        //inputMenu.EnablePlayerInput
        //inputPlayer.SetActive(true);
        //inputPlayer.SwitchCurrentActionMap("Menu Input");

        //canControlCamera = false;
        refGameController = GameObject.Find("GameController").GetComponent<gameController>();
        mainCamera = transform.Find("Main Camera").gameObject;
        /*if (!refGameController.xWasPressed)
        {
            GetComponent<PlayerInput>().enabled = false;
            Invoke("CantMoveAtStart", 0.5f);
        }*/
        Controller = GetComponent<CharacterController>();
        
        /*rotateCamera();
        if(!isAttracted)
        {
            gravity();
            updateY();
        }
        movements();*/
        GetComponent<PlayerInput>().enabled = true;
        if(!tutoDone)
        {
            canMove = false;
        }
        else
        {
            canMove=true;
        }
        
        //Invoke("CantMoveAtStart", 0.5f);
        

        Cursor.lockState = CursorLockMode.Locked;

        speed = playerSpeed;

        //Controller = GetComponent<CharacterController>();

        Controller.enabled = false;
        Controller.transform.position = transform.position;
        Controller.enabled = true;

        previousTransform = transform;

        //lifeMax = life;
        if (lifeMax == 0)
        {
            lifeMax = life;
        }
        else
        {
            life = lifeMax;
        }

        DefaultCamDistance = CamDistance;

       
        isDead = false;
        

        persistentObject = GameObject.Find("PersistentObject");

        refModel.parent = null;
        
        inventory = GetComponent<Inventory>();

    }

    
    void CantMoveAtStart()
    {
        canMove = true;
        //GetComponent<PlayerInput>().enabled = true;
        //canControlCamera = true;
        
    }

    // Update is called once per frame
    void Update()
    {
        // PRESS X BEFORE PLAYING
        //Debug.Log(canMove);

        //Debug.Log(life + "/" + lifeMax + " HP ");
        if(!isAttracted)
        {
            gravity();
            updateY();
        }

        /*if (!canMove)
        {
            return;
        }*/
        

        /*if (GetComponent<CastSpell>().limit>-1)
            aiming();*/
        if(enemyTriggered > 0 && !combatModeActive)
        {
            combatModeActive = true;
            DisplayInput.instance.LockModeInput();
        }
        else if(enemyTriggered <= 0 && combatModeActive)
        {
            combatModeActive = false;
            DisplayInput.instance.HideInput();
        }

        if(lockModeInput.action.WasPressedThisFrame() && canMove)
        {
            if (!lockMode)
            {
                //mainCamera.transform.eulerAngles = new Vector3(-2,0.8f,-0.6f);
                lockMode = true;
                StartLockMode();
            }
            else
            {
                lockMode = false;
                transform.eulerAngles = new Vector3(0,transform.eulerAngles.y, 0);
                EndLockMode();
            }
        }

        if(lockMode)
        {
            LockMode();
        }

        if (life > 0 && GetComponent<CastSpellNew>().selecting == 0 && lockMode == false)//) && canControlCamera)
        {
            rotateCamera();
            rotatePlayer();
            //movements();
        }

        if(!isDead)// && !isCasting)
        {
            movements();
        }
        //movements();
        AnimationControl();

        /*if(!isAttracted)
        {
            gravity();
            updateY();
        }*/
        
        CheckLife();

        MapCamera();
    }


    void AnimationControl()
    {
        if (GetComponent<CastSpellNew>().selecting == 0)
        {
            animator.SetBool("IsMoving", movedir != Vector3.zero && !isAttracted);
            //animator.SetFloat("VelocityZ", movement.action.ReadValue<Vector2>().y);
            //animator.SetFloat("VelocityX", movement.action.ReadValue<Vector2>().x);
        }
        /*Debug.Log(animator.GetBool("Throw"));
        if (l2Input.action.IsPressed() || r2Input.action.IsPressed())
        {
            animator.SetBool("Throw", true);
            animator.SetBool("HoldSpell", true);
        }
        else
        {
            animator.SetBool("Throw", false);
            animator.SetBool("HoldSpell", false);
        }*/

        /*if (animator.GetBool("Throw") == true)
        {
            animator.SetBool("HoldSpell", true);
        }*/

        /*if (Input.GetAxis("Fire") > 0 || Input.GetMouseButton(0))
        {
            animator.SetBool("HoldSpell", true);
        }
        else
        {
            animator.SetBool("HoldSpell", false);
        }*/

        animator.SetBool("Dead", life <= 0);

       

    }




    [HideInInspector] public float dashCoolDown = 0;
    [HideInInspector] public Vector3 movedir;

    public UnityEvent runEvent;
    void movements()
    {
        if (!isRunning && runInput.action.WasPressedThisFrame() && movement.action.ReadValue<Vector2>() != Vector2.zero && canMove)
        {
            speed *= runSpeedMultiplier;
            isRunning = true;
            runEvent.Invoke();
            animator.SetBool("IsRunning", true);
        }
        if(isRunning && movement.action.ReadValue<Vector2>() == Vector2.zero && canMove)
        {
            speed /= runSpeedMultiplier;
            isRunning = false;
            animator.SetBool("IsRunning", false);
        }
        //shaderUI.SetFloat("_Stamina", dashCoolDown /-1.5f +1f);

        dashCoolDown -= Time.deltaTime;

        if (dashCoolDown < 0)
            dashCoolDown = 0;

        //dodge input
        /*if (Input.GetButtonDown("Dodge"))
        {
            if (dodgespeed == 0 && dashCoolDown<=0 && grounded==true && life>0) {
                animator.SetTrigger("Dash");
                dodgespeed = 200;
                dashCoolDown = 1.5f;
            }
        }

        //dodge
        if (dodgespeed > 1.5)
        {
            dodgespeed /=(1+ 20* Time.deltaTime);
        }
        else
        {
            dodgespeed = 0;
        }*/


        //set speed

        /*if (Input.GetAxis("Vertical")==0 || Input.GetAxis("Horizontal") == 0)
        {
            speed = playerSpeed * speedscale;
        }
        else
        {
            speed = playerSpeed * Mathf.Cos(45 * Mathf.PI / 180) * speedscale;
        }*/

        if(!isAttracted)
        {
            Vector3 forwardCam = new Vector3 (mainCamera.transform.forward.x , 0 , mainCamera.transform.forward.z);
            Vector3 rightCam = new Vector3 (mainCamera.transform.right.x , 0 , mainCamera.transform.right.z) *-1;

            movedir = Vector3.zero;
            if(canMove)
            {
                movedir += forwardCam * movement.action.ReadValue<Vector2>().y ;
                movedir += rightCam * -movement.action.ReadValue<Vector2>().x ;
                movedir = movedir.normalized * (speed + dodgespeed) * Time.deltaTime *speedscale;
            }
        }
        Controller.Move(movedir);

        if(movedir != Vector3.zero)
        {
            refModel.forward = Vector3.Lerp(refModel.forward, movedir, modelRotationSpeed);
        }
        refModel.position = transform.position - Vector3.up;


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

    /*void aiming()
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
    }*/


    float rotY=0;
    public float CamDistance;
    
    public GameObject CamStart;


    float CamzDefault=999;
    bool invertAxisX, invertAxisY;


    void rotateCamera()
    {
        //invertAxisY = true;
        if (CamzDefault == 999)
        {
            CamzDefault = mainCamera.transform.localPosition.z;
        }

        //change angle
        if(canMove)
        {
            if (!invertAxisY)
            {
                rotY += cameraRotation.action.ReadValue<Vector2>().y * mouseSensitivity*Time.deltaTime;
            }
            else
            {
                rotY -= cameraRotation.action.ReadValue<Vector2>().y * mouseSensitivity*Time.deltaTime;
            }
        }

        rotY = Mathf.Clamp(rotY, -60f, 89.9f);

       mainCamera.transform.rotation = Quaternion.Euler(-rotY, mainCamera.transform.eulerAngles.y, mainCamera.transform.eulerAngles.z);



        //change cam position

        Vector3 campos = transform.TransformPoint(new Vector3(-Mathf.Cos(rotY * Mathf.PI / 180) * CamDistance, 0.8f - Mathf.Sin(rotY * Mathf.PI / 180) * CamDistance, CamzDefault));
        Vector3 camposStart = CamStart.transform.position;

        Vector3 camdir = campos - camposStart;


        RaycastHit hit;

        Physics.Raycast(camposStart, camdir,out hit,CamDistance, obstacleMask, QueryTriggerInteraction.Ignore);
        Debug.DrawRay(camposStart, camdir);

        float dist;


        if (hit.distance > CamDistance || hit.collider==null || hit.collider.transform.name=="Player")
        {
            dist = CamDistance;
            mainCamera.transform.localPosition = new Vector3(-Mathf.Cos(rotY * Mathf.PI / 180) * dist, 0.8f - Mathf.Sin(rotY * Mathf.PI / 180) * dist, CamzDefault + (CamDistance - dist));
            //Debug.Log(new Vector3(-Mathf.Cos(rotY * Mathf.PI / 180) * dist, 0.8f - Mathf.Sin(rotY * Mathf.PI / 180) * dist, CamzDefault + (CamDistance - dist)));
        }
        else
        {
            dist = hit.distance;
            Vector3 camdest = hit.point;
            camdest = Vector3.MoveTowards(camdest, camposStart, 0.1f);
            mainCamera.transform.position = camdest;
            //mainCamera.transform.position = camposStart+((hit.point - camposStart).normalized * dist*-0.9f);
        }


    }

    void rotatePlayer()
    {
        //invertAxisX = true;
        if(canMove && !invertAxisX)
        {
            transform.eulerAngles += new Vector3(0,cameraRotation.action.ReadValue<Vector2>().x) * Time.deltaTime * mouseSensitivity;
        }
        else if (canMove && invertAxisX)
        {
            transform.eulerAngles -= new Vector3(0,cameraRotation.action.ReadValue<Vector2>().x) * Time.deltaTime * mouseSensitivity;
        }
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
        Physics.Raycast(transform.position, Vector3.down, out hit, Mathf.Infinity, obstacleMask,QueryTriggerInteraction.Ignore);

        RaycastHit hit2;
        Physics.Raycast(transform.position+transform.forward*.05f, Vector3.down, out hit2, Mathf.Infinity, obstacleMask, QueryTriggerInteraction.Ignore);

        RaycastHit hit3;
        Physics.Raycast(transform.position + transform.forward * -.05f, Vector3.down, out hit3, Mathf.Infinity, obstacleMask, QueryTriggerInteraction.Ignore);

        RaycastHit hit4;
        Physics.Raycast(transform.position + transform.right * .05f, Vector3.down, out hit4, Mathf.Infinity, obstacleMask, QueryTriggerInteraction.Ignore);

        RaycastHit hit5;
        Physics.Raycast(transform.position + Vector3.right * -.05f, Vector3.down, out hit5, Mathf.Infinity, obstacleMask, QueryTriggerInteraction.Ignore);

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


    IEnumerator RestartLevel()
    {
        yield return new WaitForSeconds(5);

        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }


    float damagedTimer = 0;
    float? previousLife;
    [SerializeField] Material playerMat;
    [SerializeField] Material damageMat;
    [SerializeField] GameObject playerMesh;
    [SerializeField] GameObject soul;
    GameObject persistentObject;

    public AudioSource audioSource;
    //public AudioClip takeDamageAudioClip;
    
    public UnityEvent takeDamageEvent;
    public float timerSoundDamageTrigger = 0.5f;
    bool canPlayDamageSound = true;

    public AudioClip deathAudioClip, mapOpenClip, mapCloseClip;
    public UnityEvent deathEvent;

    void CheckLife()
    {
        life = Mathf.Round(life*10)/10;
        damagedTimer -= Time.deltaTime;
        

        if (previousLife!=null && previousLife > life)
        {
            damagedTimer = .05f;
            if (canPlayDamageSound)
            {
                takeDamageEvent.Invoke();
                canPlayDamageSound = false;
                Invoke("CanPlaySoundAgain", timerSoundDamageTrigger);
            }
            //audioSource.clip = takeDamageAudioClip;
            //audioSource.Play();
            //audioSource.PlayOneShot(takeDamageAudioClip);
        }
        playerMesh.GetComponent<SkinnedMeshRenderer>().material = damagedTimer > 0 ? damageMat : playerMat;
        previousLife = life;

        if (life <= 0)
        {
            playerSpeed = 0;
            life = 0;
            if(!isDead)
            {
                audioSource.clip = deathAudioClip;
                audioSource.Play();
                deathEvent.Invoke();

                GameObject f = Instantiate(soul, transform.position, transform.rotation);
                f.GetComponent<Soul>().soulMoney = inventory.money;
                f.transform.parent = persistentObject.transform;

                StartCoroutine(RestartLevel());
            }
            //StartCoroutine(RestartLevel());
            isDead = true;
        }
        else isDead = false;

        shaderUI.SetFloat("_Life", life / lifeMax);
    }

    void CanPlaySoundAgain()
    {
        canPlayDamageSound = true;
    }

    public bool CheckShield()
    {
        GameObject shield = GameObject.Find("PrefabFireShield(Clone)");

        if (shield != null)
        {
            if (Vector3.Distance(transform.position, shield.transform.position)<2.7f)
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

    ///getters and setters

    //canMove
    public bool getCanMove()
    {
        return canMove;
    }

    public void setCanMove(bool c)
    {
        canMove = c;
    }

    public void EnablePlayerInput()
    {

    }
    public void EnableMenuInput()
    {
        
    }

    bool inputMapReleased=true;
    bool stopTime = false;

    void MapCamera()
    {

        //Debug.Log(canMove);

        if (showMap == false && inputMapReleased && mapInput.action.IsPressed() && canMove)
        {
            stopTime = true;
            Time.timeScale = 0f;
            showMap = true;
            mapCam.enabled = true;
            audioSource.PlayOneShot(mapOpenClip);
        }

        else if (showMap==true && inputMapReleased && (mapInput.action.IsPressed() || startInput.action.WasPressedThisFrame()) && canMove)
        {
            stopTime = false;
            Time.timeScale = 1f;
            showMap = false;
            mapCam.enabled = false;
            audioSource.PlayOneShot(mapCloseClip);
        }
        if(mapInput.action.ReadValue<float>()==0 && canMove)
        {
            inputMapReleased = true;
        }
        else  inputMapReleased = false;

        /*if(stopTime == true)
        {
            Time.timeScale = 0f;
        }
        else Time.timeScale = 1f;*/
        
    }

    public void SetMouseSensitivity(float value)
    {
        mouseSensitivity = minSensitivity + (maxSensitivity - minSensitivity) * value;
    }
    
    [SerializeField] float enemyDist;
    public GameObject currentEnemy;
    List<GameObject> nearestEnemies;
    public LayerMask lockMask;
    public float lockSpeed;
    void StartLockMode()
    {
        nearestEnemies = new List<GameObject>();
        currentEnemy = null;
        Transform[] gos = EnemyManager.instance.transform.GetComponentsInChildren<Transform>() as Transform[]; //Array of enemies
        foreach (Transform gotr in gos)
        {
            GameObject go = gotr.gameObject;

            if (go.tag == "Enemy" && Vector3.Distance(transform.position, go.transform.position) <= enemyDist)
            {
                /*if (nearestEnemy == null)
                {
                    nearestEnemy = go;
                }
                if (nearestEnemy != null && Vector3.Distance(transform.position, go.transform.position) <= Vector3.Distance(transform.position, nearestEnemy.transform.position))
                {
                    RaycastHit hit;
                    Physics.Raycast(mainCamera.transform.position, go.transform.position - mainCamera.transform.position , out hit, Mathf.Infinity, lockMask);
                    Debug.Log(hit.collider);
                    if(hit.collider == null)
                    {
                        nearestEnemy = go;
                    }
                    nearestEnemy = go;
                }*/

                RaycastHit hit;
                Physics.Raycast(mainCamera.transform.position, go.transform.position - mainCamera.transform.position , out hit, Mathf.Infinity, lockMask);
                if (hit.collider.tag == "Enemy")
                {
                    nearestEnemies.Add(go);
                }
                

            }

        }
        foreach (GameObject go in nearestEnemies)
        {
            if (currentEnemy == null)
            {
                currentEnemy = go;
                indexLock = nearestEnemies.IndexOf(go);
            }
            if (currentEnemy != null && Vector3.Distance(transform.position, go.transform.position) <= Vector3.Distance(transform.position, currentEnemy.transform.position))
            {
                /*RaycastHit hit;
                Physics.Raycast(mainCamera.transform.position, go.transform.position - mainCamera.transform.position , out hit, Mathf.Infinity, lockMask);
                Debug.Log(hit.collider);
                if(hit.collider == null)
                {
                    nearestEnemy = go;
                }*/
                currentEnemy = go;
                indexLock = nearestEnemies.IndexOf(go);
            }
        }
        if (nearestEnemies.Count != 0)
        {
            UIupdate.instance.UIPlane.GetComponent<MeshRenderer>().material.SetInt("_ShowAimpoint", 0);
        }
        

    }

    bool canSwitchTarget = true;
    int indexLock;
    float lockTimer;
    Vector3 lookDir ;
    

    void LockMode()
    { 
        /*if (currentEnemy == null)
        {
            foreach (GameObject go in nearestEnemies)
            {
                if(go != null )
                {
                    //currentEnemy = go;
                    StartLockMode();
                }
            }
        }*/

        if (currentEnemy == null)
        {
            StartLockMode();
        }

        if (currentEnemy == null)
        {
            lockMode = false;
            EndLockMode();
            transform.eulerAngles = new Vector3(0,transform.eulerAngles.y, 0);
            return;
        }

        lockTimer -= Time.deltaTime;

        if(cameraRotation.action.ReadValue<Vector2>().x <0 && canSwitchTarget && lockTimer <= 0 && canMove)
        {
            canSwitchTarget = false;
            indexLock ++;
            lockTimer = 0.5f;
            if(indexLock > nearestEnemies.Count -1)
            {
                indexLock = 0;
            }
        }
        else if (cameraRotation.action.ReadValue<Vector2>().x > 0 && canSwitchTarget && lockTimer <= 0 && canMove)
        {
            canSwitchTarget = false;
            indexLock --;
            lockTimer = 0.5f;
            if(indexLock < 0)
            {
                indexLock = nearestEnemies.Count -1;
            }
        }
        else if(cameraRotation.action.ReadValue<Vector2>().x == 0 && canMove)
        {
            canSwitchTarget = true;
        }

        currentEnemy = nearestEnemies[indexLock];

        //mainCamera.transform.LookAt(currentEnemy.transform, Vector3.up);
        //mainCamera.transform.forward = Vector3.Lerp(mainCamera.transform.forward, (currentEnemy.transform.position - mainCamera.transform.position).normalized, lockSpeed);

        //transform.LookAt(currentEnemy.transform, Vector3.up);
        //transform.forward = Vector3.Lerp(transform.forward, (currentEnemy.transform.position - transform.position).normalized, lockSpeed);
        //transform.eulerAngles -= new Vector3(0,90,0);   
        //transform.right = (currentEnemy.transform.position - transform.position).normalized;
        //transform.eulerAngles = new Vector3(0,transform.eulerAngles.y, 0);
        //transform.up = Vector3.up;
        lookDir = (currentEnemy.transform.position - transform.position).normalized;
        transform.rotation = XLookRotation(lookDir, Vector3.up);
        
        /*if(transform.eulerAngles.z > 90 || transform.eulerAngles.z < -60)
        {
            lockMode = false;
            transform.eulerAngles = new Vector3(0,transform.eulerAngles.y, 0);
        }*/

        

        mainCamera.transform.localPosition = new Vector3(-2,0.8f,-0.6f);
        mainCamera.transform.localRotation = Quaternion.Euler (0,mainCamera.transform.localRotation.y +90 /*because player forward is right*/ ,mainCamera.transform.localRotation.z);
        
        //TRYING TO ROTATE THE PLAYER BUT NOT IN X 
        /*refModel.transform.localRotation =transform.rotation *  Quaternion.Euler(-transform.rotation.x,90,0);
        refModel.transform.localRotation = Quaternion.Euler(0, refModel.transform.localRotation.y , refModel.transform.localRotation.z);*/
        
        /*rotY = 0;
        ChangeCamPos();*/
        /*rotY = mainCamera.transform.rotation.y;
        rotY = Mathf.Clamp(rotY, -60f, 90f);
        ChangeCamPos();*/

        foreach (GameObject go in nearestEnemies)
        {
            go.transform.Find("FeedbackSelectedEnemy").GetComponent<MeshRenderer>().enabled = false;
            if(go == currentEnemy)
            {
                go.transform.Find("FeedbackSelectedEnemy").GetComponent<MeshRenderer>().enabled = true;
            }
        }

        
        if(lookDir.y < -0.75f || lookDir.y > 0.75f)
        {
            lockMode = false;
            EndLockMode();
            transform.eulerAngles = new Vector3(0,transform.eulerAngles.y, 0);
        }
    }

    void ChangeCamPos()
    {
        Vector3 campos = transform.TransformPoint(new Vector3(-Mathf.Cos(rotY * Mathf.PI / 180) * CamDistance, 0.8f - Mathf.Sin(rotY * Mathf.PI / 180) * CamDistance, CamzDefault));
        Vector3 camposStart = CamStart.transform.position;

        Vector3 camdir = campos - camposStart;


        RaycastHit hit;

        Physics.Raycast(camposStart, camdir,out hit,CamDistance, obstacleMask, QueryTriggerInteraction.Ignore);
        Debug.DrawRay(camposStart, camdir);

        float dist;


        if (hit.distance > CamDistance || hit.collider==null || hit.collider.transform.name=="Player")
        {
            dist = CamDistance;
            mainCamera.transform.localPosition = new Vector3(-Mathf.Cos(rotY * Mathf.PI / 180) * dist, 0.8f - Mathf.Sin(rotY * Mathf.PI / 180) * dist, CamzDefault + (CamDistance - dist));
            //Debug.Log(new Vector3(-Mathf.Cos(rotY * Mathf.PI / 180) * dist, 0.8f - Mathf.Sin(rotY * Mathf.PI / 180) * dist, CamzDefault + (CamDistance - dist)));
        }
        else
        {
            dist = hit.distance;
            Vector3 camdest = hit.point;
            camdest = Vector3.MoveTowards(camdest, camposStart, 0.1f);
            mainCamera.transform.position = camdest;
            //mainCamera.transform.position = camposStart+((hit.point - camposStart).normalized * dist*-0.9f);
        }
    }

    Quaternion XLookRotation(Vector3 right, Vector3 up = default)
    {

        if(up == default)

        up = Vector3.up;

        Quaternion rightToForward = Quaternion.Euler(0f, -90f, 0f);

        Quaternion forwardToTarget = Quaternion.LookRotation(right, up);


        return forwardToTarget * rightToForward;

    }

    void EndLockMode()
    {
        UIupdate.instance.UIPlane.GetComponent<MeshRenderer>().material.SetInt("_ShowAimpoint", 1);

        foreach (GameObject go in nearestEnemies)
        {
            go.transform.Find("FeedbackSelectedEnemy").GetComponent<MeshRenderer>().enabled = false;
        }
    }
}
