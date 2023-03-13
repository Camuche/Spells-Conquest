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


    GameObject shield;
    // Start is called before the first frame update
    void Start()
    {
        shield = Instantiate(enemyShield);
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
        l.transform.rotation = transform.rotation;
    }

    void SetShield()
    {
        shield.transform.position = transform.position;
        shield.SetActive(!active);
    }

    bool isSeeingPlayer()
    {
        GameObject player = GameObject.Find("Player");
        RaycastHit hit;
        Physics.Raycast(transform.position, (player.transform.position - transform.position).normalized, out hit, Mathf.Infinity, ~0, QueryTriggerInteraction.Ignore);
        return (hit.collider.gameObject == player.gameObject || hit.transform.parent.gameObject == GameObject.Find("PrefabFireShield(Clone)"));
    }

    void SetRotation()
    {
        GameObject player = GameObject.Find("Player");
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
