using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class pickupSpell : MonoBehaviour
{

    bool canPickUp = false;
    GameObject player;
    GameObject gameController;

    [SerializeField] private InputActionReference interact;

    // Start is called before the first frame update
    void Start()
    {
        gameController = GameObject.Find("GameController");
    }



    void OnEnable()
    {
        interact.action.performed += PerformInteract;
    }

    void OnDisable()
    {
        interact.action.performed -= PerformInteract;
    }

    private void PerformInteract(InputAction.CallbackContext obj)
    {
        if (canPickUp)
        {
            player.GetComponent<CastSpellNew>().limit++;
            //gameController.GetComponent<gameController>().spellLimit++;
            gameController.GetComponent<gameController>().spellsToDestroyNext.Add(transform.position.x.ToString() + transform.position.z.ToString());
            Destroy(gameObject);
        }
    }

    
    

    void OnTriggerEnter(Collider other)
    {
        if (other.name == "Player")
        {
            player = other.gameObject;
            canPickUp = true;
        }

        
    }

    void OnTriggerExit(Collider other)
    {
        if (other.name == "Player")
        {
            canPickUp = false;
        }


    }
}
