using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pickupHeal : MonoBehaviour
{

    bool canPickUp = false;
    [SerializeField]float amount;
    GameObject player;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (canPickUp && PlayerController.instance.life< PlayerController.lifeMax)
        {
            PlayerController.instance.life += amount;
            if (PlayerController.instance.life > PlayerController.lifeMax)
            {
                PlayerController.instance.life = PlayerController.lifeMax;
            }
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
