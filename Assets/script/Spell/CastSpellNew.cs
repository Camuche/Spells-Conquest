using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;

public class CastSpellNew : MonoBehaviour
{
    public static CastSpellNew instance;

    // INT 0=fireball / 1=fireClone ...
    public int SpellL;
    public int SpellR;
    
    [HideInInspector] public List<int> listLeftSpellAvailable = new List<int>{2,3/*,4,5*/};
    [HideInInspector] public List<int> listRightSpellAvailable = new List<int>{2,3/*,4,5*/};

    public int limit;
    [HideInInspector] public int selecting;

    [HideInInspector] public bool /*topSelected = false, */rightSelected = false,/* botSelected = false,*/ leftSelected = false;

    [SerializeField] GameObject fireball, fireClone, telekinesisClone, wave, iceball, iceClone;

    gameController gameController;
    UIupdate refUiUpdate;

    [SerializeField] GameObject aimPoint, aimPoint2, aimPointBoth1, aimPointBoth2;
    


    [System.Serializable]
    public struct structSpell
    {
        public string spell_name;
        public Sprite spell_image;
        public int id;
    }
    public structSpell[] structSpells = new structSpell[6];



    [SerializeField] private InputActionReference leftSelection, rightSelection, /*movement,*/ cameraRotation, spellR2, spellL2;

    bool l2IsPressed=false, r2IsPressed=false, l2IsHold= false, r2IsHold = false;
    [SerializeField] float spellAnimationTime;
    float timerCastAnimation = 0;

    public GameObject feedback_LeftArm;
    public GameObject feedback_RightArm;

    Inventory inventory;
    

    void Awake()
    {
        instance = this;
    }


    // Start is called before the first frame update
    void Start()
    {
        gameController = GameObject.Find("GameController").GetComponent<gameController>();
        refUiUpdate = GameObject.Find("GameController").GetComponent<UIupdate>();
        timerFireball = 0;

        feedback_RightArm.SetActive(false);
        feedback_LeftArm.SetActive(false);

        aimPoint = Instantiate(aimPoint);
        aimPoint2 = Instantiate(aimPoint2);
        aimPointBoth1 = Instantiate(aimPointBoth1);
        aimPointBoth2 = Instantiate(aimPointBoth2);
        

        inventory = GetComponent<Inventory>();
        doNotFollow = true;
        isMoving= true;
        TelekinesisAlt = false;
        iceCloneAlt = false;
    }


    // Update is called once per frame
    void Update()
    {
        if (limit > -1)
        {
            SetSelecting();
        }
        //Debug.Log(limit);

        //L2 IS PRESSED
        if(spellL2.action.ReadValue<float>() == 1 && !l2IsPressed)
        {
            l2IsPressed = true;
            l2IsHold = true;
            CastSpell(SpellL);
        }
        else if (l2IsPressed && spellL2.action.ReadValue<float>() == 0)
        {
            l2IsPressed = false;
        }
        
        //R2 IS PRESSED
        if(spellR2.action.ReadValue<float>() == 1 && !r2IsPressed)
        {
            r2IsPressed = true;
            r2IsHold = true;
            CastSpell(SpellR);
        }
        else if (r2IsPressed && spellR2.action.ReadValue<float>() == 0)
        {
            r2IsPressed = false;
        }

        //CHECK RELEASE
        if (spellL2.action.ReadValue<float>() == 0 && l2IsHold)
        {
            l2IsHold = false;
        }
        if (spellR2.action.ReadValue<float>() == 0 && r2IsHold)
        {
            r2IsHold = false;
        }

        //TIMER    
        if (timerFireball <= cooldownFireball)
        {
            timerFireball += Time.deltaTime;
        }
        if(timerFireClone <= cooldownFireClone)
        {
            timerFireClone += Time.deltaTime;
        }
        if(timerTelekinesisClone <= cooldownTelekinesisClone)
        {
            timerTelekinesisClone += Time.deltaTime;
        }
        /*if (timerWave <= cooldownWave)
        {
            timerWave += Time.deltaTime;
        }
        if (timerIceball <= cooldownIceball)
        {
            timerIceball += Time.deltaTime;
        }*/
        if (timerIceClone <= cooldownIceClone)
        {
            timerIceClone += Time.deltaTime;
        }
        

        //Instantiate AIMPOINT
        if ((limit>=2 && (SpellL == 2 || SpellR == 2)))
        {
            aimPoint.SetActive(true);
        }
        else
        {
            aimPoint.SetActive(false);            
        }

        if (limit>=3 && (SpellL == 3 || SpellR == 3))
        {
            aimPoint2.SetActive(true);
        }
        else
        {
            aimPoint2.SetActive(false);
        }

        //Make player move again
        if (timerCastAnimation <= spellAnimationTime)
        {
            timerCastAnimation += Time.deltaTime;
        }
        else if(PlayerController.instance.isCasting)
        {
            PlayerController.instance.isCasting = false;
        }

        CamRaycast();
        CamRaycast2();
        AimpointSelection();

        FeedbackLeftBody();
        FeedbackRightBody();       
    }


