using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyShooting : MonoBehaviour
{
    GameObject player;
    public float delay;
    float timer;
    public GameObject Bullet;
    
    public int BulletDammage;
    public float BulletSpeed;
    float rotationSpeed ;
    public GameObject spawnPos;

    public AudioSource audioSource;
    public AudioClip shootAudioClip;

    // Start is called before the first frame update
    void Start()
    {
        rotationSpeed = 5f;
        player = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        //gameObject.transform.rotation = Quaternion.LookRotation(Vector3.RotateTowards(transform.forward, player.transform.position - transform.position, rotationSpeed * Time.deltaTime, 0.0f));
        

        

        timer += Time.deltaTime;

        if (timer >= delay && PlayerController.instance.life>0)
        {

            if (gameObject.GetComponent<EnemyFollower>().dir != Vector3.zero && (GameObject.Find("Player").transform.position-transform.position).magnitude< gameObject.GetComponent<EnemyFollower>().followDistance)
            {
                audioSource.PlayOneShot(shootAudioClip);

                GameObject b = Instantiate(Bullet);
                //b.GetComponent<EnemyProjectiles>().dir = gameObject.GetComponent<EnemyFollower>().dir;
                b.GetComponent<EnemyProjectiles>().dir = (player.transform.position - spawnPos.transform.position).normalized;
                b.transform.position = spawnPos.transform.position;
                b.GetComponent<EnemyProjectiles>().Spawner = gameObject;
                b.GetComponent<EnemyProjectiles>().dammage = BulletDammage;
                b.GetComponent<EnemyProjectiles>().speed = BulletSpeed;
                timer = 0;
            }
        }

        
        

    }
}
