using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    [HideInInspector] public int money = 0;
    public int moneyValue;

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