    public int hand;
    public float timeScaleSelecting;

    void SetSelecting()
    {
        
        if (selecting == 0)
        {
            
            refUiUpdate.DisableSelectionUi();

            if(leftSelection.action.ReadValue<float>() ==1)
            {
                selecting = -1;
                Time.timeScale = timeScaleSelecting;
                Cursor.lockState = CursorLockMode.None;
            }
            else if (rightSelection.action.ReadValue<float>() ==1)
            {
                selecting =1;
                Time.timeScale = timeScaleSelecting;
                Cursor.lockState = CursorLockMode.None;
            }
        }

        int saveCurrentSpell = -1;

        if (selecting != 0)
        {
            hand = selecting;
            refUiUpdate.EnableSelectionUi();
            refUiUpdate.UpdateUiSelection();
            CheckSelectedSpell();

            
            //SELECT SPELL ON RELEASE (LEFT)
            if (hand ==-1)
            {
                if (leftSelection.action.ReadValue<float>() !=1)
                {
                    selecting =0;
                    Cursor.lockState = CursorLockMode.Locked;
                    Time.timeScale = 1f;

                    if(cameraRotation.action.ReadValue<Vector2>().x<0 && listLeftSpellAvailable[0] <= limit) //LEFT STICK LEFT
                    {
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[0];
                        listLeftSpellAvailable[0] = saveCurrentSpell;
                        UpdateRightSpells();
                    }
                    if(cameraRotation.action.ReadValue<Vector2>().x>0 && listLeftSpellAvailable[1] <= limit) //LEFT STICK RIGHT
                    {
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[1];
                        listLeftSpellAvailable[1] = saveCurrentSpell;
                        UpdateRightSpells();
                    }
                    /*if(movement.action.ReadValue<Vector2>().y <-0.5 && movement.action.ReadValue<Vector2>().x>-0.5 && movement.action.ReadValue<Vector2>().x < 0.5 && listLeftSpellAvailable[2] <= limit) //LEFT STICK BOT
                    {
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[2];
                        listLeftSpellAvailable[2] = saveCurrentSpell;
                        UpdateRightSpells();
                    }
                    if(movement.action.ReadValue<Vector2>().x <-0.5 && movement.action.ReadValue<Vector2>().y >-0.5 && movement.action.ReadValue<Vector2>().y <0.5 && listLeftSpellAvailable[3] <= limit) //LEFT STICK LEFT
                    {
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[3];
                        listLeftSpellAvailable[3] = saveCurrentSpell;
                        UpdateRightSpells();
                    }*/
                }
            }


            
            //SELECT SPELL ON RELEASE (Right)
            if (hand == 1)
            {
                if (rightSelection.action.ReadValue<float>() !=1)
                {
                    selecting =0;
                    Cursor.lockState = CursorLockMode.Locked;
                    Time.timeScale = 1f;

                    if(cameraRotation.action.ReadValue<Vector2>().x<0 && listRightSpellAvailable[0] <= limit) //RIGHT STICK LEFT
                    {
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[0];
                        listRightSpellAvailable[0] = saveCurrentSpell;
                        UpdateLeftSpells();
                    }
                    if(cameraRotation.action.ReadValue<Vector2>().x>0 && listRightSpellAvailable[1] <= limit) //RIGHT STICK RIGHT
                    {
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[1];
                        listRightSpellAvailable[1] = saveCurrentSpell;
                        UpdateLeftSpells();
                    }
                    /*if(cameraRotation.action.ReadValue<Vector2>().y <-0.5 && cameraRotation.action.ReadValue<Vector2>().x>-0.5 && cameraRotation.action.ReadValue<Vector2>().x < 0.5 && listRightSpellAvailable[2] <= limit) //RIGHT STICK BOT
                    {
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[2];
                        listRightSpellAvailable[2] = saveCurrentSpell;
                        UpdateLeftSpells();
                    }
                    if(cameraRotation.action.ReadValue<Vector2>().x <-0.5 && cameraRotation.action.ReadValue<Vector2>().y >-0.5 && cameraRotation.action.ReadValue<Vector2>().y <0.5 && listRightSpellAvailable[3] <= limit) //RIGHT STICK LEFT
                    {
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[3];
                        listRightSpellAvailable[3] = saveCurrentSpell;
                        UpdateLeftSpells();
                    } */
                }
            }
        }
    }

