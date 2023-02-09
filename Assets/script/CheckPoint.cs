using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{
    bool canSave = false;
    GameObject gameController;
    GameObject player;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Interact") && canSave)
        {
            gameController.GetComponent<gameController>().CheckPoint = player.transform.position;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        player = other.gameObject;
        canSave = true;
    }

    private void OnTriggerExit(Collider other)
    {
        canSave = false;
    }
}
