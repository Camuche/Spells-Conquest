using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IceClone : MonoBehaviour
{

    [SerializeField] GameObject iceExplosion;
    [SerializeField] float timer;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        timer -= Time.deltaTime;

        if (timer <= 0) {
            GameObject i = Instantiate(iceExplosion);
            i.transform.position = transform.position;
            Destroy(gameObject);
        }
    }
}
