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
    // Start is called before the first frame update
    void Start()
    {
        shield = Instantiate(enemyShield);
        player = GameObject.Find("Player");
    }


    GameObject l;

    // Update is called once per frame
    void Update()
    {

        timer -= Time.deltaTime;

        if (timer <= 0)
        {
            active = !active;

            if(canDestroy && !active)
            {
                Destroy(l);
            }

            if (active)
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
