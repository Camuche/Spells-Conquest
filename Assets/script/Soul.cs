using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class Soul : MonoBehaviour
{


    [HideInInspector] public int soulMoney;



    // Start is called before the first frame update
    void Start()
    {

        //Debug.Log(soulMoney);
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log("soul money : " + soulMoney);
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player")
        {
            Inventory.instance.money += soulMoney;
            Inventory.instance.UpdateMoneyTMP();
            Destroy(gameObject);
        }
    }
}
