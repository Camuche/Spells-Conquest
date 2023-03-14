using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportArena : MonoBehaviour
{
    [SerializeField] GameObject TeleportTriggerToHub;
    //int enemyAliveNumber =0;

    public GameObject[] listEnemyAlive;


    [SerializeField] GameObject player;
    [SerializeField] GameObject enemyLaser;

    



    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        

        //listEnemyAlive = GameObject.FindGameObjectsWithTag("Enemi");
        //Debug.Log(listEnemyAlive.Length);
        
        

    }

    public void TeleportPlayerToArena(PuzzleTrigger puzzleTrigger)
    {
        player.GetComponent<CharacterController>().enabled = false;
        player.transform.position = new Vector3(0, 1, 0);
        player.GetComponent<CharacterController>().enabled = true;

        puzzleTrigger.numberInTrigger = 0;

    }

    public void TeleportPlayerToHub(PuzzleTrigger puzzleTrigger)
    {
        player.GetComponent<CharacterController>().enabled = false;
        player.transform.position = new Vector3(100, 1, 0);
        player.GetComponent<CharacterController>().enabled = true;

        puzzleTrigger.numberInTrigger = 0;
    }

    public void SetEnemyCharging()
    {
        Instantiate(enemyLaser, new Vector3(0, 1, 30),Quaternion.identity);
        
    }

    
}
