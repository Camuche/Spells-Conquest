using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShootLaser : MonoBehaviour
{

    [SerializeField] GameObject Laser;
    [SerializeField] GameObject enemyShield;
    [SerializeField] float activeTimer;
    [SerializeField] float cooldownTimer;
    [SerializeField] Vector3 _laserStart;
    Vector3 laserStart;


    bool active = false;
    bool canDestroy = false;
    float timer = 0;
    GameObject player;


    GameObject shield;

    public float chargingAnimationTime;
    MeshRenderer selfMeshRenderer;

    public Material matCharging;
    public Material matNormal;

    bool playerDead;
    
        

    // Start is called before the first frame update
    void Start()
    {
        shield = Instantiate(enemyShield, transform);
        player = GameObject.Find("Player");
        selfMeshRenderer = GetComponent<MeshRenderer>();
        
    }


    GameObject l;

    // Update is called once per frame
    void Update()
    {

        playerDead = player.GetComponent<PlayerController>().isDead;

        if (isSeeingPlayer() && playerDead == false)
        {
            timer -= Time.deltaTime;
        }
        else
        {
            timer = cooldownTimer;
            
        }

        if(playerDead == true)
        {
            active = false;
            Destroy(l);
        }

        if (timer <= 0 )
        {
            active = !active;

            if(canDestroy && !active)
            {
                Destroy(l);
            }

            if (active && playerDead == false)
            {
                l = Instantiate(Laser);
                SetLaser();
                canDestroy = true;
            }
            else
            {
                canDestroy = false;
            }

            timer = active ? activeTimer : cooldownTimer;
        }

        // PREVISUALISATION CHARGE COLOR !!

        if (timer >= 0 && timer <= chargingAnimationTime && !active &&selfMeshRenderer.material != matCharging && playerDead == false)
        {
            //Debug.Log("Charging");
            selfMeshRenderer.material = matCharging;
        }

        else if (selfMeshRenderer.material != matNormal)
        {
            selfMeshRenderer.material = matNormal;
        }



        if (active)
        {
            SetLaser();
        }


        SetShield();

        if (isSeeingPlayer())
        {
            SetRotation();
        }
        else
        {
            active = false;
            if (canDestroy && !active)
            {
                Destroy(l);
            }
        }


    }


    void SetLaser()
    {
        l.transform.position = transform.position + laserStart;
        if (isSeeingPlayer())
        {
            l.transform.rotation = Quaternion.LookRotation(player.transform.position - transform.position);
        }
    }

    void SetShield()
    {
        shield.transform.position = transform.position;
        shield.SetActive(!active);
    }

    bool isSeeingPlayer()
    {
        RaycastHit hit;
        Physics.Raycast(transform.position, (player.transform.position - transform.position).normalized, out hit, Mathf.Infinity, ~0, QueryTriggerInteraction.Ignore);

        if (hit.transform.gameObject == null)
            return false;

        if (Vector3.Distance(player.transform.position, transform.position) > GetComponent<EnemyFollower>().followDistance)
        {
            return false;
        } 

        if (GameObject.Find("PrefabFireShield(Clone)")!=null)
        {
            return hit.collider.gameObject == player.gameObject || hit.transform.parent.gameObject == GameObject.Find("PrefabFireShield(Clone)");
        }
        else
        {
            return hit.collider.gameObject == player.gameObject;
        }
    }

    void SetRotation()
    {
        transform.rotation = Quaternion.LookRotation((player.transform.position- transform.position).normalized); ;
    }


    private void OnDestroy()
    {
        if (active)
        {
            Destroy(l);
        }
    }
}
