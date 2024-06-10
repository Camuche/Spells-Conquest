using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PotForChild : MonoBehaviour
{

    float isEnlightened;
    public GameObject[] cristal;
    float lerpTime;
    public float lerpSpeed;
    bool changeColor;

    public bool lightOnTrigger;

    void Start()
    {
        foreach (GameObject go in cristal)
        {
            isEnlightened = go.GetComponent<Renderer>().material.GetFloat("_isEnlightened");
        }
        
    }

    void Update()
    {
        if (lightOnTrigger && changeColor && lerpTime <= 1)
        {
            lerpTime += Time.deltaTime * lerpSpeed;
            isEnlightened = Mathf.Lerp(isEnlightened, 1.2f , lerpTime);
            foreach (GameObject go in cristal)
            {
                go.GetComponent<Renderer>().material.SetFloat("_isEnlightened", isEnlightened);
                //go.GetComponent<Renderer>().material.SetFloat("_EmissiveIntensity", isEnlightened);
            }
        }

        else if (changeColor && lerpTime <= 1)
        {
            lerpTime += Time.deltaTime * lerpSpeed;
            isEnlightened = Mathf.Lerp(isEnlightened, 0.2f, lerpTime);
            foreach (GameObject go in cristal)
            {
                go.GetComponent<Renderer>().material.SetFloat("_isEnlightened", isEnlightened);
            }
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Aura" && !changeColor)
        {
            //do once
            changeColor = true;
            GetComponent<AudioSource>().Play();
        }
    }
}
