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
    void Update()
    {
        transform.position += dir * speed*Time.deltaTime;
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