    void UpdateRightSpells()
    {
        listLeftSpellAvailable.Sort();
        listRightSpellAvailable = listLeftSpellAvailable;
    }

    void UpdateLeftSpells()
    {
        listRightSpellAvailable.Sort();
        listLeftSpellAvailable = listRightSpellAvailable;
    }

    void CheckSelectedSpell()
    {
        if(hand == -1)
        {
            if(cameraRotation.action.ReadValue<Vector2>().x<0  && listLeftSpellAvailable[0] <= limit)
            {
                leftSelected = true;
                
            }
            else if(cameraRotation.action.ReadValue<Vector2>().x>0 && listLeftSpellAvailable[1] <= limit)
            {
                rightSelected = true;
            }
            /*else if(movement.action.ReadValue<Vector2>().y <-0.5 && movement.action.ReadValue<Vector2>().x>-0.5 && movement.action.ReadValue<Vector2>().x < 0.5 && listLeftSpellAvailable[2] <= limit)
            {
                botSelected = true;
            }
            else if(movement.action.ReadValue<Vector2>().x <-0.5 && movement.action.ReadValue<Vector2>().y >-0.5 && movement.action.ReadValue<Vector2>().y <0.5 && listLeftSpellAvailable[3] <= limit)
            {
                leftSelected = true;
            }*/
            else
            {
                leftSelected = false;
                rightSelected = false;
                /*botSelected = false;
                leftSelected=false;*/
            }
        }

        if(hand == 1)
        {
            if(cameraRotation.action.ReadValue<Vector2>().x<0 && listRightSpellAvailable[0] <= limit)
            {
                leftSelected = true;
            }
            else if(cameraRotation.action.ReadValue<Vector2>().x>0 && listRightSpellAvailable[1] <= limit)
            {
                rightSelected = true;
            }
            /*else if(cameraRotation.action.ReadValue<Vector2>().y <-0.5 && cameraRotation.action.ReadValue<Vector2>().x>-0.5 && cameraRotation.action.ReadValue<Vector2>().x < 0.5 && listRightSpellAvailable[2] <= limit)
            {
                botSelected = true;
            }
            else if(cameraRotation.action.ReadValue<Vector2>().x <-0.5 && cameraRotation.action.ReadValue<Vector2>().y >-0.5 && cameraRotation.action.ReadValue<Vector2>().y <0.5 && listRightSpellAvailable[3] <= limit)
            {
                leftSelected = true;
            }*/
            else
            {
                leftSelected = false;
                rightSelected = false;
                /*botSelected = false;
                leftSelected=false;*/
            }
        }

    }


