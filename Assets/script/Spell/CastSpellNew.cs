using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;

public class CastSpellNew : MonoBehaviour
{
    // INT 0=fireball / 1=fireClone ...
    public int SpellL;
    public int SpellR;
    
    [HideInInspector] public List<int> listLeftSpellAvailable = new List<int>{2,3,4,5};
    [HideInInspector] public List<int> listRightSpellAvailable = new List<int>{2,3,4,5};

    public int limit;
    [HideInInspector] public int selecting;

    [HideInInspector] public bool topSelected = false, rightSelected = false, botSelected = false, leftSelected = false;

    [SerializeField] GameObject fireball, fireClone, telekinesisClone, wave, iceball, iceClone;

    gameController gameController;
    UIupdate refUiUpdate;

    [SerializeField] GameObject aimPoint;
    


    [System.Serializable]
    public struct structSpell
    {
        public string spell_name;
        public Sprite spell_image;
        public int id;
    }
    public structSpell[] structSpells = new structSpell[6];



    [SerializeField] private InputActionReference leftSelection, rightSelection, movement, cameraRotation, spellR2, spellL2;

    bool l2IsPressed=false, r2IsPressed=false, l2IsHold= false, r2IsHold = false;
    [SerializeField] float spellAnimationTime;

    public GameObject feedback_LeftArm;
    public GameObject feedback_RightArm;

    Inventory inventory;
    




    // Start is called before the first frame update
    void Start()
    {
        gameController = GameObject.Find("GameController").GetComponent<gameController>();
        refUiUpdate = GameObject.Find("GameController").GetComponent<UIupdate>();
        timerFireball = 0;

        feedback_RightArm.SetActive(false);
        feedback_LeftArm.SetActive(false);

        aimPoint = Instantiate(aimPoint);

        inventory = GetComponent<Inventory>();
        doNotFollow = true;
        isMoving= true;
        TelekinesisAlt = false;

    }


    // Update is called once per frame
    void Update()
    {
        if (limit > -1)
        {
            SetSelecting();
        }

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

        //Instantiate AIMPOINT
        if ((limit>=2 && (SpellL == 2 || SpellR == 2)) || (limit>=5 && (SpellL == 5 || SpellR == 5)))      //  SpellL == 3 || SpellL == 5 || SpellR == 3 || SpellR == 5)
        {
            aimPoint.SetActive(true);
            CamRaycast();
        }
        else
        {
            aimPoint.SetActive(false);
        }

        FeedbackLeftBody();
        FeedbackRightBody();       
    }


    public int hand;

