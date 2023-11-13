using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shop : MonoBehaviour
{
    //SPELLS AVAILABLE
    bool fireballAltAvailable = true, fireCloneAltAvailable = true, telekinesisCloneAltAvailable = true, waveAltAvailable = true, iceballAltAvailable = true, iceCloneAltAvailable = true;
    [SerializeField] int priceFireball, priceFireClone, priceTelekinesisClone, priceWave, priceIceball, priceIceClone;

    //STATS AVAILABLE
    int hpAvailable=0, dpAvailable=0;
    //CONSOMMABLE
    int hpPotionAvailable=0, hpBonusPotionAvailable=0;
    
    [SerializeField] private int baseStatsAvailable, basePotionAvailable;
    

    GameObject player;

    Inventory inventory;


    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");

        hpAvailable = baseStatsAvailable;
        dpAvailable = baseStatsAvailable;

        hpPotionAvailable = basePotionAvailable;
        hpBonusPotionAvailable = basePotionAvailable;

        inventory = GameObject.Find("Player").GetComponent<Inventory>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    public void UpgradeFireball()
    {
        if(inventory.money >= priceFireball && fireballAltAvailable == true)
        {
            fireballAltAvailable = false;
            inventory.fireballAlt = true;
            inventory.money -= priceFireball;
            inventory.UpdateMoneyTMP();
            Debug.Log("UpdateFireball");
        }
    }

    public void UpgradeFireClone()
    {
        if(inventory.money >= priceFireClone && fireCloneAltAvailable == true)
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
        if(inventory.money >= priceTelekinesisClone && telekinesisCloneAltAvailable == true)
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
        if(inventory.money >= priceWave && waveAltAvailable == true)
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
        if(inventory.money >= priceIceball && iceballAltAvailable == true)
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
        if(inventory.money >= priceIceClone && iceCloneAltAvailable == true)
        {
            iceCloneAltAvailable = false;
            inventory.iceCloneAlt = true;
            inventory.money -= priceIceClone;
            inventory.UpdateMoneyTMP();
            Debug.Log("UpdateIceClone");
        }
    }


    /*void StatHp()
    {
        if(hpAvailable > 0)
        {
            hpAvailable --;
            Debug.Log("Stat HP left :" + hpAvailable);
        }
        player.GetComponent<PlayerController>().lifeMax += 20;
    }*/
    
}
