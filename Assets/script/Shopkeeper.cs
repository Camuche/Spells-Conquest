using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Shopkeeper : MonoBehaviour
{
    bool canInteract = false;
    bool inShop = false;

    bool fireballAlt = false, fireCloneAlt = false, telekinesisCloneAlt = false;
    [SerializeField] int priceFireball, priceFireClone, priceTelekinesisClone;


    [SerializeField] private InputActionReference interact;

    private GameObject cameraShop;
    Inventory inventory;


    //TEMPORARY
    [SerializeField] private InputActionReference northButton, leftButton, RightButton;
    

    // Start is called before the first frame update
    void Start()
    {
        cameraShop = GameObject.Find("CameraShop");
        cameraShop.SetActive(false);
        inventory = GameObject.Find("Player").GetComponent<Inventory>();
    }

    // Update is called once per frame
    void Update()
    {
        if(interact.action.IsPressed() && canInteract == true && inShop == false)
        {
            inShop = true;
            //cameraShop.SetActive(true);
            //Time.timeScale = 0f;
            Debug.Log(inShop);            
        }
        //Debug.Log(inventory.money);

        //TEMPORARY
        if (canInteract && leftButton.action.IsPressed() && inventory.money >= priceFireball && fireballAlt == false)
        {
            inventory.fireballAlt = true;
            fireballAlt = true;
            inventory.money -= priceFireball;
        }
        if (canInteract && northButton.action.IsPressed() && inventory.money >= priceFireClone && fireCloneAlt == false)
        {
            inventory.fireCloneAlt = true;
            fireCloneAlt = true;
            inventory.money -= priceFireClone;
        }
        if (canInteract && RightButton.action.IsPressed() && inventory.money >= priceTelekinesisClone && telekinesisCloneAlt == false)
        {
            inventory.telekinesisCloneAlt = true;
            telekinesisCloneAlt = true;
            inventory.money -= priceTelekinesisClone;
        }

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
