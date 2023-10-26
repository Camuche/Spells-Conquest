using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;


public class CastSpell : MonoBehaviour
{

    public int SpellL;
    public int SpellR;


    public int limit;

    public GameObject fireBall;
    public GameObject fireClone;
    public GameObject teleClone;
    public GameObject AimPoint;
    

    [SerializeField] GameObject wave;
    [SerializeField] GameObject iceBall;
    [SerializeField] GameObject iceClone;


    GameObject viseur;

    public Animator animator;

    
    bool leftSpellSelected;
    bool rightSpellSelected;


    int selecting;
    public bool isPaused;

    

    public GameObject previsualisation_LeftArm;
    public GameObject previsualisation_RightArm;

    public Material matUI;

    

    [SerializeField] private InputActionReference spell, spellAlt, leftSelection, rightSelection, movement, cameraRotation;
    
    [HideInInspector] public bool doNotFollow;

    //structure de donnée d'un element (avec le nom de l'element, son image d'ui, etc...)
    [System.Serializable]
    public struct Element
    {
        public string spell_name;
        public Sprite spell_image;
        public int id;
    }

    
    public Element[] Elements = new Element[3];

    


    enum spells
    {
        Fire,
        Telekinesy,
        Clone
    }

    bool aimed = false;
    bool fired = false;


    // Start is called before the first frame update
    void Start()
    {
        viseur = Instantiate(AimPoint);
        matUI.SetFloat("_SpellAvailable", 0);
        
    }


    void OnEnable()
    {
        spell.action.performed += PerformSpell;
        spellAlt.action.performed += PerformSpellAlt;
    }

    void OnDisable()
    {
        spell.action.performed -= PerformSpell;
        spellAlt.action.performed -= PerformSpellAlt;
    }

    private void PerformSpell(InputAction.CallbackContext obj)
    {
        if (limit>-1)
            {
                
                doNotFollow = true; // fireball won't follow 
                Cast();
                
                
            }
    }

    private void PerformSpellAlt(InputAction.CallbackContext obj)
    {
        if (limit>-1)
            {
                
                doNotFollow = false; //  fireball will follow
                Cast();
                
            }

    }


    // Update is called once per frame
    void Update()
    {
        //Debug.Log(leftSelection.action.ReadValue<float>());
        isPaused = GameObject.Find("GameController").GetComponent<gameController>().isPaused;

        if (limit > -1)
        {
            SetSelecting();
        }
        

        


        //fire input
        /*if (Input.GetAxis("Fire")>0 || Input.GetMouseButtonDown(0))
        {

            if (fired == false && limit>-1)
            {
                Cast();
                fired = true;
                
            }
            
        }
        else
        {
            if (fired)
            {
                fired = false;
            }
        }*/

        //aiming in case it is tele-clone
        if ((SpellL.ToString() + SpellR.ToString() == "12" || SpellL.ToString() + SpellR.ToString() == "21" || SpellL.ToString() + SpellR.ToString() == "32" || SpellL.ToString() + SpellR.ToString() == "23") && CheckValidation())
        {
            viseur.SetActive(true);
            CamRaycast();
        }
        else
        {
            viseur.SetActive(false);
        }

        timerFireball += Time.deltaTime;
        timerIceball += Time.deltaTime;

        // PREVISUALISATION FOREARM
        if ((SpellL.ToString() + SpellR.ToString() == "01" || SpellL.ToString() + SpellR.ToString() == "10") && limit > -1)
        {
            if (timerFireball >= cooldownFireball)
            {
                feedbackSpellAvailable();
            }
            else
            {
                feedbackSpellNotAvailable();
            }

        }
        else if ((SpellL.ToString() + SpellR.ToString() == "02" || SpellL.ToString() + SpellR.ToString() == "20") && limit > 0 && GameObject.Find("PrefabFireShield(Clone)") == null)
        {
            feedbackSpellAvailable();
        }
        else
        {
            feedbackSpellNotAvailable();
        }
    }


    Vector3 selectStartPoint;
    Vector3 selectPoint;


