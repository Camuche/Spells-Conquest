using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Aura : MonoBehaviour
{
    float time, currentScale;
    public float initScale, endScale, scalingTime, timeBeforeDestroy;


    void Update()
    {
        time += Time.deltaTime / scalingTime;
        currentScale = Mathf.Lerp(initScale,endScale,time);
        transform.localScale = new Vector3(currentScale,currentScale,currentScale);
        Invoke("Destroy", timeBeforeDestroy);
    }

    void Destroy()
    {
        Destroy(gameObject);
    }

    public void AuraInstantiate(Transform objectTransform)
    {
        Instantiate(gameObject, objectTransform.position, Quaternion.identity);
    }
}
