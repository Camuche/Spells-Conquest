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

    public GameObject healPS;
    GameObject player;

    //Inventory inventory;
    UIupdate uiUpdate;

    bool startDone;
    //TEMPORARY
    //[SerializeField] private InputActionReference northButton, leftButton, RightButton;
    

    // Start is called before the first frame update
    void Start()
    {
        //uiUpdate = GameObject.Find("GameController").GetComponent<UIupdate>();
        //player = GameObject.Find("Player");
        startDone = false;
        Invoke("StartContent", Time.deltaTime * 10);
        //inventory = GameObject.Find("Player").GetComponent<Inventory>();
    }

    void StartContent()
    {
        uiUpdate = GameObject.Find("GameController").GetComponent<UIupdate>();
        player = GameObject.Find("Player");
        startDone = true;
    }

    // Update is called once per frame
    void Update()
    {
        if (!startDone)
        {
            return;
        }

        //Debug.Log( PlayerController.instance.refPlayerInput.currentActionMap.name);
        if(interact.action.ReadValue<float>() == 0)
        {
            interactReleased = true;
        }

        //Debug.Log(""+canInteract+" "+inShop+" "+interactReleased);
        if(interact.action.IsPressed() && canInteract == true && inShop == false && interactReleased == true)
        {
            player = GameObject.Find("Player");
            Time.timeScale = 0.05f;
            inShop = true;
            interactReleased = false;
            PlayerController.instance.life = PlayerController.lifeMax;
            Instantiate(healPS, player.transform.position, Quaternion.identity);
            PlayHealClip();
            Invoke("EnterShop", 2f*0.05f);
        }
        else if(shopCancel.action.IsPressed() && canInteract == true && inShop == true && interactReleased == true)
        {
            player = GameObject.Find("Player");
            Time.timeScale = 1f;
            inShop = false;
            interactReleased = false;

            uiUpdate.DisableShopUi();
            PlayerController.instance.refPlayerInput.SwitchCurrentActionMap("PlayerInput");
            Cursor.lockState = CursorLockMode.Locked;
        }
    }

    public AudioClip shopMenuClip;

    void EnterShop()
    {
        uiUpdate.EnableShopUi();
        Shop.instance.UpdateUnselectedShopButton();
        CustomUIManager.instance.currentSelected.PerformOnSelect();
        PlayerController.instance.refPlayerInput.SwitchCurrentActionMap("ShopInput");
        Cursor.lockState = CursorLockMode.None;
        audioSource.PlayOneShot(shopMenuClip);
    }


    public AudioSource audioSource;
    public AudioClip healClip;

    void PlayHealClip()
    {
        audioSource.clip = healClip;
        audioSource.Play();
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
