using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyProjectiles : MonoBehaviour
{
    
    public Vector3 dir;

    [HideInInspector]
    public int dammage;
    public GameObject Spawner;
    public float speed;



    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame

    public LayerMask mask;

    void Update()
    {


        RaycastHit hit;
        Physics.Raycast(transform.position, (transform.position - (transform.position + dir)).normalized,out hit,speed*Time.deltaTime+GetComponent<SphereCollider>().radius,mask);

        if (hit.transform == null)
        {
            transform.position += dir * speed * Time.deltaTime;
        }
        else
        {
            transform.position += dir * (hit.distance- GetComponent<SphereCollider>().radius);
        }
    }

    private void OnTriggerEnter(Collider other)
    {

        if (other.name == "Player")
        {
            other.GetComponent<PlayerController>().life -= dammage;
        }

        if (other.gameObject != Spawner && !other.isTrigger)
            Destroy(gameObject);

    }
}
