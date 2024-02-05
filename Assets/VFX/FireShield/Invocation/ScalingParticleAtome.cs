using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScalingParticleAtome : MonoBehaviour
{
    
    float time, scaling, t;
    bool scalingUp = true;
    public float speed, timerBeforeDestroy;

    void Start()
    {
        Invoke("DestroyAtome", timerBeforeDestroy);
    }
    
    void Update()
    {
        time += Time.deltaTime * speed;
        t = Mathf.Sin(time) /2 + 0.5f;
        scaling = Mathf.Lerp(0,1, t);
        transform.localScale = new Vector3 (scaling,scaling,scaling);
    }

    void DestroyAtome()
    {
        Destroy(gameObject);
    }
}
