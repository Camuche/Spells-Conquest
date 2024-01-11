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


    [SerializeField] private InputActionReference interact, shopCancel;
    bool interactReleased =true;

    //Inventory inventory;
    UIupdate uiUpdate;


    //TEMPORARY
    //[SerializeField] private InputActionReference northButton, leftButton, RightButton;
    

    // Start is called before the first frame update
    void Start()
    {
        uiUpdate = GameObject.Find("GameController").GetComponent<UIupdate>();

        //inventory = GameObject.Find("Player").GetComponent<Inventory>();
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log( PlayerController.instance.refPlayerInput.currentActionMap.name);
        if(interact.action.ReadValue<float>() == 0)
        {
            interactReleased = true;
        }

        //Debug.Log(""+canInteract+" "+inShop+" "+interactReleased);
        if(interact.action.IsPressed() && canInteract == true && inShop == false && interactReleased == true)
        {
            Debug.Log("0");
            inShop = true;
            interactReleased = false;

            PlayerController.instance.life = PlayerController.lifeMax;
            Debug.Log("1"); 
            uiUpdate.EnableShopUi();
            Debug.Log("2"); 
            Shop.instance.UpdateUnselectedShopButton();
            Debug.Log("3"); 
            CustomUIManager.instance.currentSelected.PerformOnSelect();
            Debug.Log("4");  
            PlayerController.instance.refPlayerInput.SwitchCurrentActionMap("ShopInput");
            Debug.Log("5");  
            Cursor.lockState = CursorLockMode.None;
            Time.timeScale = 0.05f;
            //Debug.Log(inShop);            
        }
        else if(shopCancel.action.IsPressed() && canInteract == true && inShop == true && interactReleased == true)
        {
            inShop = false;
            interactReleased = false;

            uiUpdate.DisableShopUi();
            PlayerController.instance.refPlayerInput.SwitchCurrentActionMap("PlayerInput");
            Cursor.lockState = CursorLockMode.Locked;
            Time.timeScale = 1f;
            //Debug.Log("leaveShop");   
        }
        
        //Debug.Log(inventory.money);

        //TEMPORARY
        /*if (canInteract && leftButton.action.IsPressed() && inventory.money >= priceFireball && fireballAlt == false)
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
        }*/

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