    //SPELL NUMBER == 0 : FIREBALL
    [HideInInspector] public float cooldownFireball, timerFireball;
    [HideInInspector] public bool doNotFollow = true;

    //SPELL NUMBER == 1 : FIRECLONE
    [HideInInspector] public float cooldownFireClone, timerFireClone;
    [HideInInspector] public bool isMoving = true;

    //SPELL NUMBER == 2 : TELEKINESISCLONE
    [HideInInspector] public float cooldownTelekinesisClone, timerTelekinesisClone;
    [HideInInspector] public bool TelekinesisAlt = false;

    //SPELL NUMBER == 3 : IceClone
    [HideInInspector] public float cooldownIceClone, timerIceClone;
    [HideInInspector] public bool iceCloneAlt = false;



    /*//SPELL NUMBER == 3 : WAVE
    [HideInInspector] public float cooldownWave, timerWave;
    [HideInInspector] public bool waveAlt = false;

    //SPELL NUMBER == 4 : Iceball
    [HideInInspector] public float cooldownIceball, timerIceball;
    [HideInInspector] public bool iceballAlt = false;*/

    
    

    void CastSpell(int spellNb) 
    {
        if (spellNb == 0 && limit >= 0 && timerFireball >= cooldownFireball)     //CAST FIREBALL
        {
            //StopPlayerWhenCasting
            timerCastAnimation = 0;
            PlayerController.instance.isCasting = true;
            PlayerController.instance.refModel.forward = PlayerController.instance.transform.right;


            timerFireball = 0;
            Invoke("Fireball", spellAnimationTime);
        }

        if (spellNb == 1 && limit >= 1 && timerFireClone >= cooldownFireClone)     //CAST FIRECLONE
        {
            //StopPlayerWhenCasting
            timerCastAnimation = 0;
            PlayerController.instance.isCasting = true;
            PlayerController.instance.refModel.forward = PlayerController.instance.transform.right;


            timerFireClone = 0;
            Invoke("FireClone", spellAnimationTime);
        }

        if (spellNb == 2 && limit >= 2 && timerTelekinesisClone >= cooldownTelekinesisClone)     //CAST TELEKINESISCLONE
        {
            if(aimPoint.transform.GetComponent<MeshRenderer>().enabled == true || aimPointBoth1.transform.GetComponent<MeshRenderer>().enabled == true || aimPointBoth2.transform.GetComponent<MeshRenderer>().enabled == true)
            {
                //StopPlayerWhenCasting
            timerCastAnimation = 0;
            PlayerController.instance.isCasting = true;
            PlayerController.instance.refModel.forward = PlayerController.instance.transform.right;


            timerTelekinesisClone = 0;
            Invoke("TelekinesisClone", spellAnimationTime);
            }
        }

        if (spellNb == 3 && limit >= 3 && timerIceClone >= cooldownIceClone)     //CAST ICECLONE
        {
            if(aimPoint2.transform.GetComponent<MeshRenderer>().enabled == true || aimPointBoth1.transform.GetComponent<MeshRenderer>().enabled == true || aimPointBoth2.transform.GetComponent<MeshRenderer>().enabled == true)
            {
                //StopPlayerWhenCasting
                timerCastAnimation = 0;
                PlayerController.instance.isCasting = true;
                PlayerController.instance.refModel.forward = PlayerController.instance.transform.right;


                timerIceClone = 0;
                Invoke("IceClone", spellAnimationTime);
            }
        }

        /*if (spellNb == 4 && limit >= 4 && timerIceball >= cooldownIceball)     //CAST ICEBALL
        {
            //StopPlayerWhenCasting
            timerCastAnimation = 0;
            PlayerController.instance.isCasting = true;
            PlayerController.instance.refModel.forward = PlayerController.instance.transform.right;


            timerIceball = 0;
            Invoke("Iceball", spellAnimationTime);
        }

        if (spellNb == 5 && limit >= 5 && timerIceClone >= cooldownIceClone)     //CAST ICECLONE
        {
            if(aimPoint.transform.GetComponent<MeshRenderer>().enabled == true)
            {
                //StopPlayerWhenCasting
                timerCastAnimation = 0;
                PlayerController.instance.isCasting = true;
                PlayerController.instance.refModel.forward = PlayerController.instance.transform.right;


                timerIceClone = 0;
                Invoke("IceClone", spellAnimationTime);
            }
        }  */
    }




