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
            if (SpellL > Elements.Length - 1 || SpellL>limit)
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
            if (SpellR > Elements.Length - 1 || SpellR > limit)
            {
                SpellR = 0;
            }
            if (SpellR == SpellL)
            {
                SpellR++;
            }
            print(SpellR);
        }


        //fire input
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

            if (fired == false)
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
    }

    void Cast()
    {

        if (SpellL.ToString()+SpellR.ToString()=="01" || SpellL.ToString() + SpellR.ToString() == "10")
        {
            if (GameObject.Find("Fireball(Clone)") == null)
            {
            

                GameObject f = Instantiate(fireBall);
                f.GetComponent<Fireball>().player = transform.gameObject;
                
            }
        }

        if (SpellL.ToString() + SpellR.ToString() == "02" || SpellL.ToString() + SpellR.ToString() == "20")
        {
            //if (GameObject.Find("FireClone(Clone)") == null)
            {


                GameObject f = Instantiate(fireClone);
                f.GetComponent<FireClone>().player = transform.gameObject;
                f.transform.position = transform.position;

            }
        }
    }
}
