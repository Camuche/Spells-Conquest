using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MovementPlate : MonoBehaviour
{
    float sinMove;
    float posInitX;
    public float speed;
    float timer;
    bool boolEnable = true;


    // Start is called before the first frame update
    void Start()
    {
        posInitX = transform.position.x;
    }

    // Update is called once per frame
    void Update()
    {
        
        if(boolEnable == true)
        {
            timer += Time.deltaTime *speed;
        }
        
        
        sinMove = posInitX + Mathf.Sin(timer) *7f;
        
        
        transform.position = new Vector3(sinMove, transform.position.y, transform.position.z);
        
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "IceExplosion")
        {
            boolEnable = false;
        }

        if (other.name == "Player")
        {
            other.transform.parent = transform;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "IceExplosion")
        {
            boolEnable = true;
        }

        if (other.name == "Player")
        {
            other.transform.parent = null;
        }
    }
}
