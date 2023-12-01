using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;





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

    gameController refGameController;

    [SerializeField]Material mat_Stamina;
    [SerializeField] Material mat_UIPlane;

    Vector4[,] SubSpellPositions;


    GameObject[] SubSpell = new GameObject[4];

    [SerializeField] Sprite[] spellImg;

    [HideInInspector] public bool isPaused;
    //GameObject refSensitivity;
    //GameObject refEsc_BlackScreen;
    [SerializeField] private GameObject refPauseScreen;
    GameObject refSelectionUi;

    CastSpellNew refCastSpellNew;
    GameObject currentSpellUi, spellTopUi, spellRightUi, spellBotUi, spellLeftUi;
    [SerializeField] Material matFireball, matFireClone, matTelekinesesClone, matWave, matIceball, matIceClone;
    GameObject cameraShop;
    //public int refHand;

    [SerializeField] TMP_Text lifeTMP;


    private void OnLevelWasLoaded(int level)
    {
        //FocusManager.Instance.UpdateCanvasEventSystems();
    }


    // Start is called before the first frame update
    void Start()
    {

        /*SubSpellPositions = new Vector4[4, 2]
        {
            {new Vector4(-.58f, -1.21f,0,0), new Vector4(0,0,0,0) },
            {new Vector4(-1.36f, -0.43f,0,0), new Vector4(0,0,0,0) },
            {new Vector4(-7.41f, -1.21f,0,0), new Vector4(-8,0,0,0) },
            {new Vector4(-6.72f, -0.43f,0,0), new Vector4(-8,0,0,0) }
        };*/

        UI = Instantiate(_UI);
        UI.transform.SetParent(transform.parent);

        StaminaFront = UI.transform.Find("StaminaFront").gameObject;
        StaminaBack = UI.transform.Find("StaminaBack").gameObject;

        HealthBar = UI.transform.Find("HealthFront").gameObject;
        healthbarsize = HealthBar.GetComponent<RectTransform>().sizeDelta.x;

        LeftSpellText = UI.transform.Find("SpellLText").gameObject;
        RightSpellText = UI.transform.Find("SpellRText").gameObject;

        LeftSpellImg = GameObject.Find("SpellLImage");
        RightSpellImg = GameObject.Find("SpellRImage");

        LeftSpellImg.SetActive(false);
        RightSpellImg.SetActive(false);

        Crosshair = UI.transform.Find("Crosshair").gameObject;

        UIPlane = UI.transform.Find("CameraUI").transform.Find("UIPlane").gameObject;
        refSelectionUi =  UI.transform.Find("CameraUI").transform.Find("Selection").gameObject;
        DisableSelectionUi();

        refGameController = GameObject.Find("GameController").GetComponent<gameController>();
        


        /*SubSpell[0] = UI.transform.Find("SubSpell01").gameObject;
        SubSpell[1] = UI.transform.Find("SubSpell02").gameObject;
        SubSpell[2] = UI.transform.Find("SubSpell03").gameObject;
        SubSpell[3] = UI.transform.Find("SubSpell04").gameObject;*/


        
        /*refSensitivity = GameObject.Find("Sensitivity");
        refSensitivity.SetActive(false);

        refEsc_BlackScreen = GameObject.Find("Esc_BlackScreen");
        refEsc_BlackScreen.SetActive(false);*/
        refPauseScreen = GameObject.Find("PauseScreen");
        refPauseScreen.SetActive(false);

        currentSpellUi = UI.transform.Find("CameraUI").transform.Find("Selection").transform.Find("CurrentSpell").gameObject;
        spellLeftUi = UI.transform.Find("CameraUI").transform.Find("Selection").transform.Find("SpellLeft").gameObject;
        spellRightUi = UI.transform.Find("CameraUI").transform.Find("Selection").transform.Find("SpellRight").gameObject;
        spellBotUi = UI.transform.Find("CameraUI").transform.Find("Selection").transform.Find("SpellBot").gameObject;
        spellTopUi = UI.transform.Find("CameraUI").transform.Find("Selection").transform.Find("SpellTop").gameObject;

        //refCastSpellNew = GameObject.Find("Player").GetComponent<CastSpellNew>();

        spellLeftUi.SetActive(false);
        spellRightUi.SetActive(false);
        spellBotUi.SetActive(false);
        spellTopUi.SetActive(false);
        
        mat_UIPlane.SetInt("_EnableSpell", 0);

        cameraShop = GameObject.Find("CameraShop");
        Shop.instance.GetShopButton();
        DisableShopUi();
        
        lifeTMP = GameObject.Find("LifeTMP").GetComponent<TMP_Text>();
        lifeTMP.text = PlayerController.instance.life + " / " + PlayerController.lifeMax;

    }

    // Update is called once per frame
    void Update()
    {
        refCastSpellNew = CastSpellNew.instance;
        lifeTMP.text = PlayerController.instance.life + " / " + PlayerController.lifeMax;

        if (player == null)
        {
            player = GameObject.Find("Player");
        }


        if (player != null)
        {





            mat_Stamina.SetFloat("_Endurance", (float)(1.5f - PlayerController.instance.dashCoolDown) / 1.5f);

            /*RightSpellImg.GetComponent<Image>().sprite = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellR].spell_image;
            RightSpellText.GetComponent<Text>().text = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellR].spell_name;

            LeftSpellImg.GetComponent<Image>().sprite = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellL].spell_image;
            LeftSpellText.GetComponent<Text>().text = player.GetComponent<CastSpell>().Elements[player.GetComponent<CastSpell>().SpellL].spell_name;*/

            //RightSpellImg.GetComponent<Image>().sprite = player.GetComponent<CastSpellNew>().structSpells[player.GetComponent<CastSpellNew>().SpellR].spell_image;
            //RightSpellText.GetComponent<Text>().text = player.GetComponent<CastSpellNew>().structSpells[player.GetComponent<CastSpellNew>().SpellR].spell_name;

            //LeftSpellImg.GetComponent<Image>().sprite = player.GetComponent<CastSpellNew>().structSpells[player.GetComponent<CastSpellNew>().SpellL].spell_image;
            //LeftSpellText.GetComponent<Text>().text = player.GetComponent<CastSpellNew>().structSpells[player.GetComponent<CastSpellNew>().SpellL].spell_name;

            SpellMaterial(LeftSpellImg, refCastSpellNew.SpellL);
            SpellMaterial(RightSpellImg, refCastSpellNew.SpellR);

            Crosshair.SetActive(player.GetComponent<CastSpellNew>().limit>-1);


            /*if (!player.GetComponent<CastSpell>().CheckValidation())
            {
                RightSpellImg.GetComponent<Image>().color = new Color(.2f, .2f, .2f, 1f);
                LeftSpellImg.GetComponent<Image>().color = new Color(.2f, .2f, .2f, 1f);

            }
            else
            {
                RightSpellImg.GetComponent<Image>().color = new Color(255, 255, 255, 1f);
                LeftSpellImg.GetComponent<Image>().color = new Color(255, 255, 255, 1f);

            }*/

            if(player.GetComponent<CastSpellNew>().limit > 0)
            {
                RightSpellImg.SetActive(true);
            }
            if(player.GetComponent<CastSpellNew>().limit > -1)
            {
                LeftSpellImg.SetActive(true);
                mat_UIPlane.SetInt("_EnableSpell", 1);
            }
            
            
            /*RightSpellImg.SetActive(player.GetComponent<CastSpellNew>().limit > 0);
            LeftSpellImg.SetActive(player.GetComponent<CastSpellNew>().limit >-1);
            RightSpellText.SetActive(false);
            LeftSpellText.SetActive(false);*/



            HealthBar.GetComponent<RectTransform>().sizeDelta = new Vector2(PlayerController.instance.life * healthbarsize / (PlayerController.lifeMax), HealthBar.GetComponent<RectTransform>().sizeDelta.y);
            StaminaFront.GetComponent<RectTransform>().sizeDelta = new Vector2((1.5f - PlayerController.instance.dashCoolDown) / 1.5f * StaminaBack.GetComponent<RectTransform>().sizeDelta.x, StaminaBack.GetComponent<RectTransform>().sizeDelta.y);

            UI.SetActive(player.transform.Find("Main Camera").gameObject.activeSelf);
            //AnimateSubSpells();
            //mat_UIPlane.SetInt("_EnableSpell", player.GetComponent<CastSpellNew>().limit > -1 ? 1 : 0);
        }

        

        bool previousIsPause = isPaused;
        isPaused = refGameController.isPaused;


        if (isPaused)
        {
            if(!previousIsPause)
            {
            EnablePauseUI();

            }
            //EnablePauseUI();
        }
        else
        {
            if(previousIsPause)
            {
                DisablePauseUI();
            }
        }

        
    }


    void EnablePauseUI()
    {
        //refSensitivity.SetActive(true);
        //refEsc_BlackScreen.SetActive(true);
        PlayerController.instance.refPlayerInput.SwitchCurrentActionMap("MenuInput");
        refPauseScreen.SetActive(true);
        lifeTMP.enabled = false;

    }
    public void DisablePauseUI()
    {
        //refSensitivity.SetActive(false);
        //refEsc_BlackScreen.SetActive(false);
        PlayerController.instance.refPlayerInput.SwitchCurrentActionMap("PlayerInput");
        refPauseScreen.SetActive(false);
        lifeTMP.enabled = true;
    }


    /*void AnimateSubSpells()
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

            SetSpellImgs(0, 1, player.GetComponent<CastSpellNew>().SpellR);

            
        }

        if (player.GetComponent<CastSpell>().getSelecting() == 1)
        {
            SubSpell[2].GetComponent<Image>().enabled = (true);
            SubSpell[3].GetComponent<Image>().enabled = (true);

            SetSpellImgs(2, 3, player.GetComponent<CastSpellNew>().SpellL);
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


    void SetSpellImgs(int a, int b, int _spellNotChanging)
    {

        string spellNotChanging = _spellNotChanging.ToString();

        if (player.GetComponent<CastSpell>().getCombination() == "01")
        {
            SubSpell[a].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("2",spellNotChanging)? spellImg[2]:null;
            SubSpell[b].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("3", spellNotChanging) ? spellImg[3] : null;

        }
        if (player.GetComponent<CastSpell>().getCombination() == "02")
        {
            SubSpell[a].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("1", spellNotChanging) ? spellImg[1] : null;
            SubSpell[b].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("3", spellNotChanging) ? spellImg[3] : null;
        }
        if (player.GetComponent<CastSpell>().getCombination() == "03")
        {
            SubSpell[a].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("1", spellNotChanging) ? spellImg[1] : null;
            SubSpell[b].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("2", spellNotChanging) ? spellImg[2] : null;
        }
        if (player.GetComponent<CastSpell>().getCombination() == "12")
        {
            SubSpell[a].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("0", spellNotChanging) ? spellImg[0] : null;
            SubSpell[b].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("3", spellNotChanging) ? spellImg[3] : null;
        }
        if (player.GetComponent<CastSpell>().getCombination() == "23")
        {
            SubSpell[a].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("0", spellNotChanging) ? spellImg[0] : null;
            SubSpell[b].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("1", spellNotChanging) ? spellImg[1] : null;
        }
        if (player.GetComponent<CastSpell>().getCombination() == "13")
        {
            SubSpell[a].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("0", spellNotChanging) ? spellImg[0] : null;
            SubSpell[b].GetComponent<Image>().sprite = player.GetComponent<CastSpell>().CheckValidationRef("2", spellNotChanging) ? spellImg[2] : null;
        }


        for (int i = 0; i < 4; i++)
        {
            if (SubSpell[i].GetComponent<Image>().sprite == null)
            {
                SubSpell[i].GetComponent<Image>().color = new Color(1, 1, 1, 0);
            }
            else
            {
                SubSpell[i].GetComponent<Image>().color = new Color(1, 1, 1, 1);
            }
        }
    }

    public void SetSubSpellHighLight(float angle, int hand)
    {

        if (hand < 0)
        {
            if (angle >= 0 && angle < 45)
            {
                mat_UIPlane.SetInt("_SubSpell1Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell2Intensity", 1);
                mat_UIPlane.SetInt("_SubSpell3Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell4Intensity", 0);

            }
            if (angle >= 45 && angle <= 90)
            {
                mat_UIPlane.SetInt("_SubSpell1Intensity", 1);
                mat_UIPlane.SetInt("_SubSpell2Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell3Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell4Intensity", 0);
            }
        }

        if (hand > 0)
        {
            if (angle >= 90 && angle <= 135)
            {
                mat_UIPlane.SetInt("_SubSpell1Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell2Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell3Intensity", 1);
                mat_UIPlane.SetInt("_SubSpell4Intensity", 0);
            }
            if (angle > 135 && angle <= 180)
            {
                mat_UIPlane.SetInt("_SubSpell1Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell2Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell3Intensity", 0);
                mat_UIPlane.SetInt("_SubSpell4Intensity", 1);
            }
        }

        if (angle < 0)
        {
            mat_UIPlane.SetInt("_SubSpell1Intensity", 0);
            mat_UIPlane.SetInt("_SubSpell2Intensity", 0);
            mat_UIPlane.SetInt("_SubSpell3Intensity", 0);
            mat_UIPlane.SetInt("_SubSpell4Intensity", 0);
        }
    }*/

    public void EnableSelectionUi()
    {
        refSelectionUi.SetActive(true);
    }
    public void DisableSelectionUi()
    {
        refSelectionUi.SetActive(false);
    }

    public void UpdateUiSelection()
    {
        if(refCastSpellNew.hand == -1)
        {
            SpellMaterial(currentSpellUi, refCastSpellNew.SpellL);
            SpellMaterial(spellLeftUi, refCastSpellNew.listLeftSpellAvailable[0]);
            SpellMaterial(spellRightUi, refCastSpellNew.listLeftSpellAvailable[1]);
            //SpellMaterial(spellBotUi, refCastSpellNew.listLeftSpellAvailable[2]);
            //SpellMaterial(spellLeftUi, refCastSpellNew.listLeftSpellAvailable[3]);
        }
        if(refCastSpellNew.hand == 1)
        {
            SpellMaterial(currentSpellUi, refCastSpellNew.SpellR);
            SpellMaterial(spellLeftUi, refCastSpellNew.listRightSpellAvailable[0]);
            SpellMaterial(spellRightUi, refCastSpellNew.listRightSpellAvailable[1]);
            //SpellMaterial(spellBotUi, refCastSpellNew.listRightSpellAvailable[2]);
            //SpellMaterial(spellLeftUi, refCastSpellNew.listRightSpellAvailable[3]);
        }

        //VISIBLE WHEN UNLOCKED ONLY
        if(refCastSpellNew.limit <=0 && refCastSpellNew.hand == 1)
        {
            currentSpellUi.SetActive(false);
        }
        else currentSpellUi.SetActive(true);

        if(refCastSpellNew.limit>=2 && spellLeftUi !=null)
        {
            spellLeftUi.SetActive(true);
        }
        if(refCastSpellNew.limit>=3 && spellRightUi !=null)
        {
            spellRightUi.SetActive(true);
        }
        /*if(refCastSpellNew.limit>=4 && spellBotUi !=null)
        {
            spellBotUi.SetActive(true);
        }
        if(refCastSpellNew.limit>=5 && spellLeftUi !=null)
        {
            spellLeftUi.SetActive(true);
        }*/

        HighlightSelected();
        
    }

    void SpellMaterial(GameObject f , int i)
    {
        //Debug.Log(i);
        if (i==0)
        {
            f.GetComponent<MeshRenderer>().material = matFireball;
        }
        if (i==1)
        {
            f.GetComponent<MeshRenderer>().material = matFireClone;
        }
        if (i==2)
        {
            f.GetComponent<MeshRenderer>().material = matTelekinesesClone;
        }
        if (i==3)
        {
            f.GetComponent<MeshRenderer>().material = matIceClone;
        }
        /*if (i==4)
        {
            f.GetComponent<MeshRenderer>().material = matIceball;
        }
        if (i==5)
        {
            f.GetComponent<MeshRenderer>().material = matIceClone;
        }*/

    }

    void HighlightSelected()
    {
        Debug.Log("highlight is called" + refCastSpellNew.leftSelected + " / " + refCastSpellNew.rightSelected);
        currentSpellUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,1);

        if (refCastSpellNew.leftSelected)
        {
            spellLeftUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,1);
        }
        else 
        {
            spellLeftUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,.5f);
        }
        
        if (refCastSpellNew.rightSelected)
        {
            spellRightUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,1);
        }
        else 
        {
            spellRightUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,.5f);
        }

        /*if (refCastSpellNew.botSelected)
        {
            spellBotUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,1);
        }
        else 
        {
            spellBotUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,.5f);
        }

        if (refCastSpellNew.leftSelected)
        {
            spellLeftUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,1);
        }
        else 
        {
            spellLeftUi.GetComponent<MeshRenderer>().material.color = new Vector4 (1,1,1,.5f);
        }*/
    }

    public void EnableShopUi()
    {
        cameraShop.SetActive(true);
    }
    public void DisableShopUi()
    {
        cameraShop.SetActive(false);
    }

}
