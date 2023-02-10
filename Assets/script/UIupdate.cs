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

    public GameObject HealthBar;
    public GameObject Crosshair;
    float healthbarsize = 500;

    public GameObject player;

    [SerializeField]Material mat_Stamina;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (player == null)
        {
            player = GameObject.Find("Player");
        }

        if (player != null)
        {

            mat_Stamina.SetFloat("_Endurance",(float)(1.5f-player.GetComponent<PlayerController>().dashCoolDown)/1.5f);

            RightSpellImg.GetComponent<Image>().sprite = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellR].spell_image;
            RightSpellText.GetComponent<Text>().text = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellR].spell_name;

            LeftSpellImg.GetComponent<Image>().sprite = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellL].spell_image;
            LeftSpellText.GetComponent<Text>().text = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellL].spell_name;

            Crosshair.SetActive(Input.GetAxis("Aim") > 0 || Input.GetMouseButton(1));

            
            if (!player.GetComponent<CastSpell>().CheckValidation())
            {
                RightSpellImg.GetComponent<Image>().color = new Color(.2f, .2f, .2f, 1f);
                LeftSpellImg.GetComponent<Image>().color = new Color(.2f, .2f, .2f, 1f);

            }
            else
            {
                RightSpellImg.GetComponent<Image>().color = new Color(255, 255, 255, 1f);
                LeftSpellImg.GetComponent<Image>().color = new Color(255, 255, 255, 1f);
            }
            

            HealthBar.GetComponent<RectTransform>().sizeDelta = new Vector2(player.GetComponent<PlayerController>().life*healthbarsize/(player.GetComponent<PlayerController>().lifeMax), HealthBar.GetComponent<RectTransform>().sizeDelta.y);
        }

    }
}
