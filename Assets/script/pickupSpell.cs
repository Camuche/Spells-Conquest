using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pickupSpell : MonoBehaviour
{

    bool canPickUp = false;
    GameObject player;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (canPickUp && Input.GetButtonDown("Interact"))
        {
            player.GetComponent<CastSpell>().limit++;
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
