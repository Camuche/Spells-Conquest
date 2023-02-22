using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class IceExplosion : MonoBehaviour
{

    [SerializeField] float size;
    [SerializeField] float duration;


    private void OnValidate()
    {
        transform.localScale = Vector3.one * size;
    }


    // Start is called before the first frame update
    void Start()
    {
        transform.localScale = Vector3.one * size;
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
    }

    private void OnTriggerStay(Collider other)
    {

        print(other.name);


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

        EnemyProjectiles projComp;
        other.gameObject.TryGetComponent<EnemyProjectiles>(out projComp);

        if (projComp != null)
        {
            projComp.enabled = false;

        }


        PlayerController playerController;
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

        }
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

        EnemyProjectiles projComp;
        other.gameObject.TryGetComponent<EnemyProjectiles>(out projComp);

        if (projComp != null)
        {
            projComp.enabled = true;

        }

        PlayerController playerController;
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

        }
    }

}
