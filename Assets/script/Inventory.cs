using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    [HideInInspector] public int money = 0;
    [SerializeField] int moneyValue;

    //SPELLS
    [HideInInspector] public bool fireballAlt = false, fireShieldAlt = false, telekinesisCloneAlt = false;

    //CONSOMMABLE
    [HideInInspector] public float hpPotionNb = 0, bonusHpPotionNb = 0;



    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log("money : " + money + "$");
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Money")
        {
            money += moneyValue;
            Destroy(other.gameObject);
            Debug.Log("money : " + money + "$");
        }
    }
}
