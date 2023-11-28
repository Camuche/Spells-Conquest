using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class IceExplosion : MonoBehaviour
{

    [SerializeField] float size;
    [SerializeField] float duration;
    [SerializeField] float timeBetweenDamage, iceExplosionDamage;
    bool hitNow = false;
    


    private void OnValidate()
    {
        transform.localScale = Vector3.one * size;
    }


    // Start is called before the first frame update
    void Start()
    {
        transform.localScale = Vector3.one * size;
        timer = timeBetweenDamage;
        //InvokeRepeating("Damage",0,timeBetweenDamage);
    }

    // Update is called once per frame
    void Update()
    {
        duration -= Time.deltaTime;

        if (duration <= 0)
        {
            GetComponent<SphereCollider>().radius = 0;
            Destroy(gameObject,0.1f);
        }

        timer += Time.deltaTime;
        if(timer>= timeBetweenDamage)
        {
            timer = 0;
            hitNow = true;
        }

        //List of all ennemies frozen
        Transform[] gos = EnemyManager.instance.transform.GetComponentsInChildren<Transform>() as Transform[];
        foreach (Transform gotr in gos)
        {
            GameObject go = gotr.gameObject;

            if (go.GetComponent<EnemyFollower>() != null && Vector3.Distance(go.transform.position, transform.position) <= size && hitNow)
            {
                Debug.Log(go.name);
                go.GetComponent<EnemyLife>().life -= iceExplosionDamage * Shop.instance.damageMultiplierValue;
                //Debug.Log(Vector3.Distance(go.transform.position , transform.position));
            }
            
            
            //Debug.DrawLine(go.transform.position, transform.position, Color.red, 10f);
            //if (Vector3.Distance(go.transform.position, transform.position) <= size)
        }
        hitNow = false;

    }

    float timer = 0;

    private void OnTriggerStay(Collider other)
    {

        //print(other.name);

        //ENEMIES
        NavMeshAgent navMeshAgent;
        other.gameObject.TryGetComponent<NavMeshAgent>(out navMeshAgent);
        if (navMeshAgent != null)
        {
            navMeshAgent.enabled = false;
        }

        EnemyFollower followerComp;
        other.gameObject.TryGetComponent<EnemyFollower>(out followerComp);
        if (followerComp != null)
        {
            followerComp.enabled = false;
        }

        EnemyCharging chargingComp;
        other.gameObject.TryGetComponent<EnemyCharging>(out chargingComp);
        if (chargingComp != null)
        {
            chargingComp.enabled = false;
        }

        EnemyShooting shootingComp;
        other.gameObject.TryGetComponent<EnemyShooting>(out shootingComp);


        if (shootingComp != null)
        {
            shootingComp.enabled = false;
        }

        //PROJECTILES
        /*EnemyProjectiles projComp;
        other.gameObject.TryGetComponent<EnemyProjectiles>(out projComp);

        if (projComp != null)
        {
            projComp.enabled = false;

        }*/

        //PLAYER
        /*PlayerController playerController;
        other.gameObject.TryGetComponent<PlayerController>(out playerController);

        if (playerController != null)
        {
            playerController.enabled = false;

        }

        CastSpell castSpell;
        other.gameObject.TryGetComponent<CastSpell>(out castSpell);

        if (castSpell != null)
        {
            castSpell.enabled = false;

        }*/

        EnemyFlying enemyFlying;
        other.gameObject.TryGetComponent<EnemyFlying>(out enemyFlying);

        if (enemyFlying != null)
        {
            enemyFlying.enabled = false;

        }

        /*EnemyLife enemyLife;
        other.gameObject.TryGetComponent<EnemyLife>(out enemyLife);

        
        if (enemyLife != null && hitNow)
        {
            
            //other.GetComponent<EnemyLife>().life -= iceExplosionDamage;
            Debug.Log("hit");
            print(other.name);
            hitNow = false;
           
        }*/
    }

    private void OnTriggerExit(Collider other)
    {
        NavMeshAgent navMeshAgent;
        other.gameObject.TryGetComponent<NavMeshAgent>(out navMeshAgent);
        if (navMeshAgent != null)
        {
            navMeshAgent.enabled = true;
        }

        EnemyFollower followerComp;
        other.gameObject.TryGetComponent<EnemyFollower>(out followerComp);
        if (followerComp != null)
        {
            followerComp.enabled = true;
        }

        EnemyCharging chargingComp;
        other.gameObject.TryGetComponent<EnemyCharging>(out chargingComp);
        if (chargingComp != null)
        {
            chargingComp.enabled = true;
        }

        EnemyShooting shootingComp;
        other.gameObject.TryGetComponent<EnemyShooting>(out shootingComp);
        if (shootingComp != null)
        {
            shootingComp.enabled = true;
        }

        //PROJECTILES
        /*EnemyProjectiles projComp;
        other.gameObject.TryGetComponent<EnemyProjectiles>(out projComp);

        if (projComp != null)
        {
            projComp.enabled = true;

        }*/

        //PLAYER
        /*PlayerController playerController;
        other.gameObject.TryGetComponent<PlayerController>(out playerController);

        if (playerController != null)
        {
            playerController.enabled = true;

        }

        CastSpell castSpell;
        other.gameObject.TryGetComponent<CastSpell>(out castSpell);

        if (castSpell != null)
        {
            castSpell.enabled = true;

        }*/

        EnemyFlying enemyFlying;
        other.gameObject.TryGetComponent<EnemyFlying>(out enemyFlying);

        if (enemyFlying != null)
        {
            enemyFlying.enabled = true;

        }
    }

    

}
