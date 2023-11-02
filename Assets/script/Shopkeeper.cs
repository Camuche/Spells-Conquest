using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class Shopkeeper : MonoBehaviour
{
    bool canInteract = false;
    bool inShop = false;


    [SerializeField] private InputActionReference interact;

    private GameObject cameraShop;
    

    // Start is called before the first frame update
    void Start()
    {
        cameraShop = GameObject.Find("CameraShop");
        cameraShop.SetActive(false);
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
