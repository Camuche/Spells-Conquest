using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeShaderValue : MonoBehaviour
{
    public GameObject materialGameObject;
    public string shaderValueName;
    public float startValue, endValue, speed;
    public bool destroyGameObjectAtEnd;
    public GameObject destroyGameObject;

    public bool instantiateOnTrigger;
    public GameObject instantiateGameObject;

    float shaderValue;
    bool changeValue;

    // Start is called before the first frame update
    void Start()
    {
        shaderValue = startValue;
    }

    // Update is called once per frame
    void Update()
    {
        if (changeValue)
        {
            shaderValue += Time.deltaTime * speed;
            materialGameObject.GetComponent<MeshRenderer>().material.SetFloat(shaderValueName,shaderValue);
            if (destroyGameObjectAtEnd && shaderValue >= endValue)
            {
                Destroy(destroyGameObject);
            }
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Fireball" || other.tag == "FireShield")
        {
            if (instantiateOnTrigger)
            {
                Instantiate(instantiateGameObject, transform.position, Quaternion.identity);
            }
            changeValue = true;
        }
    }
}
