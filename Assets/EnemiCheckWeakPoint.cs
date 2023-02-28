using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemiCheckWeakPoint : MonoBehaviour
{


    [SerializeField] GameObject[] weakPoints;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (checkWeakPoint() == 0)
            Destroy(gameObject);
    }

    int checkWeakPoint()
    {
        int count = 0;
        for (int i = 0; i < weakPoints.Length; i++)
        {
            if (weakPoints[i] != null)
            {
                count++;
            }
        }

        return count;
    }
}
