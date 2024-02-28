using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pot : MonoBehaviour
{
    [SerializeField] private GameObject money;
    [SerializeField] private int potMoneyNumber;

    float isEnlightened;
    GameObject cristal;
    float lerpTime;
    public float lerpSpeed;
    bool changeColor;

    void Start()
    {
        cristal = gameObject.transform.Find("Placeholer_Pierre_Precieuse_low").gameObject;
        isEnlightened = cristal.GetComponent<Renderer>().material.GetFloat("_isEnlightened");
    }

    void Update()
    {
        if(changeColor && lerpTime <= 1 )
        {
            lerpTime += 0.0001f * lerpSpeed;
            isEnlightened = Mathf.Lerp(isEnlightened, 1 , lerpTime);
            cristal.GetComponent<Renderer>().material.SetFloat("_isEnlightened"  ,isEnlightened);
        }      
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Aura" && !changeColor)
        {   
            for (int i=0; i<potMoneyNumber; i++)
            {
                Instantiate(money, transform.position +new Vector3(Random.Range(-1f,1f),0,Random.Range(-1f,1f)), transform.rotation * Quaternion.Euler(0,Random.Range(-180f,180f),0));
            }

            //do once
            changeColor = true;
        }
    }
}
