using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveToLocation : MonoBehaviour
{
    
    public float speed;

    public bool goUp;
    public float upDistance;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(goUp)
        {
            transform.position = Vector3.MoveTowards(transform.position, transform.position + Vector3.up * upDistance , Time.deltaTime * speed);
        }
    }
}
