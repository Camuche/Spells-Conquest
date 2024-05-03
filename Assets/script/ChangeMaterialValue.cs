using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeMaterialValue : MonoBehaviour
{
    bool changeValue;
    string materialValueName;
    [Range(0,1)] float materialValue;
    float changementSpeed;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(changeValue)
        {
            GetComponent<MeshRenderer>().material.SetFloat(materialValueName, GetComponent<MeshRenderer>().material.GetFloat(materialValueName) + Time.deltaTime / changementSpeed);
        }
        
    }

    public void SetSpeed(float speed)
    {
        changementSpeed = speed;
    }

    public void ChangeValue(string valueName)
    {
        materialValueName = valueName;
        changeValue = true;
    }
}