    //SPELLS
    void Fireball()
    {
        if(((SpellL == 0 && l2IsHold) || (SpellR == 0 && r2IsHold)) && inventory.fireballAlt)
        {
            doNotFollow = false;
        }
        else if((SpellL == 0 && !l2IsHold) || (SpellR == 0 && !r2IsHold))
        {
            doNotFollow = true;
        }

        GameObject f = Instantiate(fireball);
        f.GetComponent<Fireball>().player = transform.gameObject;
    }

    void FireClone()
    {
        if(((SpellL == 1 && l2IsHold) || (SpellR == 1 && r2IsHold)) && inventory.fireCloneAlt)
        {
            isMoving = false;
        }
        else if((SpellL == 1 && !l2IsHold) || (SpellR == 1 && !r2IsHold))
        {
            isMoving = true;
        }

        GameObject f = Instantiate(fireClone);
        f.GetComponent<FireClone>().player = transform.gameObject;
        f.transform.position = transform.position;
        f.transform.rotation = transform.rotation;
        f.transform.Rotate(new Vector3(transform.rotation.x, transform.rotation.y +90, transform.rotation.z));
    }

    void TelekinesisClone()
    {
        if(((SpellL == 2 && l2IsHold) || (SpellR == 2 && r2IsHold)) && inventory.telekinesisCloneAlt)
        {
            TelekinesisAlt = true;
            GetComponent<PlayerController>().isAttracted = true;
        }
        else if((SpellL == 2 && !l2IsHold) || (SpellR == 2 && !r2IsHold))
        {
            TelekinesisAlt = false;
        }
        
        GameObject t = Instantiate(telekinesisClone);
        t.transform.rotation = aimPoint.transform.rotation;
        t.transform.position = aimPoint.transform.position+ hit2.normal;//Vector3.up;
        /*t.transform.rotation = transform.rotation;
        t.transform.Rotate(new Vector3(transform.rotation.x, transform.rotation.y - 90, transform.rotation.z));*/
        
    }

    /*void Wave()
    {
        if(((SpellL == 3 && l2IsHold) || (SpellR == 3 && r2IsHold)) && inventory.waveAlt)
        {
            waveAlt = true;
        }
        else if((SpellL == 3 && !l2IsHold) || (SpellR == 3 && !r2IsHold))
        {
            waveAlt = false;
        }

        //INSTANTIATE SPELL
    }

    void Iceball()
    {
        if(((SpellL == 4 && l2IsHold) || (SpellR == 4 && r2IsHold)) && inventory.iceballAlt)
        {
            iceballAlt = true;
        }
        else if((SpellL == 4 && !l2IsHold) || (SpellR == 4 && !r2IsHold))
        {
            iceballAlt = false;
        }

        //INSTANTIATE SPELL
    }*/

