using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Inventory : MonoBehaviour
{
    [HideInInspector] public int money = 0;
    [SerializeField] int moneyValue;

    //SPELLS
    [HideInInspector] public bool fireballAlt = false, fireCloneAlt = false, telekinesisCloneAlt = false, waveAlt = false, iceballAlt = false, iceCloneAlt = false;

    //CONSOMMABLE
    [HideInInspector] public float hpPotionNb = 0, bonusHpPotionNb = 0;

    [HideInInspector] public TMP_Text moneyTMP;
    
    public static Inventory instance;
    

    void Awake()
    {
        instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        moneyTMP = GameObject.Find("MoneyValueTMP").GetComponent<TMP_Text>();
        UpdateMoneyTMP();
        
        
    }


    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Money")
        {
            money += moneyValue;
            Destroy(other.gameObject);
            UpdateMoneyTMP();
            //Debug.Log("money : " + money + "$");
        }
    }

    public void UpdateMoneyTMP()
    {
        moneyTMP.text = money + "$";
        Shop.instance.moneyShopTMP.text = money + "$";
    }
}