    void SetSelecting()
    {
        float hand=0;
        float angle = 0;

        if (selecting == 0)
        {
            selectStartPoint = new Vector3(0, 0, 0);
            selectPoint = selectStartPoint;
            Cursor.lockState = CursorLockMode.Locked;
        }

        if (selecting != 0)
        {
            Cursor.lockState = CursorLockMode.None;
            hand = selecting;

            if (hand == 1)
            {
                selectPoint = new Vector3(Input.GetAxis("Mouse X"), Input.GetAxis("Mouse Y"), 0);
                if (Input.GetAxis("Mouse Y") < 0)
                    selectPoint = Vector3.zero;
            }
            if (hand == -1)
            {
                selectPoint = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"), 0);
                if (Input.GetAxis("Vertical") < 0)
                    selectPoint = Vector3.zero;
            }
        }

        
        if(hand ==-1 && movement.action.ReadValue<Vector2>().x >0 && movement.action.ReadValue<Vector2>().y >0)
        {
            /*if (selectPoint == Vector3.zero)
            {
                angle = -1;
            }
            else
            {
                angle = Vector3.SignedAngle(Vector3.right, (selectPoint - (selectStartPoint + selectStartPoint * hand)), Vector3.right);
            }*/
            leftSpellSelected = true;

        }
        else leftSpellSelected = false;

        if(hand ==1 && cameraRotation.action.ReadValue<Vector2>().x <0 && cameraRotation.action.ReadValue<Vector2>().y >0)
        {
            /*if (selectPoint == Vector3.zero)
            {
                angle = -1;
            }
            else
            {
                angle = Vector3.SignedAngle(Vector3.right, (selectPoint - (selectStartPoint + selectStartPoint * hand)), Vector3.right);
            }*/
            rightSpellSelected = true;
            Debug.Log(rightSpellSelected);
        }
        else rightSpellSelected = false;


        /*if (Input.GetJoystickNames().Length>0 && Input.GetJoystickNames()[0]!="")
        {
            if (selectPoint == Vector3.zero)
            {
                angle = -1;
            }
            else
            {
                angle = Vector3.SignedAngle(Vector3.right, (selectPoint - (selectStartPoint + selectStartPoint * hand)), Vector3.right);
            }
            

        }else if (Input.GetAxis("Mouse Y") == 0 && Input.GetAxis("Mouse X")==0)
        {
            //calcul angle souris (wtf unity)
            angle = Vector3.SignedAngle(Vector3.right, new Vector3(Input.mousePosition.x-(hand==1? Screen.width : 0),Input.mousePosition.y,0), Vector3.right);
        }*/



        //print(Input.mousePosition.x);
        //print(new Vector3(Input.mousePosition.x - (hand == 1 ? Screen.width : 0), Input.mousePosition.y, 0) + "    "+angle);


        //print(selectStartPoint + " " + selectPoint + " " + angle);

        if (selecting == 0 && (leftSelection.action.ReadValue<float>() ==1 || rightSelection.action.ReadValue<float>() ==1)) // Input.GetButtonDown("ChangeSpellL") || Input.GetButtonDown("ChangeSpellR")))
        {
            selecting =  leftSelection.action.ReadValue<float>() ==1 ? -1 : 1;   //Input.GetButtonDown("ChangeSpellL") ? -1 : 1;
        }

        if (selecting == -1 && leftSelection.action.ReadValue<float>() !=1)// Input.GetButtonUp("ChangeSpellL"))
        {
            selecting = 0;

            if(selectStartPoint.y<Input.mousePosition.y)
                SelectNewSpell(angle, -1);
        }

        if (selecting == 1 && rightSelection.action.ReadValue<float>() !=1)//Input.GetButtonUp("ChangeSpellR"))
        {
            selecting = 0;
            if (selectStartPoint.y < Input.mousePosition.y)
                SelectNewSpell(angle, 1);

        }

        //set time scale
        if (isPaused == false)
        {
            if (selecting == 0)
            {

                if (Time.timeScale < 1)
                {
                    Time.timeScale += Time.deltaTime * 10f;
                }
                else
                {
                    Time.timeScale = 1;
                }
            }
            else
            {
                if (Time.timeScale > 0.05f)
                {
                    Time.timeScale -= Time.deltaTime * 10f;
                }
            }
        }


        //set highlight
        GameObject.Find("GameController").GetComponent<UIupdate>().SetSubSpellHighLight(angle, selecting);

    }


