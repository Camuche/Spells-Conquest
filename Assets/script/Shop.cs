using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Shop : MonoBehaviour
{
    bool canInteract = false;
    bool inShop = false;

    //public float [,] shopItems = new int [3];

    [SerializeField] private InputActionReference interact;



    void OnEnable()
    {
        interact.action.performed += PerformInteract;
    }
    void OnDisable()
    {
        interact.action.performed -= PerformInteract;
    }

    void PerformInteract(InputAction.CallbackContext obj)
    {
        if(canInteract == true)
        {
            if(inShop == false)
            {
                Debug.Log("enter shop");
                inShop = true;
            }
            else 
            {
                Debug.Log("exit shop");
                inShop = false;
            }
        }
    }




    // Start is called before the first frame update
    void Start()
    {
        /*//ID's
        shopItems[1,1] = 1; //AltFireball
        shopItems[1,2] = 2;
        shopItems[1,3] = 3;
        
        //Price
        shopItems[2,1] = 0;
        shopItems[2,2] = 0;
        shopItems[2,3] = 0;

        //Quantity
        shopItems[3,1] = 0;
        shopItems[3,2] = 0;
        shopItems[3,3] = 0;*/


    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerEnter (Collider other)
    {
        if(other.tag == "Player")
        {
            canInteract = true;
        }
    }
    void OnTriggerExit (Collider other)
    {
        if(other.tag == "Player")
        {
            canInteract = false;
        }
    }
}