    void SetSelecting()
    {
        if (selecting == 0)
        {
            if (!gameController.isPaused)
            {
                Cursor.lockState = CursorLockMode.Locked;
                Time.timeScale = 1f;
            }
            
            //Cursor.lockState = CursorLockMode.Locked;
            //Time.timeScale = 1f;
            refUiUpdate.DisableSelectionUi();

            if(leftSelection.action.ReadValue<float>() ==1)
            {
                selecting = -1;
            }
            else if (rightSelection.action.ReadValue<float>() ==1)
            {
                selecting =1;
            }
        }

        int saveCurrentSpell = -1;

        if (selecting != 0)
        {
            Cursor.lockState = CursorLockMode.None;
            hand = selecting;
            Time.timeScale = 0.05f;
            refUiUpdate.EnableSelectionUi();
            refUiUpdate.UpdateUiSelection();
            CheckSelectedSpell();

            
            //SELECT SPELL ON RELEASE (LEFT)
            if (hand ==-1)
            {
                if (leftSelection.action.ReadValue<float>() !=1)
                {
                    selecting =0;

                    if(movement.action.ReadValue<Vector2>().y >0.5 && movement.action.ReadValue<Vector2>().x>-0.5 && movement.action.ReadValue<Vector2>().x < 0.5 && listLeftSpellAvailable[0] <= limit) //LEFT STICK TOP
                    {
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[0];
                        listLeftSpellAvailable[0] = saveCurrentSpell;
                        UpdateRightSpells();
                    }
                    if(movement.action.ReadValue<Vector2>().x >0.5 && movement.action.ReadValue<Vector2>().y >-0.5 && movement.action.ReadValue<Vector2>().y <0.5 && listLeftSpellAvailable[1] <= limit) //LEFT STICK RIGHT
                    {
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[1];
                        listLeftSpellAvailable[1] = saveCurrentSpell;
                        UpdateRightSpells();
                    }
                    if(movement.action.ReadValue<Vector2>().y <-0.5 && movement.action.ReadValue<Vector2>().x>-0.5 && movement.action.ReadValue<Vector2>().x < 0.5 && listLeftSpellAvailable[2] <= limit) //LEFT STICK BOT
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
                    }
                }
            }


            
            //SELECT SPELL ON RELEASE (Right)
            if (hand == 1)
            {
                if (rightSelection.action.ReadValue<float>() !=1)
                {
                    selecting =0;

                    if(cameraRotation.action.ReadValue<Vector2>().y >0.5 && cameraRotation.action.ReadValue<Vector2>().x>-0.5 && cameraRotation.action.ReadValue<Vector2>().x < 0.5 && listRightSpellAvailable[0] <= limit) //RIGHT STICK TOP
                    {
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[0];
                        listRightSpellAvailable[0] = saveCurrentSpell;
                        UpdateLeftSpells();
                    }
                    if(cameraRotation.action.ReadValue<Vector2>().x >0.5 && cameraRotation.action.ReadValue<Vector2>().y >-0.5 && cameraRotation.action.ReadValue<Vector2>().y <0.5 && listRightSpellAvailable[1] <= limit) //RIGHT STICK RIGHT
                    {
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[1];
                        listRightSpellAvailable[1] = saveCurrentSpell;
                        UpdateLeftSpells();
                    }
                    if(cameraRotation.action.ReadValue<Vector2>().y <-0.5 && cameraRotation.action.ReadValue<Vector2>().x>-0.5 && cameraRotation.action.ReadValue<Vector2>().x < 0.5 && listRightSpellAvailable[2] <= limit) //RIGHT STICK BOT
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
                    } 
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
            if(movement.action.ReadValue<Vector2>().y >0.5 && movement.action.ReadValue<Vector2>().x>-0.5 && movement.action.ReadValue<Vector2>().x < 0.5 && listLeftSpellAvailable[0] <= limit)
            {
                topSelected = true;
            }
            else if(movement.action.ReadValue<Vector2>().x >0.5 && movement.action.ReadValue<Vector2>().y >-0.5 && movement.action.ReadValue<Vector2>().y <0.5 && listLeftSpellAvailable[1] <= limit)
            {
                rightSelected = true;
            }
            else if(movement.action.ReadValue<Vector2>().y <-0.5 && movement.action.ReadValue<Vector2>().x>-0.5 && movement.action.ReadValue<Vector2>().x < 0.5 && listLeftSpellAvailable[2] <= limit)
            {
                botSelected = true;
            }
            else if(movement.action.ReadValue<Vector2>().x <-0.5 && movement.action.ReadValue<Vector2>().y >-0.5 && movement.action.ReadValue<Vector2>().y <0.5 && listLeftSpellAvailable[3] <= limit)
            {
                leftSelected = true;
            }
            else
            {
                topSelected = false;
                rightSelected = false;
                botSelected = false;
                leftSelected=false;
            }
        }

        if(hand == 1)
        {
            if(cameraRotation.action.ReadValue<Vector2>().y >0.5 && cameraRotation.action.ReadValue<Vector2>().x>-0.5 && cameraRotation.action.ReadValue<Vector2>().x < 0.5 && listRightSpellAvailable[0] <= limit)
            {
                topSelected = true;
            }
            else if(cameraRotation.action.ReadValue<Vector2>().x >0.5 && cameraRotation.action.ReadValue<Vector2>().y >-0.5 && cameraRotation.action.ReadValue<Vector2>().y <0.5 && listRightSpellAvailable[1] <= limit)
            {
                rightSelected = true;
            }
            else if(cameraRotation.action.ReadValue<Vector2>().y <-0.5 && cameraRotation.action.ReadValue<Vector2>().x>-0.5 && cameraRotation.action.ReadValue<Vector2>().x < 0.5 && listRightSpellAvailable[2] <= limit)
            {
                botSelected = true;
            }
            else if(cameraRotation.action.ReadValue<Vector2>().x <-0.5 && cameraRotation.action.ReadValue<Vector2>().y >-0.5 && cameraRotation.action.ReadValue<Vector2>().y <0.5 && listRightSpellAvailable[3] <= limit)
            {
                leftSelected = true;
            }
            else
            {
                topSelected = false;
                rightSelected = false;
                botSelected = false;
                leftSelected=false;
            }
        }

    }


