using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{
    bool canSave = false;
    [SerializeField]GameObject gameController;
    GameObject player;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
        if (canSave)
        {
            gameController.GetComponent<gameController>().CheckPoint = new Vector3(transform.position.x,player.transform.position.y,transform.position.z);
            gameController.GetComponent<gameController>().checkpointed = true;
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
