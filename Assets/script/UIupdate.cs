﻿using System.Collections;
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

    GameObject UIPlane;

    [SerializeField]Material mat_Stamina;
    [SerializeField] Material mat_UIPlane;

    Vector4[,] SubSpellPositions;


    GameObject[] SubSpell = new GameObject[4];

    [SerializeField] Sprite[] spellImg;


    // Start is called before the first frame update
    void Start()
    {

        SubSpellPositions = new Vector4[4, 2]
        {
            {new Vector4(-.58f, -1.21f,0,0), new Vector4(0,0,0,0) },
            {new Vector4(-1.36f, -0.43f,0,0), new Vector4(0,0,0,0) },
            {new Vector4(-7.41f, -1.21f,0,0), new Vector4(-8,0,0,0) },
            {new Vector4(-6.72f, -0.43f,0,0), new Vector4(-8,0,0,0) }
        };

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

        UIPlane = UI.transform.Find("CameraUI").transform.Find("UIPlane").gameObject;


        SubSpell[0] = UI.transform.Find("SubSpell01").gameObject;
        SubSpell[1] = UI.transform.Find("SubSpell02").gameObject;
        SubSpell[2] = UI.transform.Find("SubSpell03").gameObject;
        SubSpell[3] = UI.transform.Find("SubSpell04").gameObject;



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
        
            UI.SetActive(player.transform.Find("Main Camera").gameObject.activeSelf);
            AnimateSubSpells();
            mat_UIPlane.SetInt("_EnableSpell", player.GetComponent<CastSpell>().limit > -1 ? 1 : 0);
        }
        

        

        


        

    }


    void AnimateSubSpells()
    {

        

        Vector3 velocity = Vector3.zero;

        if (player.GetComponent<CastSpell>().getSelecting()!=0)
        {

            if (player.GetComponent<CastSpell>().getSelecting() == -1)
            {
                mat_UIPlane.SetVector("_SubSpell1_Position", Vector3.SmoothDamp(mat_UIPlane.GetVector("_SubSpell1_Position"), SubSpellPositions[0, 0], ref velocity, Time.deltaTime * 3));
                mat_UIPlane.SetVector("_SubSpell2_Position", Vector3.SmoothDamp(mat_UIPlane.GetVector("_SubSpell2_Position"), SubSpellPositions[1, 0], ref velocity, Time.deltaTime * 3));
            }
            if (player.GetComponent<CastSpell>().getSelecting() == 1)
            {
                mat_UIPlane.SetVector("_SubSpell4_Position", Vector3.SmoothDamp(mat_UIPlane.GetVector("_SubSpell4_Position"), SubSpellPositions[2, 0], ref velocity, Time.deltaTime * 3));
                mat_UIPlane.SetVector("_SubSpell5_Position", Vector3.SmoothDamp(mat_UIPlane.GetVector("_SubSpell5_Position"), SubSpellPositions[3, 0], ref velocity, Time.deltaTime * 3));
            }
        }
        else
        {
            mat_UIPlane.SetVector("_SubSpell1_Position", Vector3.SmoothDamp(mat_UIPlane.GetVector("_SubSpell1_Position"), SubSpellPositions[0, 1], ref velocity, Time.deltaTime * 3));
            mat_UIPlane.SetVector("_SubSpell2_Position", Vector3.SmoothDamp(mat_UIPlane.GetVector("_SubSpell2_Position"), SubSpellPositions[1, 1], ref velocity, Time.deltaTime * 3));
            mat_UIPlane.SetVector("_SubSpell4_Position", Vector3.SmoothDamp(mat_UIPlane.GetVector("_SubSpell4_Position"), SubSpellPositions[2, 1], ref velocity, Time.deltaTime * 3));
            mat_UIPlane.SetVector("_SubSpell5_Position", Vector3.SmoothDamp(mat_UIPlane.GetVector("_SubSpell5_Position"), SubSpellPositions[3, 1], ref velocity, Time.deltaTime * 3));
        }

        if (player.GetComponent<CastSpell>().getSelecting() == -1)
        {
            SubSpell[0].GetComponent<Image>().enabled = (true);
            SubSpell[1].GetComponent<Image>().enabled = (true);

            SetSpellImgs(0, 1);

            
        }

        if (player.GetComponent<CastSpell>().getSelecting() == 1)
        {
            SubSpell[2].GetComponent<Image>().enabled = (true);
            SubSpell[3].GetComponent<Image>().enabled = (true);

            SetSpellImgs(2, 3);
        }




        for (int i = 0; i < 4; i++)
        {
            if (player.GetComponent<CastSpell>().getSelecting() == 0)
            {
                SubSpell[i].GetComponent<Image>().enabled = (false);
            }
            SubSpell[i].GetComponent<RectTransform>().position = mat_UIPlane.GetVector("_SubSpell"+(i+(i>1?2:1)).ToString()+"_Position") * (-95* ((float)Display.main.renderingWidth/1000));
        }

    }


    void SetSpellImgs(int a, int b)
    {
        if (player.GetComponent<CastSpell>().getCombination() == "01")
        {
            SubSpell[a].GetComponent<Image>().sprite = spellImg[2];
            SubSpell[b].GetComponent<Image>().sprite = spellImg[3];

        }
        if (player.GetComponent<CastSpell>().getCombination() == "02")
        {
            SubSpell[a].GetComponent<Image>().sprite = spellImg[1];
            SubSpell[b].GetComponent<Image>().sprite = spellImg[3];
        }
        if (player.GetComponent<CastSpell>().getCombination() == "03")
        {
            SubSpell[a].GetComponent<Image>().sprite = spellImg[1];
            SubSpell[b].GetComponent<Image>().sprite = spellImg[2];
        }
        if (player.GetComponent<CastSpell>().getCombination() == "12")
        {
            SubSpell[a].GetComponent<Image>().sprite = spellImg[0];
            SubSpell[b].GetComponent<Image>().sprite = spellImg[3];
        }
        if (player.GetComponent<CastSpell>().getCombination() == "23")
        {
            SubSpell[a].GetComponent<Image>().sprite = spellImg[0];
            SubSpell[b].GetComponent<Image>().sprite = spellImg[1];
        }
        if (player.GetComponent<CastSpell>().getCombination() == "13")
        {
            SubSpell[a].GetComponent<Image>().sprite = spellImg[0];
            SubSpell[b].GetComponent<Image>().sprite = spellImg[2];
        }
    }


    
}
