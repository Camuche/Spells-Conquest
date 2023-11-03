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
    int selecting;

    [HideInInspector] public bool topSelected = false, rightSelected = false, botSelected = false, leftSelected = false;

    [SerializeField] GameObject fireball, fireClone, telekinesisClone, wave, iceball, iceClone;

    UIupdate refUiUpdate;
    


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
    


    // Start is called before the first frame update
    void Start()
    {
        //Debug.Log(leftSpellAvailable);
        refUiUpdate = GameObject.Find("GameController").GetComponent<UIupdate>();
        timerFireball = 0;

        feedback_RightArm.SetActive(false);
        feedback_LeftArm.SetActive(false);
        
    }
    // Update is called once per frame
    void Update()
    {
        //Debug.Log(timerFireball);

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
        //Debug.Log(l2IsHold);

        //DELAY CAST SPELL
        //if()

        //TIMER    
        if (timerFireball <= cooldownFireball)
        {
            timerFireball += Time.deltaTime;
        }
        if(timerFireClone <= cooldownFireClone)
        {
            timerFireClone += Time.deltaTime;
        }

        FeedbackLeftBody();
        FeedbackRightBody();

        //Debug.Log(r2IsHold);
        //Debug.Log(l2IsHold);
        
    }

    public int hand;

    void SetSelecting()
    {
        //int hand;
        //int direction; // 0 = TOP , 1= RIGHT , 2 =BOT , 3=LEFT

        if (selecting == 0)
        {
            //selectStartPoint = new Vector3(0, 0, 0);
            //selectPoint = selectStartPoint;
            Cursor.lockState = CursorLockMode.Locked;
            Time.timeScale = 1f;
            refUiUpdate.DisableSelectionUi();
            //refSelectionUi.SetActive(false);

            if(leftSelection.action.ReadValue<float>() ==1)
            {
                selecting = -1;

                Debug.Log("_____________________________");
                Debug.Log("LEFT HAND");
                Debug.Log("current selected : " + SpellL);
                Debug.Log("spell TOP : " + listLeftSpellAvailable[0]);
                Debug.Log("spell RIGHT : " + listLeftSpellAvailable[1]);
                Debug.Log("spell BOT : " + listLeftSpellAvailable[2]);
                Debug.Log("spell LEFT : " + listLeftSpellAvailable[3]);
            }
            else if (rightSelection.action.ReadValue<float>() ==1)
            {
                selecting =1;

                Debug.Log("_____________________________");
                Debug.Log("RIGHT HAND");
                Debug.Log("current selected : " + SpellR);
                Debug.Log("spell TOP : " + listRightSpellAvailable[0]);
                Debug.Log("spell RIGHT : " + listRightSpellAvailable[1]);
                Debug.Log("spell BOT : " + listRightSpellAvailable[2]);
                Debug.Log("spell LEFT : " + listRightSpellAvailable[3]);
            }
        }

        int saveCurrentSpell = -1;

        if (selecting != 0)
        {
            Cursor.lockState = CursorLockMode.None;
            hand = selecting;
            //refUiUpdate.refHand = hand;
            Time.timeScale = 0.05f;
            refUiUpdate.EnableSelectionUi();
            refUiUpdate.UpdateUiSelection();
            CheckSelectedSpell();
            //refSelectionUi.SetActive(true);

            
            if (hand ==-1)
            {
                // RELEASED SELECTING
                if (leftSelection.action.ReadValue<float>() !=1)
                {
                    selecting =0;

                    if(movement.action.ReadValue<Vector2>().y >0.5 && movement.action.ReadValue<Vector2>().x>-0.5 && movement.action.ReadValue<Vector2>().x < 0.5 && listLeftSpellAvailable[0] <= limit) //LEFT STICK TOP
                    {
                        Debug.Log("TOP");
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[0];
                        listLeftSpellAvailable[0] = saveCurrentSpell;
                        UpdateRightSpells();
                        Debug.Log(SpellL);
                    }
                    if(movement.action.ReadValue<Vector2>().x >0.5 && movement.action.ReadValue<Vector2>().y >-0.5 && movement.action.ReadValue<Vector2>().y <0.5 && listLeftSpellAvailable[1] <= limit) //LEFT STICK RIGHT
                    {
                        Debug.Log("Right");
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[1];
                        listLeftSpellAvailable[1] = saveCurrentSpell;
                        UpdateRightSpells();
                        Debug.Log(SpellL);
                    }
                    if(movement.action.ReadValue<Vector2>().y <-0.5 && movement.action.ReadValue<Vector2>().x>-0.5 && movement.action.ReadValue<Vector2>().x < 0.5 && listLeftSpellAvailable[2] <= limit) //LEFT STICK BOT
                    {
                        Debug.Log("BOT");
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[2];
                        listLeftSpellAvailable[2] = saveCurrentSpell;
                        UpdateRightSpells();
                        Debug.Log(SpellL);
                    }
                    if(movement.action.ReadValue<Vector2>().x <-0.5 && movement.action.ReadValue<Vector2>().y >-0.5 && movement.action.ReadValue<Vector2>().y <0.5 && listLeftSpellAvailable[3] <= limit) //LEFT STICK LEFT
                    {
                        Debug.Log("Left");
                        saveCurrentSpell = SpellL;
                        SpellL = listLeftSpellAvailable[3];
                        listLeftSpellAvailable[3] = saveCurrentSpell;
                        UpdateRightSpells();
                        Debug.Log(SpellL);
                    }

                    
                    

                    
                }
            }
            if (hand == 1)
            {
                if (rightSelection.action.ReadValue<float>() !=1)
                {
                    selecting =0;

                    if(cameraRotation.action.ReadValue<Vector2>().y >0.5 && cameraRotation.action.ReadValue<Vector2>().x>-0.5 && cameraRotation.action.ReadValue<Vector2>().x < 0.5 && listRightSpellAvailable[0] <= limit) //RIGHT STICK TOP
                    {
                        Debug.Log("TOP");
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[0];
                        listRightSpellAvailable[0] = saveCurrentSpell;
                        UpdateLeftSpells();
                        Debug.Log(SpellR);
                    }
                    if(cameraRotation.action.ReadValue<Vector2>().x >0.5 && cameraRotation.action.ReadValue<Vector2>().y >-0.5 && cameraRotation.action.ReadValue<Vector2>().y <0.5 && listRightSpellAvailable[1] <= limit) //RIGHT STICK RIGHT
                    {
                        Debug.Log("Right");
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[1];
                        listRightSpellAvailable[1] = saveCurrentSpell;
                        UpdateLeftSpells();
                        Debug.Log(SpellR);
                    }
                    if(cameraRotation.action.ReadValue<Vector2>().y <-0.5 && cameraRotation.action.ReadValue<Vector2>().x>-0.5 && cameraRotation.action.ReadValue<Vector2>().x < 0.5 && listRightSpellAvailable[2] <= limit) //RIGHT STICK BOT
                    {
                        Debug.Log("BOT");
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[2];
                        listRightSpellAvailable[2] = saveCurrentSpell;
                        UpdateLeftSpells();
                        Debug.Log(SpellR);
                    }
                    if(cameraRotation.action.ReadValue<Vector2>().x <-0.5 && cameraRotation.action.ReadValue<Vector2>().y >-0.5 && cameraRotation.action.ReadValue<Vector2>().y <0.5 && listRightSpellAvailable[3] <= limit) //RIGHT STICK LEFT
                    {
                        Debug.Log("Left");
                        saveCurrentSpell = SpellR;
                        SpellR = listRightSpellAvailable[3];
                        listRightSpellAvailable[3] = saveCurrentSpell;
                        UpdateLeftSpells();
                        Debug.Log(SpellR);
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

    [HideInInspector] public float cooldownFireball, timerFireball;
    [HideInInspector] public bool doNotFollow = false;

    [HideInInspector] public float cooldownFireClone, timerFireClone;
    [HideInInspector] public bool isMoving = false;
    
    

    void CastSpell(int spellNb) 
    {
        if (spellNb == 0 && limit >= 0 && timerFireball >= cooldownFireball)     //CAST FIREBALL
        {
            timerFireball = 0;
            Invoke("Fireball", spellAnimationTime);
        }

        if (spellNb == 1 && limit >= 1 && timerFireClone >= cooldownFireClone)     //CAST FIREBALL
        {
            timerFireClone = 0;
            Invoke("FireClone", spellAnimationTime);
        }

        if (spellNb == 2 && limit >= 2)     //CAST FIREBALL
        {
            Debug.Log("TelekinsesisClone");
        }

        if (spellNb == 3 && limit >= 3)     //CAST FIREBALL
        {
            Debug.Log("Wave");
        }

        if (spellNb == 4 && limit >= 4)     //CAST FIREBALL
        {
            Debug.Log("Iceball");
        }

        if (spellNb == 5 && limit >= 5)     //CAST FIREBALL
        {
            Debug.Log("IceClone");
        }  

    }



    void Fireball()
    {
        if((SpellL == 0 && l2IsHold) || (SpellR == 0 && r2IsHold))
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
         if((SpellL == 1 && l2IsHold) || (SpellR == 1 && r2IsHold))
        {
            isMoving = true;
        }
        else if((SpellL == 1 && !l2IsHold) || (SpellR == 1 && !r2IsHold))
        {
            isMoving = false;
        }

        GameObject f = Instantiate(fireClone);
        f.GetComponent<FireClone>().player = transform.gameObject;
        f.transform.position = transform.position;
        f.transform.rotation = transform.rotation;
        f.transform.Rotate(new Vector3(transform.rotation.x, transform.rotation.y +90, transform.rotation.z));
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
        else feedback_RightArm.SetActive(false);

    }

    

    
    

}