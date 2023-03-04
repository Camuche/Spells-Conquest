using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pickupSpell : MonoBehaviour
{

    bool canPickUp = false;
    GameObject player;
    GameObject gameController;

    // Start is called before the first frame update
    void Start()
    {
        gameController = GameObject.Find("GameController");
    }

    // Update is called once per frame
    void Update()
    {
        if (canPickUp && Input.GetButtonDown("Interact"))
        {
            player.GetComponent<CastSpell>().limit++;
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
