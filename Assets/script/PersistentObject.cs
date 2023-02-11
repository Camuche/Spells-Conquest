using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PersistentObject : MonoBehaviour
{


    private static PersistentObject instance;
    void Awake()
    {
        if (instance != null && instance != this)
        {
            print("destroyed");
            Destroy(gameObject);
        }
        else
        {
            DontDestroyOnLoad(gameObject);

            instance = this;
        }
    }
}
