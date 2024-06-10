using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeMaterialValue : MonoBehaviour
{
    bool changeValue;
    string materialValueName;
    [Range(0,1)] float materialValue;
    float changementSpeed;
    int index = 0;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (changeValue && GetComponent<MeshRenderer>().materials[index].GetFloat(materialValueName) < 1)
        {
            materialValue = GetComponent<MeshRenderer>().materials[index].GetFloat(materialValueName) + Time.deltaTime / changementSpeed;
            GetComponent<MeshRenderer>().materials[index].SetFloat(materialValueName, materialValue);
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

    public void ChangeMaterialIndex(int newIndex)
    {
        index = newIndex;
    }
}