    void IceClone()
    {   
        if(((SpellL == 3 && l2IsHold) || (SpellR == 3 && r2IsHold)) && inventory.iceCloneAlt)
        {
            iceCloneAlt = true;
        }
        else if((SpellL == 3 && !l2IsHold) || (SpellR == 3 && !r2IsHold))
        {
            iceCloneAlt = false;
        }
        

        //INSTANTIATE SPELL
        GameObject i = Instantiate(iceClone);
        i.transform.position = aimPoint2.transform.position + Vector3.up;
        i.transform.rotation = transform.rotation;
        i.transform.Rotate(new Vector3(transform.rotation.x, transform.rotation.y + 90, transform.rotation.z));

    
    }







    void FeedbackLeftBody()
    {
        if(SpellL == 0 && limit >=0)
        {
            if (timerFireball >= cooldownFireball)
            {
                feedback_LeftArm.SetActive(true);
            }
            else
            {
                feedback_LeftArm.SetActive(false);
            }
        }
        else if (SpellL == 1 && limit >=1)
        {
            if (timerFireClone >= cooldownFireClone)
            {
                feedback_LeftArm.SetActive(true);
            }
            else
            {
                feedback_LeftArm.SetActive(false);
            }
        }
        else if (SpellL == 2 && limit >=2)
        {
            if (timerTelekinesisClone >= cooldownTelekinesisClone)
            {
                feedback_LeftArm.SetActive(true);
            }
            else
            {
                feedback_LeftArm.SetActive(false);
            }
        }
        else if(SpellL == 3 && limit >=3)
        {
            if (timerIceClone >= cooldownIceClone)
            {
                feedback_LeftArm.SetActive(true);
            }
            else
            {
                feedback_LeftArm.SetActive(false);
            }
        }
        /*if(SpellL == 4 && limit >=4)
        {
            if (timerIceball >= cooldownIceball)
            {
                feedback_LeftArm.SetActive(true);
            }
            else
            {
                feedback_LeftArm.SetActive(false);
            }
        }
        if(SpellL == 5 && limit >=5)
        {
            if (timerIceClone >= cooldownIceClone)
            {
                feedback_LeftArm.SetActive(true);
            }
            else
            {
                feedback_LeftArm.SetActive(false);
            }
        }*/
        else feedback_LeftArm.SetActive(false);
    }


    void FeedbackRightBody()
    {
        if(SpellR == 0 && limit >=0)
        {
            if (timerFireball >= cooldownFireball)
            {
                feedback_RightArm.SetActive(true);
            }
            else
            {
                feedback_RightArm.SetActive(false);
            }
        }
        else if(SpellR == 1 && limit >=1)
        {
            if (timerFireClone >= cooldownFireClone)
            {
                feedback_RightArm.SetActive(true);
            }
            else
            {
                feedback_RightArm.SetActive(false);
            }
        }
        else if(SpellR == 2 && limit >=2)
        {
            if (timerTelekinesisClone >= cooldownTelekinesisClone)
            {
                feedback_RightArm.SetActive(true);
            }
            else
            {
                feedback_RightArm.SetActive(false);
            }
        }
        else if(SpellR == 3 && limit >=3)
        {
            if (timerIceClone >= cooldownIceClone)
            {
                feedback_RightArm.SetActive(true);
            }
            else
            {
                feedback_RightArm.SetActive(false);
            }
        }
        /*if(SpellR == 4 && limit >=4)
        {
            if (timerIceball >= cooldownIceball)
            {
                feedback_RightArm.SetActive(true);
            }
            else
            {
                feedback_RightArm.SetActive(false);
            }
        }
        if(SpellR == 5 && limit >=5)
        {
            if (timerIceClone >= cooldownIceClone)
            {
                feedback_RightArm.SetActive(true);
            }
            else
            {
                feedback_RightArm.SetActive(false);
            }
        }*/
        else feedback_RightArm.SetActive(false);
    }

    [SerializeField] float cloneRange;
    bool canPlaceTelekinesisClone, canPlaceIceClone;
    
    RaycastHit hit;
    void CamRaycast()
    {
           
        Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, Mathf.Infinity);
        

