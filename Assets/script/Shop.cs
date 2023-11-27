using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Shop : MonoBehaviour
{
    public static Shop instance;

    public float hpUpgradeValue, damageUpgradeMultiplierValue;
    [HideInInspector] public float damageMultiplierValue;
    int hpUpgradeNumber = 0;

    //SPELLS AVAILABLE
    bool fireballAltAvailable = true, fireCloneAltAvailable = true, telekinesisCloneAltAvailable = true, waveAltAvailable = true, iceballAltAvailable = true, iceCloneAltAvailable = true;
    [SerializeField] int priceFireball, priceFireClone, priceTelekinesisClone, priceWave, priceIceball, priceIceClone;

    //STATS AVAILABLE
    [SerializeField] int hpAvailable, damageAvailable;
    [SerializeField] int priceHp, priceDamage; 
    


    GameObject player;
    CastSpellNew refCastSpellNew;

    Inventory inventory;

    MeshRenderer matButtonFireball, matButtonFireClone, matButtonTelekinesisClone, matButtonWave, matButtonIceball, matButtonIceClone, matButtonHp, matButtonDamage;
    [SerializeField] Material greyLockedUi, greyUi, whiteUi, selectedGreyLockedUi;

    float timerDelay;
    [SerializeField] float hitDelay;

    //TextMeshPro
    [SerializeField] TMP_Text descriptionTMP, notEnoughMoneyTMP, priceFireballTMP, priceFireCloneTMP, priceTelekinesisCloneTMP, priceWaveTMP, priceIceballTMP, priceIceCloneTMP, priceHpTMP, priceDamageTMP, itemLeftHpTMP, itemLeftDamageTMP;
    [HideInInspector] public TMP_Text moneyShopTMP;
    [SerializeField] string descriptionFireball, descriptionFireClone, descriptionTelekinesisClone, descriptionWave, descriptionIceball, descriptionIceClone, descriptionSpellLocked, descriptionHp, descriptionDamage, soldOut;
    [SerializeField] TMP_Text bonusHpTMP, bonusDamageTMP;

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

        damageMultiplierValue = 1f;

        //TMP
        notEnoughMoneyTMP.enabled = false;
        itemLeftHpTMP.text = "Left : " + hpAvailable;
        itemLeftDamageTMP.text = "Left : " + damageAvailable;
        bonusHpTMP.text = "Points de vie x" + 100 + "%";
        bonusDamageTMP.text = "Dégâts x" + 100 + "%";

        //SET ITEM PRICE
        priceFireballTMP.text = priceFireball + "$";
        priceFireCloneTMP.text = priceFireClone + "$";
        priceTelekinesisCloneTMP.text = priceTelekinesisClone + "$";
        priceWaveTMP.text = priceWave + "$";
        priceIceballTMP.text = priceIceball + "$";
        priceIceCloneTMP.text = priceIceClone + "$";
        priceHpTMP.text = priceHp + "$";
        priceDamageTMP.text = priceDamage + "$";

        hitDelay *= 0.05f;

        
    }

    public void GetShopButton()
    {
        matButtonFireball = GameObject.Find("UpgradeFireball").GetComponent<MeshRenderer>();
        matButtonFireClone = GameObject.Find("UpgradeFireClone").GetComponent<MeshRenderer>();
        matButtonTelekinesisClone = GameObject.Find("UpgradeTelekinesisClone").GetComponent<MeshRenderer>();
        //matButtonWave = GameObject.Find("UpgradeWave").GetComponent<MeshRenderer>();
        //matButtonIceball = GameObject.Find("UpgradeIceball").GetComponent<MeshRenderer>();
        matButtonIceClone = GameObject.Find("UpgradeIceClone").GetComponent<MeshRenderer>();
        
        matButtonHp = GameObject.Find("UpgradeHp").GetComponent<MeshRenderer>();
        matButtonDamage = GameObject.Find("UpgradeDamage").GetComponent<MeshRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        if(timerDelay <= hitDelay)
        {
            timerDelay += Time.deltaTime;
        }
        //Debug.Log(Fireball.instance.fireballDamage * Shop.instance.damageMultiplierValue);
    }


    public void UpgradeFireball()
    {
        if(inventory.money >= priceFireball && fireballAltAvailable == true && refCastSpellNew.limit >= 0)
        {
            fireballAltAvailable = false;
            inventory.fireballAlt = true;
            inventory.money -= priceFireball;
            inventory.UpdateMoneyTMP();
            FireballButtonSelected();
            Debug.Log("UpdateFireball");
        }
        else if(inventory.money < priceFireball && fireballAltAvailable == true && refCastSpellNew.limit >= 0)
        {
            notEnoughMoneyTMP.enabled = true;
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
            FireCloneButtonSelected();
            Debug.Log("UpdateFireClone");
        }
        else if(inventory.money < priceFireClone && fireCloneAltAvailable == true && refCastSpellNew.limit >= 1)
        {
            notEnoughMoneyTMP.enabled = true;
        }
    }

    public void UpgradeTelekinesisClone()
    {
        if(inventory.money >= priceTelekinesisClone && telekinesisCloneAltAvailable == true && refCastSpellNew.limit >= 2)
        {
            telekinesisCloneAltAvailable = false;
            inventory.telekinesisCloneAlt = true;
            inventory.money -= priceTelekinesisClone;
            inventory.UpdateMoneyTMP();
            TelekinesisCloneButtonSelected();
            Debug.Log("UpdateTelekinesisClone");
        }
        else if(inventory.money < priceTelekinesisClone && telekinesisCloneAltAvailable == true && refCastSpellNew.limit >= 2)
        {
            notEnoughMoneyTMP.enabled = true;
        }
    }

    /*public void UpgradeWave()
    {
        if(inventory.money >= priceWave && waveAltAvailable == true && refCastSpellNew.limit >= 3)
        {
            waveAltAvailable = false;
            inventory.waveAlt = true;
            inventory.money -= priceWave;
            inventory.UpdateMoneyTMP();
            WaveButtonSelected();
            Debug.Log("UpdateWave");
        }
        else if(inventory.money < priceWave && waveAltAvailable == true && refCastSpellNew.limit >= 3)
        {
            notEnoughMoneyTMP.enabled = true;
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
            IceballButtonSelected();
            Debug.Log("UpdateIceball");
        }
        else if(inventory.money < priceIceball && iceballAltAvailable == true && refCastSpellNew.limit >= 4)
        {
            notEnoughMoneyTMP.enabled = true;
        }
    }*/

    public void UpgradeIceClone()
    {
        if(inventory.money >= priceIceClone && iceCloneAltAvailable == true && refCastSpellNew.limit >= 3)
        {
            iceCloneAltAvailable = false;
            inventory.iceCloneAlt = true;
            inventory.money -= priceIceClone;
            inventory.UpdateMoneyTMP();
            IceCloneButtonSelected();
            Debug.Log("UpdateIceClone");
        }
        else if(inventory.money < priceIceClone && iceCloneAltAvailable == true && refCastSpellNew.limit >= 3)
        {
            notEnoughMoneyTMP.enabled = true;
        }
    }


    public void UpgradeHp()
    {
        if(hpAvailable > 0 && inventory.money >= priceHp && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            hpAvailable --;

            player.GetComponent<PlayerController>().lifeMax += hpUpgradeValue;
            player.GetComponent<PlayerController>().life += hpUpgradeValue;
            hpUpgradeNumber ++;
            bonusHpTMP.text = "Points de vie x" + (100 + hpUpgradeValue * hpUpgradeNumber) + "%";

            inventory.money -= priceHp;
            inventory.UpdateMoneyTMP();
            HpButtonSelected();
            itemLeftHpTMP.text = "Left : " + hpAvailable;
            //Debug.Log("Stat HP left :" + hpAvailable);
            
        }
        else if(inventory.money < priceHp && hpAvailable > 0 && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            notEnoughMoneyTMP.enabled = true;
        }
    }

    //public Fireball refFireball;

    public void UpgradeDamage()
    {
        if(damageAvailable > 0 && inventory.money >= priceDamage && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            damageAvailable --;

            damageMultiplierValue += damageUpgradeMultiplierValue;
            bonusDamageTMP.text = "Dégâts x" + damageMultiplierValue*100 + "%";
            
            inventory.money -= priceDamage;
            inventory.UpdateMoneyTMP();
            DamageButtonSelected();
            itemLeftDamageTMP.text = "Left : " + damageAvailable;
        }
        else if (damageAvailable > 0 && inventory.money < priceDamage && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            notEnoughMoneyTMP.enabled = true;
        }
    }







    //REAL TIME CHECK IF BUTTON CAN BE PURCHASED OR NOT
    public void UpdateUnselectedShopButton()
    {
        notEnoughMoneyTMP.enabled = false;


        if(CastSpellNew.instance.limit >= 0 && fireballAltAvailable)
        {
            matButtonFireball.material = whiteUi;
        }
        else
        {
            matButtonFireball.material = greyLockedUi;
        }


        if(CastSpellNew.instance.limit >= 1 && fireCloneAltAvailable)
        {
            matButtonFireClone.material = whiteUi;
        }
        else
        {
            matButtonFireClone.material = greyLockedUi;
        }


        if(CastSpellNew.instance.limit >= 2 && telekinesisCloneAltAvailable)
        {
            matButtonTelekinesisClone.material = whiteUi;
        }
        else
        {
            matButtonTelekinesisClone.material = greyLockedUi;
        }


        /*if(CastSpellNew.instance.limit >= 3 && waveAltAvailable)
        {
            matButtonWave.material = whiteUi;
        }
        else
        {
            matButtonWave.material = greyLockedUi;
        }


        if(CastSpellNew.instance.limit >= 4 && iceballAltAvailable)
        {
            matButtonIceball.material = whiteUi;
        }
        else
        {
            matButtonIceball.material = greyLockedUi;
        }*/


        if(CastSpellNew.instance.limit >= 3 && iceCloneAltAvailable)
        {
            matButtonIceClone.material = whiteUi;
        }
        else
        {
            matButtonIceClone.material = greyLockedUi;
        }

        if(hpAvailable > 0)
        {
            matButtonHp.material = whiteUi;
        }
        else 
        {
            matButtonHp.material = greyLockedUi;
        }

        if(damageAvailable > 0)
        {
            matButtonDamage.material = whiteUi;
        }
        else
        {
            matButtonDamage.material = greyLockedUi;
        }
    }






    //INDIVIDUAL SELECTED BUTTON
    public void FireballButtonSelected()
    {
        if(CastSpellNew.instance.limit >= 0 && fireballAltAvailable)
        {
            matButtonFireball.material = greyUi;
            descriptionTMP.text = descriptionFireball;
        }
        else if (!fireballAltAvailable)
        {
            matButtonFireball.material = selectedGreyLockedUi;
            descriptionTMP.text = soldOut;
        }
        else
        {
            matButtonFireball.material = selectedGreyLockedUi;
            descriptionTMP.text = descriptionSpellLocked;
        }
    }

    public void FireCloneButtonSelected()
    {
        if(CastSpellNew.instance.limit >= 1 && fireCloneAltAvailable)
        {
            matButtonFireClone.material = greyUi;
            descriptionTMP.text = descriptionFireClone;
        }
        else if (!fireCloneAltAvailable)
        {
            matButtonFireClone.material = selectedGreyLockedUi;
            descriptionTMP.text = soldOut;
        }
        else
        {
            matButtonFireClone.material = selectedGreyLockedUi;
            descriptionTMP.text = descriptionSpellLocked;
        }
    }

    public void TelekinesisCloneButtonSelected()
    {
        if(CastSpellNew.instance.limit >= 2 && telekinesisCloneAltAvailable)
        {
            matButtonTelekinesisClone.material = greyUi;
            descriptionTMP.text = descriptionTelekinesisClone;
        }
        else if (!telekinesisCloneAltAvailable)
        {
            matButtonTelekinesisClone.material = selectedGreyLockedUi;
            descriptionTMP.text = soldOut;
        }
        else
        {
            matButtonTelekinesisClone.material = selectedGreyLockedUi;
            descriptionTMP.text = descriptionSpellLocked;
        }
    }

    /*public void WaveButtonSelected()
    {
        if(CastSpellNew.instance.limit >= 3 && waveAltAvailable)
        {
            matButtonWave.material = greyUi;
            descriptionTMP.text = descriptionWave;
        }
        else
        {
            matButtonWave.material = selectedGreyLockedUi;
            descriptionTMP.text = descriptionSpellLocked;
        }
    }

    public void IceballButtonSelected()
    {
        if(CastSpellNew.instance.limit >= 4 && iceballAltAvailable)
        {
            matButtonIceball.material = greyUi;
            descriptionTMP.text = descriptionIceball;
        }
        else
        {
            matButtonIceball.material = selectedGreyLockedUi;
            descriptionTMP.text = descriptionSpellLocked;
        }
    }*/

    public void IceCloneButtonSelected()
    {
        if(CastSpellNew.instance.limit >= 3 && iceCloneAltAvailable)
        {
            matButtonIceClone.material = greyUi;
            descriptionTMP.text = descriptionIceClone;
        }
        else if (!telekinesisCloneAltAvailable)
        {
            matButtonIceClone.material = selectedGreyLockedUi;
            descriptionTMP.text = soldOut;
        }
        else
        {
            matButtonIceClone.material = selectedGreyLockedUi;
            descriptionTMP.text = descriptionSpellLocked;
        }
    }

    public void HpButtonSelected()
    {
        if(hpAvailable > 0)
        {
            matButtonHp.material = greyUi;
            descriptionTMP.text = descriptionHp;
        }
        else 
        {
            matButtonHp.material = selectedGreyLockedUi;
            descriptionTMP.text = soldOut;
        }
    }

    public void DamageButtonSelected()
    {
        if(damageAvailable > 0)
        {
            matButtonDamage.material = greyUi;
            descriptionTMP.text = descriptionDamage;
        }
        else
        {
            matButtonDamage.material = selectedGreyLockedUi;
            descriptionTMP.text = soldOut;
        }
    }

    
    
}
