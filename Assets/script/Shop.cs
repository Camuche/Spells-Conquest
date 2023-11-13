using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shop : MonoBehaviour
{
    public static Shop instance;

    //SPELLS AVAILABLE
    bool fireballAltAvailable = true, fireCloneAltAvailable = true, telekinesisCloneAltAvailable = true, waveAltAvailable = true, iceballAltAvailable = true, iceCloneAltAvailable = true;
    [SerializeField] int priceFireball, priceFireClone, priceTelekinesisClone, priceWave, priceIceball, priceIceClone;

    //STATS AVAILABLE
    [SerializeField] int hpAvailable, dpAvailable;
    [SerializeField] int priceHp, priceDp; 
    //CONSOMMABLE
    int hpPotionAvailable=0, hpBonusPotionAvailable=0;
    
    
    

    GameObject player;
    CastSpellNew refCastSpellNew;

    Inventory inventory;

    MeshRenderer matButtonFireball, matButtonFireClone, matButtonTelekinesisCloneone, matButtonWave, matButtonIceball, matButtonIceClone;
    [SerializeField] Material greyLockedUi, greyUi, whiteUi;

    float timerDelay;
    [SerializeField] float hitDelay;

    void Awake()
    {
        instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");

        inventory = player.GetComponent<Inventory>();
        refCastSpellNew = player.GetComponent<CastSpellNew>();

        // GET BUTTON GAME OBJECT
        //matButtonFireball = GameObject.Find("UpgradeFireball");
        /*matButtonFireClone = GameObject.Find("UpgradeFireClone").GetComponent<MeshRenderer>().material;
        matButtonTelekinesisCloneone = GameObject.Find("UpgradeTelekinesisClone").GetComponent<MeshRenderer>().material;
        matButtonWave = GameObject.Find("UpgradeWave").GetComponent<MeshRenderer>().material;
        matButtonIceball = GameObject.Find("UpgradeIceball").GetComponent<MeshRenderer>().material;
        matButtonIceClone = GameObject.Find("UpgradeIceClone").GetComponent<MeshRenderer>().material;*/
    }

    // Update is called once per frame
    void Update()
    {
        /*if(refCastSpellNew.limit < 0)
        {
            //matButtonFireball.material = greyLockedUi;
            //Debug.Log(matButtonFireball.GetComponent<Renderer>().material);
        }*/
        /*else if(refCastSpellNew.limit >= 0)
        {

        }
        if(refCastSpellNew.limit < 1)
        {
            Debug.Log("notavailable");
        }
        if(refCastSpellNew.limit < 2)
        {
            Debug.Log("notavailable");
        }
        if(refCastSpellNew.limit < 3)
        {
            Debug.Log("notavailable");
        }
        if(refCastSpellNew.limit < 4)
        {
            Debug.Log("notavailable");
        }
        if(refCastSpellNew.limit < 5)
        {
            Debug.Log("notavailable");
        }*/

        if(timerDelay <= hitDelay)
        {
            timerDelay += Time.deltaTime;
        }
    }


    public void UpgradeFireball()
    {
        if(inventory.money >= priceFireball && fireballAltAvailable == true && refCastSpellNew.limit >= 0)
        {
            fireballAltAvailable = false;
            inventory.fireballAlt = true;
            inventory.money -= priceFireball;
            inventory.UpdateMoneyTMP();
            Debug.Log("UpdateFireball");
        }
        else if (inventory.money >= priceFireball && fireballAltAvailable == true && refCastSpellNew.limit < 0)
        {
            Debug.Log("notUnlocked");
        }
        else if (fireballAltAvailable == false)
        {
            Debug.Log("AlreadyUnlocked");
        }
        else
        {
            Debug.Log("notEnoughMoney");
        }
    }

    public void UpgradeFireClone()
    {
        if(inventory.money >= priceFireClone && fireCloneAltAvailable == true && refCastSpellNew.limit >= 1)
        {
            fireCloneAltAvailable = false;
            inventory.fireCloneAlt = true;
            inventory.money -= priceFireClone;
            inventory.UpdateMoneyTMP();
            Debug.Log("UpdateFireClone");
        }
    }

    public void UpgradeTelekinesisClone()
    {
        if(inventory.money >= priceTelekinesisClone && telekinesisCloneAltAvailable == true && refCastSpellNew.limit >= 2)
        {
            telekinesisCloneAltAvailable = false;
            inventory.telekinesisCloneAlt = true;
            inventory.money -= priceFireClone;
            inventory.UpdateMoneyTMP();
            Debug.Log("UpdateTelekinesisClone");
        }
    }

    public void UpgradeWave()
    {
        if(inventory.money >= priceWave && waveAltAvailable == true && refCastSpellNew.limit >= 3)
        {
            waveAltAvailable = false;
            inventory.waveAlt = true;
            inventory.money -= priceWave;
            inventory.UpdateMoneyTMP();
            Debug.Log("UpdateWave");
        }
    }

    public void UpgradeIceball()
    {
        if(inventory.money >= priceIceball && iceballAltAvailable == true && refCastSpellNew.limit >= 4)
        {
            iceballAltAvailable = false;
            inventory.iceballAlt = true;
            inventory.money -= priceIceball;
            inventory.UpdateMoneyTMP();
            Debug.Log("UpdateIceball");
        }
    }

    public void UpgradeIceClone()
    {
        if(inventory.money >= priceIceClone && iceCloneAltAvailable == true && refCastSpellNew.limit >= 5)
        {
            iceCloneAltAvailable = false;
            inventory.iceCloneAlt = true;
            inventory.money -= priceIceClone;
            inventory.UpdateMoneyTMP();
            Debug.Log("UpdateIceClone");
        }
    }


    public void UpgradeHp()
    {
        if(hpAvailable > 0 && inventory.money >= priceHp && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            hpAvailable --;
            player.GetComponent<PlayerController>().lifeMax += 20;
            player.GetComponent<PlayerController>().life += 20;
            inventory.money -= priceHp;
            inventory.UpdateMoneyTMP();
            Debug.Log("Stat HP left :" + hpAvailable);
            
        }
        
    }





    public void GetShopButton()
    {
        matButtonFireball = GameObject.Find("UpgradeFireball").GetComponent<MeshRenderer>();
    }

    /*public void UpdateButtonOnSelect()
    {
        if (refCastSpellNew.limit <= -1 || fireballAltAvailable == false)
        {
            matButtonFireball.material = greyLockedUi;
        }
        else 
        {
            matButtonFireball.material = greyUi;
        }
        /*else if(refCastSpellNew.limit <= 0)
        {
            //matButtonFireball = 
        }*//*
    }

    public void UpdateButtonOnDeselect()
    {
        if (refCastSpellNew.limit <= -1 || fireballAltAvailable == false)
        {
            matButtonFireball.material = greyLockedUi;
        }
        else 
        {
            matButtonFireball.material = whiteUi;
        }
    }*/
    
}