    void SelectNewSpell(float angle, int hand)
    {

        GameObject UI = GameObject.Find("UI(Clone)");
        //Debug.Log(angle);

        if (hand == -1)
        {
            /*if (angle >= 0 && angle < 45)
            {
                switch (UI.transform.Find("SubSpell02").GetComponent<Image>().sprite.name) {
                    case "Spell_Fire" : SetNewSpell(0,0);break;
                    case "Spell_Telekinesie": SetNewSpell(0, 1); break;
                    case "Spell_Clone": SetNewSpell(0, 2); break;
                    case "Spell_Ice": SetNewSpell(0, 3); break;
                }
            }*/
            //if (leftSpellSelected == true)//angle >= 0 && angle <= 90)
            //{
                switch (UI.transform.Find("SubSpell01").GetComponent<Image>().sprite.name)
                {
                    case "Spell_Fire": SetNewSpell(0, 0); break;
                    case "Spell_Telekinesie": SetNewSpell(0, 1); break;
                    case "Spell_Clone": SetNewSpell(0, 2); break;
                    case "Spell_Ice": SetNewSpell(0, 3); break;
                }
            //}
        }

        if (hand == 1)
        {
            /*if (angle >= 90 && angle < 135)
            {
                switch (UI.transform.Find("SubSpell03").GetComponent<Image>().sprite.name)
                {
                    case "Spell_Fire": SetNewSpell(1, 0); break;
                    case "Spell_Telekinesie": SetNewSpell(1, 1); break;
                    case "Spell_Clone": SetNewSpell(1, 2); break;
                    case "Spell_Ice": SetNewSpell(1, 3); break;
                }
            }*/
            //if (rightSpellSelected == true)//angle >= 135 && angle <= 180)
            //{
                switch (UI.transform.Find("SubSpell03").GetComponent<Image>().sprite.name)
                {
                    case "Spell_Fire": SetNewSpell(1, 0); break;
                    case "Spell_Telekinesie": SetNewSpell(1, 1); break;
                    case "Spell_Clone": SetNewSpell(1, 2); break;
                    case "Spell_Ice": SetNewSpell(1, 3); break;
                }
            //}
        }
    }

    void SetNewSpell(int hand, int spell)
    {
        print(spell);
        int iniL = SpellL;
        int iniR = SpellR;

        if (hand == 0)
            SpellL = spell;
        
        if (hand == 1)
            SpellR = spell;

        
        if (!CheckValidation())
        {
            SpellL = iniL;
            SpellR = iniR;
        }
        
        
    }


    public int getSelecting()
    {
        return selecting;
    }


    [HideInInspector]public float cooldownFireball;
    [HideInInspector] public float timerFireball;
    [SerializeField] float cooldownIceball;
    float timerIceball;
    
    void Cast()
    {
        animator.SetTrigger("Throw");

        if ((SpellL.ToString()+SpellR.ToString()=="01" || SpellL.ToString() + SpellR.ToString() == "10") && limit>-1)
        {
            if (timerFireball >= cooldownFireball)
            {   
                

                GameObject f = Instantiate(fireBall);
                f.GetComponent<Fireball>().player = transform.gameObject;
                timerFireball = 0f;
                

                
            }
        }

        //Vector3 directionClone = transform.rotation.right;
        //Quaternion rotationClone = transform.rotation
        if ((SpellL.ToString() + SpellR.ToString() == "02" || SpellL.ToString() + SpellR.ToString() == "20")&& limit>0)
        {
            if (GameObject.Find("PrefabFireShield(Clone)") == null)
            {


                GameObject f = Instantiate(fireClone);
                f.GetComponent<FireClone>().player = transform.gameObject;
                f.transform.position = transform.position;
                f.transform.rotation = transform.rotation;
                f.transform.Rotate(new Vector3(transform.rotation.x, transform.rotation.y +90, transform.rotation.z));

            }
        }

        if ((SpellL.ToString() + SpellR.ToString() == "12" || SpellL.ToString() + SpellR.ToString() == "21")&& limit > 1)
        {

            if (GameObject.Find("TelekinesisClone(Clone)") == null && viseur.transform.GetComponent<MeshRenderer>().enabled)
            {


                GameObject t = Instantiate(teleClone);
                t.transform.position = viseur.transform.position+Vector3.up;
                t.transform.rotation = transform.rotation;
                t.transform.Rotate(new Vector3(transform.rotation.x, transform.rotation.y - 90, transform.rotation.z));

            }
        }

        if ((SpellL.ToString() + SpellR.ToString() == "03" || SpellL.ToString() + SpellR.ToString() == "30") && limit > 2)
        {
            if (GameObject.Find("Wave(Clone)") == null)
            {

                GameObject w = Instantiate(wave);
                w.transform.rotation = transform.rotation;
                w.transform.position = transform.position + transform.right * 1+transform.up*-1;

            }
        }

        if ((SpellL.ToString() + SpellR.ToString() == "13" || SpellL.ToString() + SpellR.ToString() == "31") && limit > 3)
        {

            if (timerIceball >= cooldownIceball)
            {


                GameObject i = Instantiate(iceBall);
                i.transform.position = transform.position + transform.right * 1 + transform.up * -1;
                i.GetComponent<IceBall>().player = transform.gameObject;
                timerIceball = 0f;


            }

            
        }

        if ((SpellL.ToString() + SpellR.ToString() == "32" || SpellL.ToString() + SpellR.ToString() == "23") && limit > 4)
        {

            if (GameObject.Find("IceExplosion(Clone)") == null && GameObject.Find("IceClone(Clone)") == null && viseur.transform.GetComponent<MeshRenderer>().enabled)
            {


                GameObject i = Instantiate(iceClone);
                i.transform.position = viseur.transform.position + Vector3.up;
                i.transform.rotation = transform.rotation;
                i.transform.Rotate(new Vector3(transform.rotation.x, transform.rotation.y + 90, transform.rotation.z));

            }
        }

    }

    