    //SPELL NUMBER == 0 : FIREBALL
    [HideInInspector] public float cooldownFireball, timerFireball;
    [HideInInspector] public bool doNotFollow = false;

    //SPELL NUMBER == 1 : FIRECLONE
    [HideInInspector] public float cooldownFireClone, timerFireClone;
    [HideInInspector] public bool isMoving = false;

    //SPELL NUMBER == 2 : TELEKINESISCLONE
    [HideInInspector] public float cooldownTelekinesisClone, timerTelekinesisClone;
    [HideInInspector] public bool TelekinesisAlt = false;
    

    void CastSpell(int spellNb) 
    {
        PlayerController.instance.refModel.forward = PlayerController.instance.transform.right;

        if (spellNb == 0 && limit >= 0 && timerFireball >= cooldownFireball)     //CAST FIREBALL
        {
            timerFireball = 0;
            Invoke("Fireball", spellAnimationTime);
        }

        if (spellNb == 1 && limit >= 1 && timerFireClone >= cooldownFireClone)     //CAST FIRECLONE
        {
            timerFireClone = 0;
            Invoke("FireClone", spellAnimationTime);
        }

        if (spellNb == 2 && limit >= 2 && timerTelekinesisClone >= cooldownTelekinesisClone)     //CAST TELEKINESISCLONE
        {
            if(aimPoint.transform.GetComponent<MeshRenderer>().enabled == true)
            {
            timerTelekinesisClone = 0;
            Invoke("TelekinesisClone", spellAnimationTime);
            }
        }

        if (spellNb == 3 && limit >= 3)     //CAST WAVE
        {
            Debug.Log("Wave");
        }

        if (spellNb == 4 && limit >= 4)     //CAST ICEBALL
        {
            Debug.Log("Iceball");
        }

        if (spellNb == 5 && limit >= 5)     //CAST ICECLONE
        {
            Debug.Log("IceClone");
        }  
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
        t.transform.position = aimPoint.transform.position+Vector3.up;
        t.transform.rotation = transform.rotation;
        t.transform.Rotate(new Vector3(transform.rotation.x, transform.rotation.y - 90, transform.rotation.z));

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
        else feedback_RightArm.SetActive(false);
    }

    [SerializeField] float cloneRange;
    void CamRaycast()
    {
        RaycastHit hit;
        Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, Mathf.Infinity);


        if (hit.collider != null && hit.distance<cloneRange && hit.transform.gameObject.layer == LayerMask.NameToLayer("ground"))
        {
            aimPoint.transform.GetComponent<MeshRenderer>().enabled=true;
            aimPoint.transform.position = Camera.main.transform.position + Camera.main.transform.forward * hit.distance;
            aimPoint.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit.normal);
        }
        else
        {
            aimPoint.transform.GetComponent<MeshRenderer>().enabled = false;
        }
    }
}