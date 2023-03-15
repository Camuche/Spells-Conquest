using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyShooting : MonoBehaviour
{

    public float delay;
    float timer;
    public GameObject Bullet;
    public Vector3 SpawnPoint;
    public int BulletDammage;
    public float BulletSpeed;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        SpawnPoint = transform.position;

        timer += Time.deltaTime;

        if (timer >= delay)
        {

            if (gameObject.GetComponent<EnemyFollower>().dir != Vector3.zero && (GameObject.Find("Player").transform.position-transform.position).magnitude< gameObject.GetComponent<EnemyFollower>().followDistance)
            {
                GameObject b = Instantiate(Bullet);
                b.GetComponent<EnemyProjectiles>().dir = gameObject.GetComponent<EnemyFollower>().dir;
                b.transform.position = SpawnPoint;
                b.GetComponent<EnemyProjectiles>().Spawner = gameObject;
                b.GetComponent<EnemyProjectiles>().dammage = BulletDammage;
                b.GetComponent<EnemyProjectiles>().speed = BulletSpeed;

                timer = 0;

            }
        }
    }
}
