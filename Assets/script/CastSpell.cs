using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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

    [SerializeField] Animator animator;



    int selecting;
    public bool isPaused;

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
    }

    // Update is called once per frame
    void Update()
    {
        isPaused = GameObject.Find("GameController").GetComponent<gameController>().isPaused;

        SetSelecting();

        //change spell left
        if (Input.GetButtonDown("ChangeSpellL") && limit>-1)
        {
            SpellL++;

            while (!CheckValidation())
            {
                SpellL++;
                if (SpellL > Elements.Length - 1)
                {
                    SpellL = 0;
                }
            }
            print(SpellL);
        }


        //change spell right
        if (Input.GetButtonDown("ChangeSpellR") && limit > -1)
        {

            SpellR++;

            while (!CheckValidation())
            {
                
                SpellR++;
                if (SpellR > Elements.Length - 1)
                {
                    SpellR = 0;
                }
            }
            print(SpellR);
        }


        //aim input
        if (Input.GetAxis("Aim")> 0 || Input.GetMouseButtonDown(1))
        {
            if (aimed == false)
            {
                aimed = true;
            }
            
        }
        else
        {
            if (aimed)
            {
                aimed = false;
            }
        }


        //fire input
        if (Input.GetAxis("Fire")>0 || Input.GetMouseButtonDown(0))
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
        }

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
    }

    void SetSelecting()
    {
        
        if (selecting == 0 && (Input.GetButtonDown("ChangeSpellL") || Input.GetButtonDown("ChangeSpellR")))
        {
            selecting = Input.GetButtonDown("ChangeSpellL") ? -1 : 1;
        }

        if (selecting == -1 && Input.GetButtonUp("ChangeSpellL"))
        {
            selecting = 0;
        }

        if (selecting == 1 && Input.GetButtonUp("ChangeSpellR"))
        {
            selecting = 0;
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

        
    }


    public int getSelecting()
    {
        return selecting;
    }


    [SerializeField] float cooldownFireball;
    float timerFireball;
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

        if ((SpellL.ToString() + SpellR.ToString() == "32" || SpellL.ToString() + SpellR.ToString() == "23") && limit > 1)
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

        if ((SpellL.ToString() + SpellR.ToString() == "23" || SpellL.ToString() + SpellR.ToString() == "32") && limit > 3)
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
}