    void CamRaycast()
    {
        RaycastHit hit;
        Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, Mathf.Infinity);


        if (hit.collider != null && hit.distance<200 && hit.transform.gameObject.layer == LayerMask.NameToLayer("ground"))
        {
            viseur.transform.GetComponent<MeshRenderer>().enabled=true;
            viseur.transform.position = Camera.main.transform.position + Camera.main.transform.forward * hit.distance;
            viseur.transform.rotation = Quaternion.FromToRotation(Vector3.up, hit.normal);
        }
        else
        {
            viseur.transform.GetComponent<MeshRenderer>().enabled = false;
        }
    }

    public bool CheckValidation()
    {
        if ((SpellL.ToString() + SpellR.ToString() == "01" || SpellL.ToString() + SpellR.ToString() == "10") && limit > -1)
        {
            return true;
        }

        if ((SpellL.ToString() + SpellR.ToString() == "02" || SpellL.ToString() + SpellR.ToString() == "20") && limit > 0)
        {
            return true;
        }

        if ((SpellL.ToString() + SpellR.ToString() == "12" || SpellL.ToString() + SpellR.ToString() == "21") && limit > 1)
        {

            return true;
        }

        if ((SpellL.ToString() + SpellR.ToString() == "03" || SpellL.ToString() + SpellR.ToString() == "30") && limit > 2)
        {
            return true;
        }
        if ((SpellL.ToString() + SpellR.ToString() == "13" || SpellL.ToString() + SpellR.ToString() == "31") && limit > 3)
        {
            return true;
        }

        if ((SpellL.ToString() + SpellR.ToString() == "23" || SpellL.ToString() + SpellR.ToString() == "32") && limit > 4)
        {
            return true;
        }

        return false;
    }

    public bool CheckValidationRef(string s1, string s2)
    {
        if ((s1+s2 == "01" || s1+s2 == "10") && limit > -1)
        {
            return true;
        }

        if ((s1+s2 == "02" || s1 + s2 == "20") && limit > 0)
        {
            return true;
        }

        if ((s1 + s2 == "12" || s1 + s2 == "21") && limit > 1)
        {

            return true;
        }

        if ((s1 + s2 == "03" || s1 + s2 == "30") && limit > 2)
        {
            return true;
        }
        if ((s1 + s2 == "13" || s1 + s2 == "31") && limit > 3)
        {
            return true;
        }

        if ((s1 + s2 == "23" || s1 + s2 == "32") && limit > 4)
        {
            return true;
        }

        return false;
    }



    public string getCombination()
    {
        if (SpellL > SpellR)
        {
            return SpellR.ToString() + SpellL.ToString();
        }
        if (SpellL <= SpellR)
        {
            return SpellL.ToString() + SpellR.ToString();
        }

        return SpellL.ToString() + SpellR.ToString();
    }

    void feedbackSpellAvailable()
    {
        previsualisation_LeftArm.SetActive(true);
        previsualisation_RightArm.SetActive(true);
        matUI.SetFloat("_SpellAvailable", 1);
    }
    void feedbackSpellNotAvailable()
    {
        previsualisation_LeftArm.SetActive(false);
        previsualisation_RightArm.SetActive(false);
        matUI.SetFloat("_SpellAvailable", 0);
    }
}
