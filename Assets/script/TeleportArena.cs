using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportArena : MonoBehaviour
{
    [SerializeField] GameObject TeleportTriggerToHub;
    //int enemyAliveNumber =0;

    public GameObject[] listEnemyAlive;


    [SerializeField] GameObject player;

    [SerializeField] GameObject enemyCharging;
    [SerializeField] GameObject enemyFire;
    [SerializeField] GameObject enemyHeavy;
    [SerializeField] GameObject enemyKamikaze;
    [SerializeField] GameObject enemyLaser;
    [SerializeField] GameObject enemyPhysical;
    [SerializeField] GameObject enemyWeakPoint;
    [SerializeField] GameObject enemyShield;
    [SerializeField] GameObject enemyShooter;
    [SerializeField] GameObject enemyTurret;
    [SerializeField] GameObject enemyFlying;





    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        

        listEnemyAlive = GameObject.FindGameObjectsWithTag("Enemy");
       

        if (listEnemyAlive.Length == 0)
        {
            TeleportTriggerToHub.SetActive(true);
        }
        else
        {
            TeleportTriggerToHub.SetActive(false);
        }
        

    }

    public void TeleportPlayerToArena(PuzzleTrigger puzzleTrigger)
    {
        player.GetComponent<CharacterController>().enabled = false;
        player.transform.position = new Vector3(0, 1, 0);
        player.transform.eulerAngles = new Vector3(0, -90, 0);
        player.GetComponent<CharacterController>().enabled = true;

        puzzleTrigger.numberInTrigger = 0;

    }

    public void TeleportPlayerToHub(PuzzleTrigger puzzleTrigger)
    {
        player.GetComponent<CharacterController>().enabled = false;
        player.transform.position = new Vector3(100, 1, -10);
        player.transform.eulerAngles = new Vector3(0, 180, 0);
        player.GetComponent<CharacterController>().enabled = true;

        puzzleTrigger.numberInTrigger = 0;
    }





    public void SetEnemyCharging()
    {
        Instantiate(enemyCharging, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyFire()
    {
        Instantiate(enemyFire, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyHeavy()
    {
        Instantiate(enemyHeavy, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyKamikaze()
    {
        Instantiate(enemyKamikaze, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyLaser()
    {
        Instantiate(enemyLaser, new Vector3(0, 1, 30),Quaternion.identity);
        
    }
    public void SetEnemyPhysical()
    {
        Instantiate(enemyPhysical, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyWeakpoint()
    {
        Instantiate(enemyWeakPoint, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyShield()
    {
        Instantiate(enemyShield, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyShooter()
    {
        Instantiate(enemyShooter, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyTurret()
    {
        Instantiate(enemyTurret, new Vector3(0, 1, 30), Quaternion.identity);

    }
    public void SetEnemyFlying()
    {
        Instantiate(enemyFlying, new Vector3(0, 1, 30), Quaternion.identity);

    }



}
