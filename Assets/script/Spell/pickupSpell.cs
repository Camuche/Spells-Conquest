using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Events;

public class pickupSpell : MonoBehaviour
{

    bool canPickUp = false;
    GameObject player;
    GameObject gameController;
    public int spellNb;

    [SerializeField] private InputActionReference interact;

    public UnityEvent unityEvent;

    // Start is called before the first frame update
    void Start()
    {
        gameController = GameObject.Find("GameController");
        if (spellNb <= gameController.GetComponent<gameController>().spellLimit)
        {
            Destroy(gameObject);
        }
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
            //gameController.GetComponent<gameController>().spellsToDestroyNext.Add(transform.position.x.ToString() + transform.position.z.ToString());
            gameController.GetComponent<gameController>().spellLimit = player.GetComponent<CastSpellNew>().limit;
            //gameController.GetComponent<gameController>().setSpellsToDestroy();
            unityEvent.Invoke();
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
