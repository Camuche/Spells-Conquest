using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyLife : MonoBehaviour
{

    public int life;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.name.Contains("Fireball"))
        {
            life -= 10;
        }

        if (life <= 0)
        {
            Destroy(gameObject);
        }
    }
}
