using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyShooting : MonoBehaviour
{

    public float delay;
    float timer;
    public GameObject Bullet;
    public Vector3 SpawnPoint;

    // Start is called before the first frame update
    void Start()
    {
        SpawnPoint = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        timer += Time.deltaTime;

        if (timer >= delay)
        {
            GameObject b = Instantiate(Bullet);
            b.GetComponent<EnemyProjectiles>().dir = gameObject.GetComponent<EnemyFollower>().dir;
            b.transform.position = SpawnPoint;
            timer = 0;
        }
    }
}
