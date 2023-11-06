using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Chest : MonoBehaviour
{
    [SerializeField] private GameObject money;
    [SerializeField] private int chestMoneyNumber;

    [SerializeField] private InputActionReference interact;
    bool canInteract = false;

    void Update()
    {
        if(canInteract &&  interact.action.IsPressed())
        {
            for (int i=0; i<chestMoneyNumber; i++)
            {
                Instantiate(money, transform.position +new Vector3(Random.Range(-1f,1f),.5f,Random.Range(-1f,1f)), transform.rotation * Quaternion.Euler(0,Random.Range(-180f,180f),0));
            }
            Destroy(gameObject);
            
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Player")
        {
            canInteract = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if(other.tag == "Player")
        {
            canInteract = false;
        }
    }
}
