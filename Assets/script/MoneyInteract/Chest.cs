using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Chest : MonoBehaviour
{
    [SerializeField] private GameObject money;
    [SerializeField] private int chestMoneyNumber;



    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Aura")
        {
            for (int i=0; i<chestMoneyNumber; i++)
            {
                Instantiate(money, transform.position +new Vector3(Random.Range(-1f,1f),.5f,Random.Range(-1f,1f)), transform.rotation * Quaternion.Euler(0,Random.Range(-180f,180f),0));
            }
            Destroy(gameObject);
        }
    }

}
