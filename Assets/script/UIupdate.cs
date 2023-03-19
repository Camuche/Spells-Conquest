using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class UIupdate : MonoBehaviour
{

    [SerializeField] GameObject _UI;
    GameObject UI;

    GameObject StaminaFront;
    GameObject StaminaBack;

    GameObject LeftSpellText;
    GameObject RightSpellText;

    GameObject LeftSpellImg;
    GameObject RightSpellImg;

    GameObject Combination;

    GameObject HealthBar;
    float healthbarsize;

    GameObject Crosshair;

    GameObject player;

    [SerializeField]Material mat_Stamina;

    // Start is called before the first frame update
    void Start()
    {

        UI = Instantiate(_UI);
        UI.transform.SetParent(transform.parent);

        StaminaFront = UI.transform.Find("StaminaFront").gameObject;
        StaminaBack = UI.transform.Find("StaminaBack").gameObject;

        HealthBar = UI.transform.Find("HealthFront").gameObject;
        healthbarsize = HealthBar.GetComponent<RectTransform>().sizeDelta.x;

        LeftSpellText = UI.transform.Find("SpellLText").gameObject;
        RightSpellText = UI.transform.Find("SpellRText").gameObject;

        LeftSpellImg = UI.transform.Find("SpellLImage").gameObject;
        RightSpellImg = UI.transform.Find("SpellRImage").gameObject;

        Combination = UI.transform.Find("Combination").gameObject;

        Crosshair = UI.transform.Find("Crosshair").gameObject;

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
                Combination.GetComponent<Image>().color = new Color(1f, 0f, 0f, 0f);

            }
            else
            {
                RightSpellImg.GetComponent<Image>().color = new Color(255, 255, 255, 1f);
                LeftSpellImg.GetComponent<Image>().color = new Color(255, 255, 255, 1f);
                Combination.GetComponent<Image>().color = new Color(0f, 1f, 0f, 1f);

            }


            RightSpellImg.SetActive(player.GetComponent<CastSpell>().limit > -1);
            LeftSpellImg.SetActive(player.GetComponent<CastSpell>().limit > -1);
            RightSpellText.SetActive(false);
            LeftSpellText.SetActive(false);
            Combination.SetActive(player.GetComponent<CastSpell>().limit > -1);



            HealthBar.GetComponent<RectTransform>().sizeDelta = new Vector2(player.GetComponent<PlayerController>().life*healthbarsize/(player.GetComponent<PlayerController>().lifeMax), HealthBar.GetComponent<RectTransform>().sizeDelta.y);
            StaminaFront.GetComponent<RectTransform>().sizeDelta = new Vector2((1.5f-player.GetComponent<PlayerController>().dashCoolDown) / 1.5f * StaminaBack.GetComponent<RectTransform>().sizeDelta.x, StaminaBack.GetComponent<RectTransform>().sizeDelta.y);
        }

        UI.SetActive(player.transform.Find("Main Camera").gameObject.activeSelf);

    }
}
