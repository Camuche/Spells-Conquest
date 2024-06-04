using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.Events;

public class Shop : MonoBehaviour
{
    public static Shop instance;

    public float hpUpgradeValue, damageUpgradeMultiplierValue;
    [HideInInspector] public float damageMultiplierValue;
    int hpUpgradeNumber = 0;

    //SPELLS AVAILABLE
    [HideInInspector] public bool fireballAltAvailable = true, fireCloneAltAvailable = true, telekinesisCloneAltAvailable = true, waveAltAvailable = true, iceballAltAvailable = true, iceCloneAltAvailable = true;
    [SerializeField] int priceFireball, priceFireClone, priceTelekinesisClone, priceWave, priceIceball, priceIceClone;

    //STATS AVAILABLE
    [SerializeField] int hpAvailable, damageAvailable;
    [SerializeField] int priceHp, priceDamage;

    public AudioSource audioSource;
    public AudioClip notAvailiableAudioClip;
    public AudioEvent buySoundEvent;
    


    GameObject player;
    //CastSpellNew CastSpellNew;

    //Inventory.instance Inventory.instance;

    public MeshRenderer matButtonFireball, matButtonFireClone, matButtonTelekinesisClone, matButtonWave, matButtonIceball, matButtonIceClone, matButtonHp, matButtonDamage;
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
        if(instance == null)
        {
            instance = this;
        }
        
    }

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");

        //Inventory.instance = Inventory.instance.instance;
        //CastSpellNew.instance = CastSpellNew.instance;

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
        //Debug.Log(""+GameObject.Find("UpgradeFireball")+ " " + GameObject.Find("UpgradeFireball").GetComponent<MeshRenderer>());
        /*matButtonFireball = GameObject.Find("UpgradeFireball").GetComponent<MeshRenderer>();
        matButtonFireClone = GameObject.Find("UpgradeFireClone").GetComponent<MeshRenderer>();
        matButtonTelekinesisClone = GameObject.Find("UpgradeTelekinesisClone").GetComponent<MeshRenderer>();*/
        
        //matButtonWave = GameObject.Find("UpgradeWave").GetComponent<MeshRenderer>();
        //matButtonIceball = GameObject.Find("UpgradeIceball").GetComponent<MeshRenderer>();
        
        /*matButtonIceClone = GameObject.Find("UpgradeIceClone").GetComponent<MeshRenderer>();
        
        matButtonHp = GameObject.Find("UpgradeHp").GetComponent<MeshRenderer>();
        matButtonDamage = GameObject.Find("UpgradeDamage").GetComponent<MeshRenderer>();*/
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log(matButtonFireball);

        if(timerDelay <= hitDelay)
        {
            timerDelay += Time.deltaTime;
        }
        //Debug.Log(matButtonFireball);
        //Debug.Log(Fireball.instance.fireballDamage * Shop.instance.damageMultiplierValue);
    }


    public void UpgradeFireball()
    {
        if(Inventory.instance.money >= priceFireball && fireballAltAvailable == true && CastSpellNew.instance.limit >= 0)
        {
            fireballAltAvailable = false;
            Inventory.instance.fireballAlt = true;
            Inventory.instance.money -= priceFireball;
            Inventory.instance.UpdateMoneyTMP();
            FireballButtonSelected();
            buySoundEvent.Play(audioSource);
        }
        else if(Inventory.instance.money < priceFireball && fireballAltAvailable == true && CastSpellNew.instance.limit >= 0)
        {
            notEnoughMoneyTMP.enabled = true;
            audioSource.PlayOneShot(notAvailiableAudioClip);
        }
    }

    public void UpgradeFireClone()
    {
        if(Inventory.instance.money >= priceFireClone && fireCloneAltAvailable == true && CastSpellNew.instance.limit >= 1)
        {
            fireCloneAltAvailable = false;
            Inventory.instance.fireCloneAlt = true;
            Inventory.instance.money -= priceFireClone;
            Inventory.instance.UpdateMoneyTMP();
            FireCloneButtonSelected();
            buySoundEvent.Play(audioSource);
        }
        else if(Inventory.instance.money < priceFireClone && fireCloneAltAvailable == true && CastSpellNew.instance.limit >= 1)
        {
            notEnoughMoneyTMP.enabled = true;
            audioSource.PlayOneShot(notAvailiableAudioClip);
        }
    }

    public void UpgradeTelekinesisClone()
    {
        if(Inventory.instance.money >= priceTelekinesisClone && telekinesisCloneAltAvailable == true && CastSpellNew.instance.limit >= 2)
        {
            telekinesisCloneAltAvailable = false;
            Inventory.instance.telekinesisCloneAlt = true;
            Inventory.instance.money -= priceTelekinesisClone;
            Inventory.instance.UpdateMoneyTMP();
            TelekinesisCloneButtonSelected();
            buySoundEvent.Play(audioSource);
        }
        else if(Inventory.instance.money < priceTelekinesisClone && telekinesisCloneAltAvailable == true && CastSpellNew.instance.limit >= 2)
        {
            notEnoughMoneyTMP.enabled = true;
            audioSource.PlayOneShot(notAvailiableAudioClip);
        }
    }

    /*public void UpgradeWave()
    {
        if(Inventory.instance.money >= priceWave && waveAltAvailable == true && CastSpellNew.instance.limit >= 3)
        {
            waveAltAvailable = false;
            Inventory.instance.waveAlt = true;
            Inventory.instance.money -= priceWave;
            Inventory.instance.UpdateMoneyTMP();
            WaveButtonSelected();
            Debug.Log("UpdateWave");
        }
        else if(Inventory.instance.money < priceWave && waveAltAvailable == true && CastSpellNew.instance.limit >= 3)
        {
            notEnoughMoneyTMP.enabled = true;
        }
    }

    public void UpgradeIceball()
    {
        if(Inventory.instance.money >= priceIceball && iceballAltAvailable == true && CastSpellNew.instance.limit >= 4)
        {
            iceballAltAvailable = false;
            Inventory.instance.iceballAlt = true;
            Inventory.instance.money -= priceIceball;
            Inventory.instance.UpdateMoneyTMP();
            IceballButtonSelected();
            Debug.Log("UpdateIceball");
        }
        else if(Inventory.instance.money < priceIceball && iceballAltAvailable == true && CastSpellNew.instance.limit >= 4)
        {
            notEnoughMoneyTMP.enabled = true;
        }
    }*/

    public void UpgradeIceClone()
    {
        if(Inventory.instance.money >= priceIceClone && iceCloneAltAvailable == true && CastSpellNew.instance.limit >= 3)
        {
            iceCloneAltAvailable = false;
            Inventory.instance.iceCloneAlt = true;
            Inventory.instance.money -= priceIceClone;
            Inventory.instance.UpdateMoneyTMP();
            IceCloneButtonSelected();
            Debug.Log("UpdateIceClone");
        }
        else if(Inventory.instance.money < priceIceClone && iceCloneAltAvailable == true && CastSpellNew.instance.limit >= 3)
        {
            notEnoughMoneyTMP.enabled = true;
        }
    }


    public void UpgradeHp()
    {
        if(hpAvailable > 0 && Inventory.instance.money >= priceHp && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            hpAvailable --;

            PlayerController.lifeMax += hpUpgradeValue;
            PlayerController.instance.life += hpUpgradeValue;
            hpUpgradeNumber ++;
            bonusHpTMP.text = "Points de vie x" + (100 + hpUpgradeValue * hpUpgradeNumber) + "%";

            Inventory.instance.money -= priceHp;
            Inventory.instance.UpdateMoneyTMP();
            HpButtonSelected();
            itemLeftHpTMP.text = "Left : " + hpAvailable;
            buySoundEvent.Play(audioSource);
            
        }
        else if(Inventory.instance.money < priceHp && hpAvailable > 0 && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            notEnoughMoneyTMP.enabled = true;
            audioSource.PlayOneShot(notAvailiableAudioClip);
        }
    }

    //public Fireball refFireball;

    public void UpgradeDamage()
    {
        if(damageAvailable > 0 && Inventory.instance.money >= priceDamage && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            damageAvailable --;

            damageMultiplierValue += damageUpgradeMultiplierValue;
            bonusDamageTMP.text = "Dégâts x" + damageMultiplierValue*100 + "%";
            
            Inventory.instance.money -= priceDamage;
            Inventory.instance.UpdateMoneyTMP();
            DamageButtonSelected();
            itemLeftDamageTMP.text = "Left : " + damageAvailable;
            buySoundEvent.Play(audioSource);
        }
        else if (damageAvailable > 0 && Inventory.instance.money < priceDamage && timerDelay >= hitDelay)
        {
            timerDelay = 0f;
            notEnoughMoneyTMP.enabled = true;
            audioSource.PlayOneShot(notAvailiableAudioClip);
        }
    }







    //REAL TIME CHECK IF BUTTON CAN BE PURCHASED OR NOT
    public void UpdateUnselectedShopButton()
    {
        notEnoughMoneyTMP.enabled = false;
        //Debug.Log(notEnoughMoneyTMP);

        if(CastSpellNew.instance.limit >= 0 && fireballAltAvailable)
        {
            matButtonFireball.material = greyUi;
        }
        else
        {
            matButtonFireball.material = greyLockedUi;
        }


        if(CastSpellNew.instance.limit >= 1 && fireCloneAltAvailable)
        {
            matButtonFireClone.material = greyUi;
        }
        else
        {
            matButtonFireClone.material = greyLockedUi;
        }


        if(CastSpellNew.instance.limit >= 2 && telekinesisCloneAltAvailable)
        {
            matButtonTelekinesisClone.material = greyUi;
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
            matButtonIceClone.material = greyUi;
        }
        else
        {
            matButtonIceClone.material = greyLockedUi;
        }

        if(hpAvailable > 0)
        {
            matButtonHp.material = greyUi;
        }
        else 
        {
            matButtonHp.material = greyLockedUi;
        }

        if(damageAvailable > 0)
        {
            matButtonDamage.material = greyUi;
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
            matButtonFireball.material = whiteUi;
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
            matButtonFireClone.material = whiteUi;
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
            matButtonTelekinesisClone.material = whiteUi;
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
            matButtonIceClone.material = whiteUi;
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
            matButtonHp.material = whiteUi;
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
            matButtonDamage.material = whiteUi;
            descriptionTMP.text = descriptionDamage;
        }
        else
        {
            matButtonDamage.material = selectedGreyLockedUi;
            descriptionTMP.text = soldOut;
        }
    }

    
    
}
