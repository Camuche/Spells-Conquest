using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class UIupdate : MonoBehaviour
{

    public GameObject LeftSpellText;
    public GameObject RightSpellText;
    public GameObject LeftSpellImg;
    public GameObject RightSpellImg;

    public GameObject player;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        RightSpellImg.GetComponent<Image>().sprite = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellR].spell_image;
        LeftSpellImg.GetComponent<Image>().sprite = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellL].spell_image;
        RightSpellText.GetComponent<Text>().text = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellR].spell_name;
        LeftSpellText.GetComponent<Text>().text = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellL].spell_name;

    }
}
