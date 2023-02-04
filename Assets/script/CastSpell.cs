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
    GameObject viseur;

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
        //change spell left
        if (Input.GetButtonDown("ChangeSpellL"))
        {
            SpellL++;
            if (SpellL == SpellR)
            {
                SpellL++;
            }
            if (SpellL > Elements.Length - 1)
            {
                SpellL = 0;
            }
            if (SpellL == SpellR)
            {
                SpellL++;
            }
            print(SpellL);
        }


        //change spell right
        if (Input.GetButtonDown("ChangeSpellR"))
        {
            SpellR++;
            if (SpellR == SpellL)
            {
                SpellR++;
            }
            if (SpellR > Elements.Length - 1)
            {
                SpellR = 0;
            }
            if (SpellR == SpellL)
            {
                SpellR++;
            }
            print(SpellR);
        }


        //qi; input
        if (Input.GetAxis("Aim")< 0 || Input.GetMouseButtonDown(1))
        {
            if (aimed == false)
            {
                print("aim");
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
        if ((SpellL.ToString() + SpellR.ToString() == "12" || SpellL.ToString() + SpellR.ToString() == "21") && limit>1)
        {
            viseur.SetActive(true);
            CamRaycast();
        }
        else
        {
            viseur.SetActive(false);
        }
    }

    void Cast()
    {
        if ((SpellL.ToString()+SpellR.ToString()=="01" || SpellL.ToString() + SpellR.ToString() == "10") && limit>-1)
        {
            if (GameObject.Find("PrefabFireball(Clone)") == null)
            {
            

                GameObject f = Instantiate(fireBall);
                f.GetComponent<Fireball>().player = transform.gameObject;
                
            }
        }

        if ((SpellL.ToString() + SpellR.ToString() == "02" || SpellL.ToString() + SpellR.ToString() == "20")&& limit>0)
        {
            if (GameObject.Find("FireClone(Clone)") == null)
            {


                GameObject f = Instantiate(fireClone);
                f.GetComponent<FireClone>().player = transform.gameObject;
                f.transform.position = transform.position;

            }
        }

        if ((SpellL.ToString() + SpellR.ToString() == "12" || SpellL.ToString() + SpellR.ToString() == "21")&& limit > 1)
        {

            if (GameObject.Find("TelekinesisClone(Clone)") == null && viseur.transform.GetComponent<MeshRenderer>().enabled)
            {


                GameObject t = Instantiate(teleClone);
                t.transform.position = viseur.transform.position+Vector3.up;

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
}
