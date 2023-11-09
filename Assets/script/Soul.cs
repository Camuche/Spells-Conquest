using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class Soul : MonoBehaviour
{

    //GameObject player;
    [HideInInspector] public int soulMoney;
    Inventory inventory;

    


    // Start is called before the first frame update
    void Start()
    {
        inventory = GameObject.Find("Player").GetComponent<Inventory>();
        Debug.Log(soulMoney);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player")
        {
            //inventory.money += soulMoney;
            //inventory.UpdateMoneyTMP();
            Destroy(gameObject);
        }
    }
}