        if (limit>= 2 && (SpellL == 2 || SpellR == 2) && hit.collider != null && hit.distance<cloneRange && (hit.transform.gameObject.layer == LayerMask.NameToLayer("ground") || hit.transform.gameObject.layer == LayerMask.NameToLayer("Wall")))
        {
            canPlaceTelekinesisClone = true;
        }
        else
        {
            canPlaceTelekinesisClone = false;
        }
    }

    RaycastHit hit2;
    void CamRaycast2()
    {
        
        Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit2, Mathf.Infinity);


        if (limit>= 3 && (SpellL == 3 || SpellR == 3) && hit2.collider != null && hit2.distance<cloneRange && (hit2.transform.gameObject.layer == LayerMask.NameToLayer("ground") || hit2.transform.gameObject.layer == LayerMask.NameToLayer("CollideOnlyWithIceBall")))
        {
            canPlaceIceClone = true;
        }
        else
        {
            canPlaceIceClone = false;
        }
    }

    void AimpointSelection()
    {
        if(canPlaceTelekinesisClone && canPlaceIceClone)
        {
            aimPoint.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPoint2.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPoint.transform.position = Camera.main.transform.position + Camera.main.transform.forward * hit.distance ;
            aimPoint2.transform.position = Camera.main.transform.position + Camera.main.transform.forward * hit2.distance - Camera.main.transform.forward * 0.1f;
            aimPoint.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit.normal);
            aimPoint2.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit2.normal);
            

            if (limit>=3 && SpellL == 2 || SpellR == 3)
            {
                aimPointBoth2.transform.GetComponent<MeshRenderer>().enabled = false;

                aimPointBoth1.transform.GetComponent<MeshRenderer>().enabled = true;
                aimPointBoth1.transform.position = Camera.main.transform.position + Camera.main.transform.forward * hit2.distance - Camera.main.transform.forward * 0.1f;
                aimPointBoth1.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit2.normal);
            }
            else if (limit>=3 && SpellL == 3 || SpellR == 2)
            {
                aimPointBoth1.transform.GetComponent<MeshRenderer>().enabled = false;

                aimPointBoth2.transform.GetComponent<MeshRenderer>().enabled = true;
                aimPointBoth2.transform.position = Camera.main.transform.position + Camera.main.transform.forward * hit2.distance - Camera.main.transform.forward * 0.1f;
                aimPointBoth2.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit2.normal);
            }
            else
            {
                aimPointBoth1.transform.GetComponent<MeshRenderer>().enabled = false;
                aimPointBoth2.transform.GetComponent<MeshRenderer>().enabled = false;
                aimPoint.transform.GetComponent<MeshRenderer>().enabled = false;
                aimPoint2.transform.GetComponent<MeshRenderer>().enabled = false;
            }
        }
        else if (canPlaceTelekinesisClone)
        {
            //Debug.Log("TeleClone");
            aimPoint2.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPointBoth1.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPointBoth2.transform.GetComponent<MeshRenderer>().enabled = false;

            aimPoint.transform.GetComponent<MeshRenderer>().enabled=true;
            aimPoint.transform.position = Camera.main.transform.position + Camera.main.transform.forward * hit.distance;
            aimPoint.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit.normal);
        }
        else if (canPlaceIceClone)
        {
            //Debug.Log("iceClone");
            aimPoint.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPointBoth1.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPointBoth2.transform.GetComponent<MeshRenderer>().enabled = false;

            aimPoint2.transform.GetComponent<MeshRenderer>().enabled=true;
            aimPoint2.transform.position = Camera.main.transform.position + Camera.main.transform.forward * hit2.distance - Camera.main.transform.forward * 0.1f;
            aimPoint2.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit2.normal);
        }
        else
        {
            //Debug.Log("nop");
            aimPointBoth1.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPointBoth2.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPoint.transform.GetComponent<MeshRenderer>().enabled = false;
            aimPoint2.transform.GetComponent<MeshRenderer>().enabled = false;
        }
    }
}