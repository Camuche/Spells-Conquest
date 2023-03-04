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
        gameController = GameObject.Find("GameController");
    }

    // Update is called once per frame
    void Update()
    {


        if (canSave)
        {
            gameController.GetComponent<gameController>().CheckPoint = new Vector3(transform.position.x,player.transform.position.y,transform.position.z);
            gameController.GetComponent<gameController>().checkpointed = true;
            gameController.GetComponent<gameController>().spellLimit = player.GetComponent<CastSpell>().limit;
            gameController.GetComponent<gameController>().setSpellsToDestroy();

        }
        
    }

    private void OnTriggerEnter(Collider other)
    {

        if (other.name == "Player")
        {
            player = other.gameObject;
            canSave = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.name == "Player")
        {
            canSave = false;
        }
    }
}
