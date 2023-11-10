using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Inventory : MonoBehaviour
{
    [HideInInspector] public int money = 0;
    [SerializeField] int moneyValue;

    //SPELLS
    [HideInInspector] public bool fireballAlt = false, fireCloneAlt = false, telekinesisCloneAlt = false;

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
        moneyTMP.text = money + "$";
        
        
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log("money : " + money + "$");
        //Debug.Log(fireCloneAlt);
        //Debug.Log(moneyTMP.text.ToString());
        //GameObject.Find("UI").transform.Find("CameraUI").transform.Find("UIPlane").transform.Find("MoneyValueTMP").GetComponent<TMP_Text>().text = "test";
        //moneyTMP.GetComponent<TMP_Text>().text = "test";
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Money")
        {
            money += moneyValue;
            Destroy(other.gameObject);
            moneyTMP.text = money + "$";
            //Debug.Log("money : " + money + "$");
        }
    }

    public void UpdateMoneyTMP()
    {
        moneyTMP.text = money + "$";
    }
}
