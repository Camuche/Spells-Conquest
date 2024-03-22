using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireShieldDecalTrail : MonoBehaviour
{
    Material mat;
    bool unscale;
    float fadeValue;
    public float speed, speed2 , timeBeforeUnscale;

    // Start is called before the first frame update
    void Start()
    {
        mat = GetComponent<MeshRenderer>().material;
        mat.SetFloat("_Fade", fadeValue);
        Invoke("Unscale", timeBeforeUnscale);
        //fadeValue = 0.9f;
    }

    // Update is called once per frame
    void Update()
    {
        if(!unscale && fadeValue < 1)
        {
            fadeValue += Time.deltaTime * speed;
        }
        else if(!unscale && fadeValue > 1)
        {
            fadeValue = 1;
        }
        else if (unscale && fadeValue > 0)
        {
            fadeValue -= Time.deltaTime * speed2;
        }
        else if (unscale && fadeValue <= 0)
        {
            Destroy(gameObject);
        }
        
        mat.SetFloat("_Fade", fadeValue);
    }

    void Unscale()
    {
        unscale = true;
    }
}
