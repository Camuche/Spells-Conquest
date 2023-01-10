using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CastSpell : MonoBehaviour
{

    public int SpellL;
    public int SpellR;




    //structure de donnée d'un element (avec le nom de l'element, son image d'ui, etc...)
    [System.Serializable]
    public struct Element
    {
        public string spell_name;
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
            if (SpellL > Elements.Length - 1)
            {
                SpellL = 0;
            }
            print(SpellL);
        }


        //change spell right
        if (Input.GetButtonDown("ChangeSpellR"))
        {
            SpellR++;
            if (SpellR > Elements.Length - 1)
            {
                SpellR = 0;
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
                fired = true;
                Cast();
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
        if (SpellR == 0)
        {
            if (SpellR.Equals(spells.Fire))
            {
                if (SpellL.Equals(spells.Telekinesy))
                {
                    //boule de feu
                }
            }
        }
    }
}
