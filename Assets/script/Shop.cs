using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shop : MonoBehaviour
{
    //SPELLS AVAILABLE
    bool fireballAltAvailable = true, fireShieldAltAvailable = true, telekinesisCloneAltAvailable = true;
    //STATS AVAILABLE
    int hpAvailable=0, dpAvailable=0;
    //CONSOMMABLE
    int hpPotionAvailable=0, hpBonusPotionAvailable=0;
    
    [SerializeField] private int baseStatsAvailable, basePotionAvailable;

    [SerializeField] GameObject player;


    // Start is called before the first frame update
    void Start()
    {
        hpAvailable = baseStatsAvailable;
        dpAvailable = baseStatsAvailable;

        hpPotionAvailable = basePotionAvailable;
        hpBonusPotionAvailable = basePotionAvailable;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void StatHp()
    {
        if(hpAvailable > 0)
        {
            hpAvailable --;
            Debug.Log("Stat HP left :" + hpAvailable);
        }
        player.GetComponent<PlayerController>().lifeMax += 20;
    }
}
